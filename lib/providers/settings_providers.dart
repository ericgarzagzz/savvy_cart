import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/models/settings/ai_settings.dart';
import 'package:savvy_cart/services/gemini_api_verification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AiSettingsState {
  final AiSettings settings;
  final bool isLoading;
  final String? error;
  final ApiVerificationResult? verificationResult;
  final bool isVerifying;

  AiSettingsState({
    required this.settings,
    this.isLoading = false,
    this.error,
    this.verificationResult,
    this.isVerifying = false,
  });

  AiSettingsState copyWith({
    AiSettings? settings,
    bool? isLoading,
    String? error,
    ApiVerificationResult? verificationResult,
    bool? isVerifying,
  }) {
    return AiSettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      verificationResult: verificationResult ?? this.verificationResult,
      isVerifying: isVerifying ?? this.isVerifying,
    );
  }

  bool get hasValidApiKey => verificationResult?.isValid == true;
  
  ApiConnectionStatus get connectionStatus => 
      verificationResult?.status ?? ApiConnectionStatus.notVerified;
}

final aiSettingsProvider = StateNotifierProvider<AiSettingsNotifier, AiSettingsState>((ref) {
  return AiSettingsNotifier();
});

class AiSettingsNotifier extends StateNotifier<AiSettingsState> {
  AiSettingsNotifier()
      : super(AiSettingsState(
          settings: AiSettings(
            apiKey: '',
            model: 'gemini-2.0-flash',
          ),
          isLoading: true,
        )) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString('ai_api_key') ?? '';
      final model = prefs.getString('ai_model') ?? 'gemini-2.0-flash';

      state = state.copyWith(
        settings: AiSettings(
          apiKey: apiKey,
          model: model,
        ),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load settings: $e',
      );
    }
  }

  Future<void> saveSettings(AiSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ai_api_key', settings.apiKey);
    await prefs.setString('ai_model', settings.model);
    state = state.copyWith(settings: settings);
    
    // Auto-verify the API key after saving
    if (settings.apiKey.isNotEmpty) {
      await verifyApiKey();
    } else {
      // Clear verification result if API key is empty
      state = state.copyWith(verificationResult: null);
    }
  }

  Future<void> updateModelOnly(String model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ai_model', model);
    state = state.copyWith(
      settings: state.settings.copyWith(model: model),
    );
    // No API verification needed - just update the model setting
  }

  Future<void> verifyApiKey() async {
    if (state.settings.apiKey.isEmpty) {
      state = state.copyWith(
        verificationResult: ApiVerificationResult(
          isValid: false,
          error: 'API key is required',
        ),
      );
      return;
    }

    state = state.copyWith(isVerifying: true);

    try {
      final verificationService = GeminiApiVerificationService(state.settings.apiKey);
      final result = await verificationService.verifyApiKey();
      
      state = state.copyWith(
        verificationResult: result,
        isVerifying: false,
      );
    } catch (e) {
      state = state.copyWith(
        verificationResult: ApiVerificationResult(
          isValid: false,
          error: 'Verification failed: $e',
        ),
        isVerifying: false,
      );
    }
  }
}
