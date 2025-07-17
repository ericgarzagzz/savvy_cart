/// Utility functions for safe parsing operations
class ParsingUtils {
  /// Safely parses a string to an integer, returning null if parsing fails
  static int? parseIntSafely(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return int.parse(value);
    } on FormatException {
      return null;
    }
  }

  /// Safely parses a string to a double, returning null if parsing fails
  static double? parseDoubleSafely(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return double.parse(value);
    } on FormatException {
      return null;
    }
  }

  /// Safely parses a string to a boolean, returning null if parsing fails
  /// Accepts: 'true', 'false', '1', '0' (case insensitive)
  static bool? parseBoolSafely(String? value) {
    if (value == null || value.isEmpty) return null;
    final normalized = value.toLowerCase().trim();
    switch (normalized) {
      case 'true':
      case '1':
        return true;
      case 'false':
      case '0':
        return false;
      default:
        return null;
    }
  }
}