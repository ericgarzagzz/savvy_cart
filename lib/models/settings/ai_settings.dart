class AiSettings {
  final String apiKey;

  AiSettings({
    required this.apiKey,
  });

  AiSettings copyWith({
    String? apiKey,
  }) {
    return AiSettings(
      apiKey: apiKey ?? this.apiKey,
    );
  }

  factory AiSettings.fromJson(Map<String, dynamic> json) {
    return AiSettings(
      apiKey: json['apiKey'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'apiKey': apiKey,
    };
  }
}