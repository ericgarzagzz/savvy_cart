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
}