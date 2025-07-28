import 'package:flutter/services.dart';

class MathExpressionTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text == '') return newValue;

    // Allow numbers, decimal points, operators, and parentheses
    if (!RegExp(r'^[0-9+\-*/().]*$').hasMatch(text)) {
      return oldValue;
    }

    return newValue;
  }
}
