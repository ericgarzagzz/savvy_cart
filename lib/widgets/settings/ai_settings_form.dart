import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/models/settings/ai_settings.dart';
import 'package:savvy_cart/providers/settings_providers.dart';
import 'package:savvy_cart/services/gemini_api_verification_service.dart';
import 'package:savvy_cart/screens/model_selection_screen.dart';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class AiSettingsForm extends ConsumerStatefulWidget {
  const AiSettingsForm({super.key});

  @override
  ConsumerState<AiSettingsForm> createState() => _AiSettingsFormState();
}

class _AiSettingsFormState extends ConsumerState<AiSettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final _debouncer = Debouncer(milliseconds: 500);
  late TextEditingController _apiKeyController;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    final aiSettings = ref.read(aiSettingsProvider).settings;
    _apiKeyController = TextEditingController(text: aiSettings.apiKey);
    
    // Trigger API verification on load if API key exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (aiSettings.apiKey.isNotEmpty) {
        ref.read(aiSettingsProvider.notifier).verifyApiKey();
      }
    });
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  void _saveSettings(AiSettings settings) {
    ref.read(aiSettingsProvider.notifier).saveSettings(settings);
  }

  @override
  Widget build(BuildContext context) {
    final aiSettingsState = ref.watch(aiSettingsProvider);
    final settings = aiSettingsState.settings;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _apiKeyController,
            onChanged: (value) {
              _debouncer.run(() {
                _saveSettings(settings.copyWith(apiKey: value));
              });
            },
            decoration: InputDecoration(
              label: Text("Google Gemini API Key"),
              border: const OutlineInputBorder(),
              errorText: aiSettingsState.error,
              prefixIcon: Icon(Icons.key),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            obscureText: _obscureText,
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => _navigateToModelSelection(context),
            borderRadius: BorderRadius.circular(4),
            child: InputDecorator(
              decoration: const InputDecoration(
                label: Text("Gemini Model"),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.memory),
                suffixIcon: Icon(Icons.arrow_forward_ios, size: 16),
                helperText: "Choose the AI model to use for processing",
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _getCurrentModelDisplayName(aiSettingsState, settings.model),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  if (settings.model == 'gemini-2.0-flash')
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Recommended',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToModelSelection(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ModelSelectionScreen(),
      ),
    );
  }

  String _getCurrentModelDisplayName(AiSettingsState aiSettingsState, String modelName) {
    // Try to get display name from verified models first
    final models = aiSettingsState.verificationResult?.geminiModels;
    if (models != null) {
      final matchingModel = models.firstWhere(
        (model) => model.cleanName == modelName,
        orElse: () => GeminiModel(name: ''),
      );
      if (matchingModel.name.isNotEmpty) {
        return matchingModel.userFriendlyName;
      }
    }
    
    // Fallback to manual display name formatting
    return _getModelDisplayName(modelName);
  }

  String _getModelDisplayName(String model) {
    // Remove the 'models/' prefix if present
    final cleanModel = model.replaceAll('models/', '');
    
    // Create user-friendly display names
    if (cleanModel == 'gemini-2.0-flash') {
      return 'Gemini 2.0 Flash';
    } else if (cleanModel == 'gemini-1.5-flash') {
      return 'Gemini 1.5 Flash';
    } else if (cleanModel == 'gemini-1.5-pro') {
      return 'Gemini 1.5 Pro';
    } else if (cleanModel == 'gemini-pro') {
      return 'Gemini Pro';
    } else if (cleanModel.startsWith('gemini-')) {
      // For any other gemini models, format them nicely
      return cleanModel
          .replaceAll('gemini-', 'Gemini ')
          .replaceAll('-', ' ')
          .split(' ')
          .map((word) => word[0].toUpperCase() + word.substring(1))
          .join(' ');
    }
    
    return cleanModel;
  }
}
