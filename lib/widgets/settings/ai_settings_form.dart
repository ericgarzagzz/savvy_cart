import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/models/settings/ai_settings.dart';
import 'package:savvy_cart/providers/settings_providers.dart';

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
              label: Text("Gemini API Key"),
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
        ],
      ),
    );
  }
}
