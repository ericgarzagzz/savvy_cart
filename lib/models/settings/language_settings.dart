import 'package:flutter/material.dart';

enum AppLanguage {
  system('system'),
  english('en'),
  spanish('es'),
  portuguese('pt'),
  russian('ru');

  const AppLanguage(this.code);
  final String code;

  String get displayName {
    switch (this) {
      case AppLanguage.system:
        return 'System Language'; // Fallback for non-UI contexts
      case AppLanguage.english:
        return 'English';
      case AppLanguage.spanish:
        return 'Español';
      case AppLanguage.portuguese:
        return 'Português';
      case AppLanguage.russian:
        return 'Русский';
    }
  }

  static String getLocalizedDisplayName(
    dynamic localizations,
    AppLanguage language,
  ) {
    switch (language) {
      case AppLanguage.system:
        return localizations.systemLanguage;
      case AppLanguage.english:
        return 'English';
      case AppLanguage.spanish:
        return 'Español';
      case AppLanguage.portuguese:
        return 'Português';
      case AppLanguage.russian:
        return 'Русский';
    }
  }

  String get countryCode {
    switch (this) {
      case AppLanguage.system:
        return 'auto';
      case AppLanguage.english:
        return 'us';
      case AppLanguage.spanish:
        return 'es';
      case AppLanguage.portuguese:
        return 'br';
      case AppLanguage.russian:
        return 'ru';
    }
  }

  Locale? get locale {
    if (this == AppLanguage.system) return null;
    return Locale(code);
  }

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.system,
    );
  }
}

class LanguageSettings {
  final AppLanguage selectedLanguage;

  const LanguageSettings({this.selectedLanguage = AppLanguage.system});

  LanguageSettings copyWith({AppLanguage? selectedLanguage}) {
    return LanguageSettings(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }

  factory LanguageSettings.fromJson(Map<String, dynamic> json) {
    return LanguageSettings(
      selectedLanguage: AppLanguage.fromCode(
        json['selectedLanguage'] as String? ?? 'system',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'selectedLanguage': selectedLanguage.code};
  }
}
