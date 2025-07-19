import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController messageController;
  final FocusNode focusNode;
  final VoidCallback onSendMessage;
  final bool isProcessing;

  const ChatInputBar({
    super.key,
    required this.messageController,
    required this.focusNode,
    required this.onSendMessage,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                fillColor: Theme.of(context).colorScheme.surface,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => onSendMessage(),
              enabled: !isProcessing,
            ),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            onPressed: isProcessing ? null : onSendMessage,
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
    );
  }
}
