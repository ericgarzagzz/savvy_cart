import 'package:flutter/material.dart';

class ChatScrollToBottomButton extends StatelessWidget {
  final VoidCallback onScrollToBottom;

  const ChatScrollToBottomButton({super.key, required this.onScrollToBottom});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 64),
      child: FloatingActionButton(
        mini: true,
        onPressed: onScrollToBottom,
        child: const Icon(Icons.keyboard_double_arrow_down),
      ),
    );
  }
}
