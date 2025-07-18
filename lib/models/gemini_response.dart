import 'package:savvy_cart/models/models.dart';

class GeminiResponse {
  final String? prompt;
  final List<GeminiAction> actions;

  GeminiResponse({this.prompt, required this.actions});

  factory GeminiResponse.fromJson(Map<String, dynamic> json) {
    return GeminiResponse(
      prompt: json['prompt'],
      actions:
          (json['actions'] as List<dynamic>?)
              ?.map((e) => GeminiAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
