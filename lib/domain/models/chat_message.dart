class ChatMessage {
  final int? id;
  final int shopListId;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? geminiResponseJson;
  final bool actionsExecuted;
  final String? executedActionsJson;
  final bool isError;

  ChatMessage({
    this.id,
    required this.shopListId,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.geminiResponseJson,
    this.actionsExecuted = false,
    this.executedActionsJson,
    this.isError = false,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      shopListId: map['shop_list_id'],
      text: map['text'],
      isUser: map['is_user'] == 1,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      geminiResponseJson: map['gemini_response_json'],
      actionsExecuted: map['actions_executed'] == 1,
      executedActionsJson: map['executed_actions_json'],
      isError: map['is_error'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shop_list_id': shopListId,
      'text': text,
      'is_user': isUser ? 1 : 0,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'gemini_response_json': geminiResponseJson,
      'actions_executed': actionsExecuted ? 1 : 0,
      'executed_actions_json': executedActionsJson,
      'is_error': isError ? 1 : 0,
    };
  }

  ChatMessage copyWith({
    int? id,
    int? shopListId,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    String? geminiResponseJson,
    bool? actionsExecuted,
    String? executedActionsJson,
    bool? isError,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      shopListId: shopListId ?? this.shopListId,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      geminiResponseJson: geminiResponseJson ?? this.geminiResponseJson,
      actionsExecuted: actionsExecuted ?? this.actionsExecuted,
      executedActionsJson: executedActionsJson ?? this.executedActionsJson,
      isError: isError ?? this.isError,
    );
  }
}
