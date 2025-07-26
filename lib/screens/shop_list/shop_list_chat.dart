import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/widgets.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';

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
      final isAtBottom =
          _scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 20;

      final currentState = ref.read(
        chatScrollPositionProvider(widget.shopListId),
      );
      if (currentState != !isAtBottom) {
        ref.read(chatScrollPositionProvider(widget.shopListId).notifier).state =
            !isAtBottom;
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
    final getShopListByIdAsync = ref.watch(
      getShopListByIdProvider(widget.shopListId),
    );
    final isProcessing = ref.watch(chatProcessingProvider(widget.shopListId));
    final scrollPositionExceptBottom = ref.watch(
      chatScrollPositionProvider(widget.shopListId),
    );

    return getShopListByIdAsync.when(
      loading: () => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stackTrace) =>
          GenericErrorScaffold(errorMessage: err.toString()),
      data: (shopList) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).chatWith(shopList.name)),
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
              ChatMessageList(
                shopListId: widget.shopListId,
                scrollController: _scrollController,
                onScrollToBottom: _scrollToBottom,
              ),
              if (isProcessing) const ChatProcessingIndicator(),
              ChatInputBar(
                messageController: _messageController,
                focusNode: _focusNode,
                onSendMessage: _sendMessage,
                isProcessing: isProcessing,
              ),
            ],
          ),
        ),
        floatingActionButton: scrollPositionExceptBottom
            ? ChatScrollToBottomButton(onScrollToBottom: _scrollToBottom)
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
