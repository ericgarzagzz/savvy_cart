import 'package:flutter/material.dart';

class GenericAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final VoidCallback? onConfirm;
  final String? cancelText;

  const GenericAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.onConfirm,
    this.cancelText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        if (confirmText != null && onConfirm != null)
          TextButton(
            onPressed: onConfirm,
            child: Text(confirmText!),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(cancelText ?? 'Cancel'),
        ),
      ],
    );
  }

  static void show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    VoidCallback? onConfirm,
    String? cancelText,
  }) {
    showDialog(
      context: context,
      builder: (context) => GenericAlertDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        onConfirm: onConfirm,
        cancelText: cancelText,
      ),
    );
  }
}