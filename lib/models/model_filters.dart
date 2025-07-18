class ModelFilters {
  final bool? hasThinking;
  final double? minInputTokens;
  final double? maxInputTokens;
  final double? minOutputTokens;
  final double? maxOutputTokens;
  final double? minTemperature;
  final double? maxTemperature;

  const ModelFilters({
    this.hasThinking,
    this.minInputTokens,
    this.maxInputTokens,
    this.minOutputTokens,
    this.maxOutputTokens,
    this.minTemperature,
    this.maxTemperature,
  });

  ModelFilters copyWith({
    bool? hasThinking,
    double? minInputTokens,
    double? maxInputTokens,
    double? minOutputTokens,
    double? maxOutputTokens,
    double? minTemperature,
    double? maxTemperature,
    bool clearHasThinking = false,
  }) {
    return ModelFilters(
      hasThinking: clearHasThinking ? null : (hasThinking ?? this.hasThinking),
      minInputTokens: minInputTokens ?? this.minInputTokens,
      maxInputTokens: maxInputTokens ?? this.maxInputTokens,
      minOutputTokens: minOutputTokens ?? this.minOutputTokens,
      maxOutputTokens: maxOutputTokens ?? this.maxOutputTokens,
      minTemperature: minTemperature ?? this.minTemperature,
      maxTemperature: maxTemperature ?? this.maxTemperature,
    );
  }

  bool get hasActiveFilters =>
      hasThinking != null ||
      minInputTokens != null ||
      maxInputTokens != null ||
      minOutputTokens != null ||
      maxOutputTokens != null ||
      minTemperature != null ||
      maxTemperature != null;
}
