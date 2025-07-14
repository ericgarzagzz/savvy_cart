class AiSettings {
  final String apiKey;
  final String model;

  AiSettings({
    required this.apiKey,
    this.model = 'gemini-2.0-flash',
  });

  AiSettings copyWith({
    String? apiKey,
    String? model,
  }) {
    return AiSettings(
      apiKey: apiKey ?? this.apiKey,
      model: model ?? this.model,
    );
  }

  factory AiSettings.fromJson(Map<String, dynamic> json) {
    return AiSettings(
      apiKey: json['apiKey'] as String,
      model: json['model'] as String? ?? 'gemini-2.0-flash',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'apiKey': apiKey,
      'model': model,
    };
  }
}