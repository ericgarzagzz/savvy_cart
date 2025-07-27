import 'package:flutter/material.dart';

import 'package:savvy_cart/l10n/app_localizations.dart';

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: TextField(
                  controller: messageController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).typeYourMessage,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 8,
                    ),
                  ),
                  onSubmitted: (_) => onSendMessage(),
                  enabled: !isProcessing,
                ),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: isProcessing ? null : onSendMessage,
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
