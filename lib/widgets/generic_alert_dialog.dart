import 'package:flutter/material.dart';

class GenericAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;

  const GenericAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        if (actionText != null && onAction != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionText!),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }

  static void show(
      BuildContext context, {
        required String title,
        required String message,
        String? actionText,
        VoidCallback? onAction,
      }) {
    showDialog(
      context: context,
      builder: (context) => GenericAlertDialog(
        title: title,
        message: message,
        actionText: actionText,
        onAction: onAction,
      ),
    );
  }
}