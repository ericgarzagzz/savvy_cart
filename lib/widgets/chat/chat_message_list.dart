import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class ChatMessageList extends ConsumerWidget {
  final int shopListId;
  final ScrollController scrollController;
  final VoidCallback onScrollToBottom;

  const ChatMessageList({
    super.key,
    required this.shopListId,
    required this.scrollController,
    required this.onScrollToBottom,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatMessagesProvider(shopListId));

    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          final isLastMessage = index == messages.length - 1;

          int? latestAiMessageIndex;
          for (int i = messages.length - 1; i >= 0; i--) {
            final msg = messages[i];
            if (!msg.isUser && !msg.isError) {
              latestAiMessageIndex = i;
              break;
            }
          }
          final isLatestAiMessage = latestAiMessageIndex == index;

          return ChatBubble(
            messageViewModel: message,
            isLastMessage: isLastMessage,
            onRetry: message.isError && !message.isUser && isLastMessage
                ? () async {
                    try {
                      final retryMessage = ref.read(
                        retryLastMessageProvider(shopListId),
                      );
                      await retryMessage();
                      onScrollToBottom();
                    } catch (e) {
                      // Error handling is already done in the provider
                    }
                  }
                : null,
            onViewActions:
                !message.isError && !message.isUser && message.hasActions
                ? () async {
                    final selectedActions =
                        await showModalBottomSheet<List<GeminiAction>>(
                          isScrollControlled: true,
                          context: context,
                          builder: (ctx) => AiActionSelectionSheet(
                            geminiResponse: message.geminiResponse!,
                            shopListId: shopListId,
                          ),
                        );

                    if (selectedActions != null && message.id != null) {
                      final responseToExecute = GeminiResponse(
                        prompt: message.geminiResponse!.prompt,
                        actions: selectedActions,
                      );

                      final executeActions = ref.read(
                        executeActionsProvider(shopListId),
                      );
                      await executeActions(responseToExecute, message.id!);
                    }
                  }
                : null,
            onViewExecutedActions:
                !message.isError && !message.isUser && message.actionsExecuted
                ? () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (ctx) => ExecutedActionsReviewSheet(
                        executedActions: message.executedActions,
                      ),
                    );
                  }
                : null,
            isLatestAiMessage: isLatestAiMessage,
          );
        },
      ),
    );
  }
}
