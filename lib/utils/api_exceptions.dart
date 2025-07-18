import 'dart:io';

/// Custom exceptions for API operations
abstract class ApiException implements Exception {
  final String message;
  final dynamic originalError;

  const ApiException(this.message, [this.originalError]);

  @override
  String toString() => 'ApiException: $message';
}

class NetworkException extends ApiException {
  const NetworkException(String message, [dynamic originalError])
    : super(message, originalError);

  @override
  String toString() => 'NetworkException: $message';
}

class ApiTimeoutException extends ApiException {
  const ApiTimeoutException(String message, [dynamic originalError])
    : super(message, originalError);

  @override
  String toString() => 'ApiTimeoutException: $message';
}

class ApiRateLimitException extends ApiException {
  const ApiRateLimitException(String message, [dynamic originalError])
    : super(message, originalError);

  @override
  String toString() => 'ApiRateLimitException: $message';
}

class ApiAuthenticationException extends ApiException {
  const ApiAuthenticationException(String message, [dynamic originalError])
    : super(message, originalError);

  @override
  String toString() => 'ApiAuthenticationException: $message';
}

class ApiQuotaExceededException extends ApiException {
  const ApiQuotaExceededException(String message, [dynamic originalError])
    : super(message, originalError);

  @override
  String toString() => 'ApiQuotaExceededException: $message';
}

class ApiResponseFormatException extends ApiException {
  const ApiResponseFormatException(String message, [dynamic originalError])
    : super(message, originalError);

  @override
  String toString() => 'ApiResponseFormatException: $message';
}

class ApiServerException extends ApiException {
  final int statusCode;

  const ApiServerException(
    this.statusCode,
    String message, [
    dynamic originalError,
  ]) : super(message, originalError);

  @override
  String toString() => 'ApiServerException ($statusCode): $message';
}

/// Helper class to analyze HTTP responses and throw appropriate exceptions
class ApiErrorHandler {
  static void handleHttpError(
    int statusCode,
    String responseBody, [
    dynamic originalError,
  ]) {
    switch (statusCode) {
      case 400:
        throw ApiServerException(
          statusCode,
          'Bad request: $responseBody',
          originalError,
        );
      case 401:
        throw ApiAuthenticationException(
          'Invalid API key or authentication failed',
          originalError,
        );
      case 403:
        throw ApiAuthenticationException(
          'Access forbidden - check API permissions',
          originalError,
        );
      case 429:
        throw ApiRateLimitException(
          'API rate limit exceeded. Please try again later.',
          originalError,
        );
      case 500:
        throw ApiServerException(
          statusCode,
          'Internal server error',
          originalError,
        );
      case 502:
        throw ApiServerException(
          statusCode,
          'Bad gateway - service temporarily unavailable',
          originalError,
        );
      case 503:
        throw ApiServerException(
          statusCode,
          'Service unavailable',
          originalError,
        );
      case 504:
        throw ApiTimeoutException('Gateway timeout', originalError);
      default:
        throw ApiServerException(
          statusCode,
          'HTTP error $statusCode: $responseBody',
          originalError,
        );
    }
  }

  static void handleSocketException(SocketException e) {
    throw NetworkException('No internet connection available', e);
  }

  static void handleTimeoutException(dynamic e) {
    throw ApiTimeoutException('Request timed out', e);
  }

  static void handleFormatException(FormatException e) {
    throw ApiResponseFormatException('Invalid response format from API', e);
  }
}
