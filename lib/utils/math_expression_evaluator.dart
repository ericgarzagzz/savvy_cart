class MathExpressionEvaluator {
  static double? evaluate(String expression) {
    try {
      final sanitized = expression.replaceAll(RegExp(r'\s+'), '');

      if (sanitized.isEmpty) return null;

      // Check for invalid characters
      if (!RegExp(r'^[0-9+\-*/().]+$').hasMatch(sanitized)) {
        return null;
      }

      // Basic validation for balanced parentheses
      int openParens = 0;
      for (int i = 0; i < sanitized.length; i++) {
        if (sanitized[i] == '(') openParens++;
        if (sanitized[i] == ')') openParens--;
        if (openParens < 0) return null;
      }
      if (openParens != 0) return null;

      return _evaluateExpression(sanitized);
    } catch (e) {
      return null;
    }
  }

  static double _evaluateExpression(String expr) {
    // Handle parentheses first
    while (expr.contains('(')) {
      int start = -1;
      int end = -1;

      for (int i = 0; i < expr.length; i++) {
        if (expr[i] == '(') {
          start = i;
        } else if (expr[i] == ')') {
          end = i;
          break;
        }
      }

      if (start == -1 || end == -1) break;

      String subExpr = expr.substring(start + 1, end);
      double result = _evaluateSimpleExpression(subExpr);
      expr =
          expr.substring(0, start) +
          result.toString() +
          expr.substring(end + 1);
    }

    return _evaluateSimpleExpression(expr);
  }

  static double _evaluateSimpleExpression(String expr) {
    // Split by + and - (but keep the operators)
    List<String> terms = [];
    String currentTerm = '';

    for (int i = 0; i < expr.length; i++) {
      if ((expr[i] == '+' || expr[i] == '-') && i > 0) {
        terms.add(currentTerm);
        terms.add(expr[i]);
        currentTerm = '';
      } else {
        currentTerm += expr[i];
      }
    }
    if (currentTerm.isNotEmpty) terms.add(currentTerm);

    // Process multiplication and division first
    for (int i = 0; i < terms.length; i++) {
      if (!_isOperator(terms[i])) {
        terms[i] = _evaluateMultiplicationDivision(terms[i]).toString();
      }
    }

    // Now process addition and subtraction
    double result = double.parse(terms[0]);
    for (int i = 1; i < terms.length; i += 2) {
      String operator = terms[i];
      double operand = double.parse(terms[i + 1]);

      if (operator == '+') {
        result += operand;
      } else if (operator == '-') {
        result -= operand;
      }
    }

    return result;
  }

  static double _evaluateMultiplicationDivision(String expr) {
    List<String> factors = [];
    String currentFactor = '';

    for (int i = 0; i < expr.length; i++) {
      if ((expr[i] == '*' || expr[i] == '/') && i > 0) {
        factors.add(currentFactor);
        factors.add(expr[i]);
        currentFactor = '';
      } else {
        currentFactor += expr[i];
      }
    }
    if (currentFactor.isNotEmpty) factors.add(currentFactor);

    if (factors.length == 1) {
      return double.parse(factors[0]);
    }

    double result = double.parse(factors[0]);
    for (int i = 1; i < factors.length; i += 2) {
      String operator = factors[i];
      double operand = double.parse(factors[i + 1]);

      if (operator == '*') {
        result *= operand;
      } else if (operator == '/') {
        if (operand == 0) throw Exception('Division by zero');
        result /= operand;
      }
    }

    return result;
  }

  static bool _isOperator(String s) {
    return s == '+' || s == '-' || s == '*' || s == '/';
  }
}
