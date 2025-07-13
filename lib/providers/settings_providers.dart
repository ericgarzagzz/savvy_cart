import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/models/settings/ai_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AiSettingsState {
  final AiSettings settings;
  final bool isLoading;
  final String? error;

  AiSettingsState({
    required this.settings,
    this.isLoading = false,
    this.error,
  });

  AiSettingsState copyWith({
    AiSettings? settings,
    bool? isLoading,
    String? error,
  }) {
    return AiSettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final aiSettingsProvider = StateNotifierProvider<AiSettingsNotifier, AiSettingsState>((ref) {
  return AiSettingsNotifier();
});

class AiSettingsNotifier extends StateNotifier<AiSettingsState> {
  AiSettingsNotifier()
      : super(AiSettingsState(
          settings: AiSettings(
            apiKey: '',
          ),
          isLoading: true,
        )) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString('ai_api_key') ?? '';

      state = state.copyWith(
        settings: AiSettings(
          apiKey: apiKey,
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
    state = state.copyWith(settings: settings);
  }
}
