import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class ShopListChat extends ConsumerStatefulWidget {
  final int shopListId;

  const ShopListChat({super.key, required this.shopListId});

  @override
  ConsumerState<ShopListChat> createState() => _ShopListChatState();
}

class _ShopListChatState extends ConsumerState<ShopListChat> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final isAtBottom = _scrollController.position.pixels >= 
          _scrollController.position.maxScrollExtent - 20;
      
      final currentState = ref.read(chatScrollPositionProvider(widget.shopListId));
      if (currentState != !isAtBottom) {
        ref.read(chatScrollPositionProvider(widget.shopListId).notifier).state = !isAtBottom;
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    final isProcessing = ref.read(chatProcessingProvider(widget.shopListId));
    if (message.isEmpty || isProcessing) return;

    _messageController.clear();
    
    try {
      final sendMessage = ref.read(sendMessageProvider(widget.shopListId));
      await sendMessage(message);
      
      _scrollToBottom();
    } catch (e) {
      // Error handling is done in the provider (shows error chat bubble)
      // No need for additional AlertDialog
    }
    
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final getShopListByIdAsync = ref.watch(getShopListByIdProvider(widget.shopListId));
    final messages = ref.watch(chatMessagesProvider(widget.shopListId));
    final isProcessing = ref.watch(chatProcessingProvider(widget.shopListId));
    final scrollPositionExceptBottom = ref.watch(chatScrollPositionProvider(widget.shopListId));

    return getShopListByIdAsync.when(
      loading: () => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stackTrace) =>
          GenericErrorScaffold(errorMessage: err.toString()),
      data: (shopList) => Scaffold(
        appBar: AppBar(
          title: Text("Chat with ${shopList.name}"),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        body: GestureDetector(
          onTap: () {
            if (_focusNode.hasFocus) {
              FocusScope.of(context).unfocus();
            }
          },
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isLastMessage = index == messages.length - 1;

                    // Find the latest AI message (regardless of actions)
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
                                final retryMessage = ref.read(retryLastMessageProvider(widget.shopListId));
                                await retryMessage();
                                _scrollToBottom();
                              } catch (e) {
                                // Error handling is already done in the provider
                              }
                            }
                          : null,
                      onViewActions: !message.isError && !message.isUser && message.hasActions
                          ? () async {
                              final selectedActions = await showModalBottomSheet<List<GeminiAction>>(
                                isScrollControlled: true,
                                context: context,
                                builder: (ctx) => AiActionSelectionSheet(
                                  geminiResponse: message.geminiResponse!,
                                  shopListId: widget.shopListId,
                                ),
                              );

                              if (selectedActions != null && message.id != null) {
                                final responseToExecute = GeminiResponse(
                                  prompt: message.geminiResponse!.prompt,
                                  actions: selectedActions,
                                );

                                final executeActions = ref.read(executeActionsProvider(widget.shopListId));
                                await executeActions(responseToExecute, message.id!);
                              }
                            }
                          : null,
                      onViewExecutedActions: !message.isError && !message.isUser && message.actionsExecuted
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
              ),
              if (isProcessing)
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.surface,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Processing...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.surface,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Theme.of(context).colorScheme.background,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                        enabled: !isProcessing,
                      ),
                    ),
                    const SizedBox(width: 12),
                    FloatingActionButton(
                      onPressed: isProcessing ? null : _sendMessage,
                      mini: true,
                      backgroundColor: isProcessing
                          ? Theme.of(context).colorScheme.outline
                          : Theme.of(context).colorScheme.primary,
                      child: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: scrollPositionExceptBottom ? Padding(
          padding: const EdgeInsets.only(bottom: 64),
          child: FloatingActionButton(
            mini: true,
            onPressed: _scrollToBottom,
            child: Icon(Icons.keyboard_double_arrow_down),
          ),
        ) : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}