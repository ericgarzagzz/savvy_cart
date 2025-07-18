class AiSettings {
  final String apiKey;
  final String model;
  final String? themeMode;

  AiSettings({
    required this.apiKey,
    this.model = 'gemini-2.0-flash',
    this.themeMode,
  });

  AiSettings copyWith({String? apiKey, String? model, String? themeMode}) {
    return AiSettings(
      apiKey: apiKey ?? this.apiKey,
      model: model ?? this.model,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  factory AiSettings.fromJson(Map<String, dynamic> json) {
    return AiSettings(
      apiKey: json['apiKey'] as String,
      model: json['model'] as String? ?? 'gemini-2.0-flash',
      themeMode: json['themeMode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final result = {'apiKey': apiKey, 'model': model};
    if (themeMode != null) {
      result['themeMode'] = themeMode!;
    }
    return result;
  }
}
