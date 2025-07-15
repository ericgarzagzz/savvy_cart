import 'dart:convert';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/models/models.dart';

class ChatMessageViewModel {
  final ChatMessage chatMessage;
  final GeminiResponse? geminiResponse;
  final bool isError;

  ChatMessageViewModel({
    required this.chatMessage,
    this.geminiResponse,
    this.isError = false,
  });

  factory ChatMessageViewModel.fromChatMessage(ChatMessage chatMessage) {
    GeminiResponse? geminiResponse;
    if (chatMessage.geminiResponseJson != null) {
      try {
        final json = jsonDecode(chatMessage.geminiResponseJson!);
        geminiResponse = GeminiResponse.fromJson(json);
      } catch (e) {
        // Handle parsing error silently
      }
    }

    return ChatMessageViewModel(
      chatMessage: chatMessage,
      geminiResponse: geminiResponse,
      isError: chatMessage.isError,
    );
  }

  factory ChatMessageViewModel.userMessage({
    required int shopListId,
    required String text,
    DateTime? timestamp,
  }) {
    return ChatMessageViewModel(
      chatMessage: ChatMessage(
        shopListId: shopListId,
        text: text,
        isUser: true,
        timestamp: timestamp ?? DateTime.now(),
      ),
    );
  }

  factory ChatMessageViewModel.aiMessage({
    required int shopListId,
    required String text,
    GeminiResponse? geminiResponse,
    bool isError = false,
    DateTime? timestamp,
  }) {
    String? geminiResponseJson;
    if (geminiResponse != null) {
      try {
        geminiResponseJson = jsonEncode({
          'prompt': geminiResponse.prompt,
          'actions': geminiResponse.actions.map((action) => {
            'operation': action.operation.toString().split('.').last,
            'item': action.item,
            'id': action.id,
            'quantity': action.quantity,
            'unit_price': action.unitPrice,
          }).toList(),
        });
      } catch (e) {
        // Handle encoding error silently
      }
    }

    return ChatMessageViewModel(
      chatMessage: ChatMessage(
        shopListId: shopListId,
        text: text,
        isUser: false,
        timestamp: timestamp ?? DateTime.now(),
        geminiResponseJson: geminiResponseJson,
        isError: isError,
      ),
      geminiResponse: geminiResponse,
      isError: isError,
    );
  }

  String get text => chatMessage.text;
  bool get isUser => chatMessage.isUser;
  DateTime get timestamp => chatMessage.timestamp;
  int? get id => chatMessage.id;
  int get shopListId => chatMessage.shopListId;
  bool get actionsExecuted => chatMessage.actionsExecuted;

  bool get hasActions => geminiResponse?.actions.isNotEmpty ?? false;

  List<GeminiAction> get executedActions {
    if (chatMessage.executedActionsJson == null) return [];
    try {
      final json = jsonDecode(chatMessage.executedActionsJson!);
      return (json as List<dynamic>)
          .map((actionJson) => GeminiAction.fromJson(actionJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}