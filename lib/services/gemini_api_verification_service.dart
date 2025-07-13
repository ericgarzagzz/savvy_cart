import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GeminiApiVerificationService {
  final String _apiKey;
  static const String _listModelsUrl = 'https://generativelanguage.googleapis.com/v1beta/models';

  GeminiApiVerificationService(this._apiKey);

  /// Verify the API key by attempting to list available models
  Future<ApiVerificationResult> verifyApiKey() async {
    try {
      if (_apiKey.isEmpty) {
        return ApiVerificationResult(
          isValid: false,
          error: 'API key is empty',
        );
      }

      if (kDebugMode) {
        print('Verifying Gemini API key...');
      }

      final response = await http.get(
        Uri.parse('$_listModelsUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (kDebugMode) {
        print('API verification response status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final models = data['models'] as List<dynamic>?;
        
        if (models != null && models.isNotEmpty) {
          final availableModels = models
              .map((model) => model['name'] as String?)
              .where((name) => name != null)
              .cast<String>()
              .toList();

          if (kDebugMode) {
            print('API verification successful. Found ${availableModels.length} models.');
          }

          return ApiVerificationResult(
            isValid: true,
            availableModels: availableModels,
          );
        } else {
          return ApiVerificationResult(
            isValid: false,
            error: 'No models found in API response',
          );
        }
      } else if (response.statusCode == 401) {
        return ApiVerificationResult(
          isValid: false,
          error: 'Invalid API key',
        );
      } else if (response.statusCode == 403) {
        return ApiVerificationResult(
          isValid: false,
          error: 'API access forbidden - check your API key permissions',
        );
      } else {
        return ApiVerificationResult(
          isValid: false,
          error: 'API error: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('API verification failed: $e');
      }
      
      String errorMessage = 'Connection failed';
      if (e.toString().contains('timeout')) {
        errorMessage = 'Connection timeout - check your internet connection';
      } else if (e.toString().contains('resolve')) {
        errorMessage = 'Network error - check your internet connection';
      }
      
      return ApiVerificationResult(
        isValid: false,
        error: errorMessage,
      );
    }
  }
}

class ApiVerificationResult {
  final bool isValid;
  final String? error;
  final List<String>? availableModels;
  final DateTime verifiedAt;

  ApiVerificationResult({
    required this.isValid,
    this.error,
    this.availableModels,
  }) : verifiedAt = DateTime.now();

  bool get hasError => error != null;

  String get statusMessage {
    if (isValid) {
      final modelCount = availableModels?.length ?? 0;
      return 'Connected ($modelCount models available)';
    } else {
      return error ?? 'Verification failed';
    }
  }

  ApiConnectionStatus get status {
    if (isValid) return ApiConnectionStatus.connected;
    if (error?.contains('Invalid API key') == true) return ApiConnectionStatus.invalidKey;
    if (error?.contains('timeout') == true || error?.contains('Network') == true) {
      return ApiConnectionStatus.networkError;
    }
    return ApiConnectionStatus.error;
  }
}

enum ApiConnectionStatus {
  connected,
  invalidKey,
  networkError,
  error,
  notVerified,
}

extension ApiConnectionStatusExtension on ApiConnectionStatus {
  String get displayName {
    switch (this) {
      case ApiConnectionStatus.connected:
        return 'Connected';
      case ApiConnectionStatus.invalidKey:
        return 'Invalid API Key';
      case ApiConnectionStatus.networkError:
        return 'Network Error';
      case ApiConnectionStatus.error:
        return 'Connection Error';
      case ApiConnectionStatus.notVerified:
        return 'Not Verified';
    }
  }

  bool get isSuccess => this == ApiConnectionStatus.connected;
}