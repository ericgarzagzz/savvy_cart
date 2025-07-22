import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/models/chat/chat_message_view_model.dart';
import 'package:savvy_cart/models/gemini_response.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/services/gemini_shop_list_service.dart';

// Chat messages state for a specific shop list
final chatMessagesProvider =
    StateNotifierProvider.family<
      ChatMessagesNotifier,
      List<ChatMessageViewModel>,
      int
    >((ref, shopListId) => ChatMessagesNotifier(shopListId));

// Processing state for chat
final chatProcessingProvider = StateProvider.family<bool, int>(
  (ref, shopListId) => false,
);

// Scroll position state for chat (tracks if user has scrolled up from bottom)
final chatScrollPositionProvider = StateProvider.family<bool, int>(
  (ref, shopListId) => false,
);

class ChatMessagesNotifier extends StateNotifier<List<ChatMessageViewModel>> {
  final int shopListId;

  ChatMessagesNotifier(this.shopListId) : super([]) {
    _loadExistingMessages();
  }

  Future<void> _loadExistingMessages() async {
    try {
      final chatMessages = await DatabaseHelper.instance
          .getChatMessagesByShopList(shopListId);
      final messageViewModels = chatMessages
          .map((msg) => ChatMessageViewModel.fromChatMessage(msg))
          .toList();
      state = messageViewModels;
    } catch (e) {
      // Handle error silently or log
    }
  }

  void addMessage(ChatMessageViewModel message) {
    state = [...state, message];
  }

  void addUserMessage(String text) {
    final message = ChatMessageViewModel.userMessage(
      shopListId: shopListId,
      text: text,
    );
    addMessage(message);
  }

  void addAiMessage({
    required String text,
    GeminiResponse? geminiResponse,
    bool isError = false,
  }) {
    final message = ChatMessageViewModel.aiMessage(
      shopListId: shopListId,
      text: text,
      geminiResponse: geminiResponse,
      isError: isError,
    );
    addMessage(message);
  }

  void removeLastErrorMessage() {
    if (state.isNotEmpty && state.last.isError && !state.last.isUser) {
      state = state.sublist(0, state.length - 1);
    }
  }

  String? getLastUserMessage() {
    for (int i = state.length - 1; i >= 0; i--) {
      if (state[i].isUser) {
        return state[i].text;
      }
    }
    return null;
  }

  void clearMessages() {
    state = [];
  }

  void markMessageActionsExecuted(int messageId, String executedActionsJson) {
    state = state.map((message) {
      if (message.id == messageId) {
        return ChatMessageViewModel(
          chatMessage: message.chatMessage.copyWith(
            actionsExecuted: true,
            executedActionsJson: executedActionsJson,
          ),
          geminiResponse: message.geminiResponse,
          isError: message.isError,
        );
      }
      return message;
    }).toList();
  }
}

// Internal helper for processing messages (used by both send and retry)
Future<void> _processMessage(
  Ref ref,
  int shopListId,
  String message, {
  bool addUserMessage = true,
}) async {
  final chatNotifier = ref.read(chatMessagesProvider(shopListId).notifier);
  final processingNotifier = ref.read(
    chatProcessingProvider(shopListId).notifier,
  );

  // Add user message only if specified (not for retry)
  if (addUserMessage) {
    final userMessage = ChatMessageViewModel.userMessage(
      shopListId: shopListId,
      text: message,
    );

    // Persist to database
    final messageId = await DatabaseHelper.instance.addChatMessage(
      userMessage.chatMessage,
    );

    // Update with ID and add to state
    final userMessageWithId = ChatMessageViewModel(
      chatMessage: userMessage.chatMessage.copyWith(id: messageId),
      geminiResponse: userMessage.geminiResponse,
      isError: userMessage.isError,
    );
    chatNotifier.addMessage(userMessageWithId);
  }

  // Set processing state
  processingNotifier.state = true;

  try {
    // Wait for settings to load with retry mechanism
    AiSettingsState aiSettingsState;
    int retryCount = 0;
    const maxRetries = 10; // Wait up to 1 second (10 * 100ms)

    do {
      aiSettingsState = ref.read(aiSettingsProvider);

      if (!aiSettingsState.isLoading) {
        break; // Settings loaded
      }

      if (retryCount >= maxRetries) {
        throw Exception(
          'AI settings took too long to load. Please check your connection and try again.',
        );
      }

      // Wait 100ms before retrying
      await Future.delayed(const Duration(milliseconds: 100));
      retryCount++;
    } while (aiSettingsState.isLoading);

    if (aiSettingsState.error != null) {
      throw Exception('Failed to load AI settings: ${aiSettingsState.error}');
    }

    final apiKey = aiSettingsState.settings.apiKey;
    if (apiKey.isEmpty) {
      throw Exception(
        'API key not configured. Please set your Gemini API key in settings.',
      );
    }

    final service = GeminiShopListService(
      apiKey,
      model: aiSettingsState.settings.model,
    );
    final currentShopListItems = await ref.read(
      getShopListItemsProvider(shopListId).future,
    );

    final geminiResponse = await service.processTextInstructions(
      message,
      currentShopListItems,
    );

    // Add AI response
    final aiMessage = ChatMessageViewModel.aiMessage(
      shopListId: shopListId,
      text: geminiResponse.prompt ?? "I've analyzed your request.",
      geminiResponse: geminiResponse,
    );

    // Persist to database
    final aiMessageId = await DatabaseHelper.instance.addChatMessage(
      aiMessage.chatMessage,
    );

    // Update with ID and add to state
    final aiMessageWithId = ChatMessageViewModel(
      chatMessage: aiMessage.chatMessage.copyWith(id: aiMessageId),
      geminiResponse: aiMessage.geminiResponse,
      isError: aiMessage.isError,
    );
    chatNotifier.addMessage(aiMessageWithId);
  } catch (e) {
    // Add error message
    final errorMessage = ChatMessageViewModel.aiMessage(
      shopListId: shopListId,
      text: "Sorry, I couldn't process your request: ${e.toString()}",
      isError: true,
    );

    // Persist to database
    final errorMessageId = await DatabaseHelper.instance.addChatMessage(
      errorMessage.chatMessage,
    );

    // Update with ID and add to state
    final errorMessageWithId = ChatMessageViewModel(
      chatMessage: errorMessage.chatMessage.copyWith(id: errorMessageId),
      geminiResponse: errorMessage.geminiResponse,
      isError: errorMessage.isError,
    );
    chatNotifier.addMessage(errorMessageWithId);
    rethrow; // Re-throw for UI error handling
  } finally {
    processingNotifier.state = false;
  }
}

// Provider for sending messages
final sendMessageProvider = Provider.family<Future<void> Function(String), int>(
  (ref, shopListId) {
    return (String message) async {
      if (message.trim().isEmpty) return;
      await _processMessage(ref, shopListId, message, addUserMessage: true);
    };
  },
);

// Provider for retrying the last failed message
final retryLastMessageProvider = Provider.family<Future<void> Function(), int>((
  ref,
  shopListId,
) {
  return () async {
    final chatNotifier = ref.read(chatMessagesProvider(shopListId).notifier);
    final lastUserMessage = chatNotifier.getLastUserMessage();

    if (lastUserMessage != null) {
      // Remove the error message
      chatNotifier.removeLastErrorMessage();

      // Retry processing without adding a new user message
      await _processMessage(
        ref,
        shopListId,
        lastUserMessage,
        addUserMessage: false,
      );
    }
  };
});

// Provider for executing selected actions
final executeActionsProvider =
    Provider.family<Future<void> Function(GeminiResponse, int), int>((
      ref,
      shopListId,
    ) {
      return (GeminiResponse geminiResponse, int messageId) async {
        final aiSettingsState = ref.read(aiSettingsProvider);

        if (aiSettingsState.isLoading) {
          throw Exception(
            'AI settings are still loading. Please wait a moment and try again.',
          );
        }

        if (aiSettingsState.error != null) {
          throw Exception(
            'Failed to load AI settings: ${aiSettingsState.error}',
          );
        }

        final apiKey = aiSettingsState.settings.apiKey;
        if (apiKey.isEmpty) {
          throw Exception(
            'API key not configured. Please set your Gemini API key in settings.',
          );
        }
        final service = GeminiShopListService(
          apiKey,
          model: aiSettingsState.settings.model,
        );

        await service.executeGeminiActions(geminiResponse, shopListId);

        // Serialize executed actions for storage
        final executedActionsJson = jsonEncode(
          geminiResponse.actions
              .map(
                (action) => {
                  'operation': action.operation.toString().split('.').last,
                  'item': action.item,
                  'id': action.id,
                  'quantity': action.quantity,
                  'unit_price': action.unitPrice,
                },
              )
              .toList(),
        );

        // Mark the message as executed in the database
        await DatabaseHelper.instance.markChatMessageActionsExecuted(
          messageId,
          executedActionsJson,
        );

        // Update the state to reflect that actions were executed
        final chatNotifier = ref.read(
          chatMessagesProvider(shopListId).notifier,
        );
        chatNotifier.markMessageActionsExecuted(messageId, executedActionsJson);

        // Invalidate shop list providers to refresh the UI
        ref.invalidate(shopListItemsProvider((shopListId, false)));
        ref.invalidate(shopListItemsProvider((shopListId, true)));
        ShopListInvalidationHelper.invalidateShopListItemRelated(ref);
      };
    });
