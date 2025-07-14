import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GeminiModel {
  final String name;
  final String? baseModelId;
  final String? version;
  final String? displayName;
  final String? description;
  final int? inputTokenLimit;
  final int? outputTokenLimit;
  final List<String>? supportedGenerationMethods;
  final bool? thinking;
  final double? temperature;
  final double? maxTemperature;
  final double? topP;
  final int? topK;
  
  GeminiModel({
    required this.name,
    this.baseModelId,
    this.version,
    this.displayName,
    this.description,
    this.inputTokenLimit,
    this.outputTokenLimit,
    this.supportedGenerationMethods,
    this.thinking,
    this.temperature,
    this.maxTemperature,
    this.topP,
    this.topK,
  });
  
  factory GeminiModel.fromJson(Map<String, dynamic> json) {
    return GeminiModel(
      name: json['name'] as String,
      baseModelId: json['baseModelId'] as String?,
      version: json['version'] as String?,
      displayName: json['displayName'] as String?,
      description: json['description'] as String?,
      inputTokenLimit: json['inputTokenLimit'] as int?,
      outputTokenLimit: json['outputTokenLimit'] as int?,
      supportedGenerationMethods: (json['supportedGenerationMethods'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      thinking: json['thinking'] as bool?,
      temperature: (json['temperature'] as num?)?.toDouble(),
      maxTemperature: (json['maxTemperature'] as num?)?.toDouble(),
      topP: (json['topP'] as num?)?.toDouble(),
      topK: json['topK'] as int?,
    );
  }
  
  String get cleanName => name.replaceAll('models/', '');
  
  String get userFriendlyName {
    if (displayName != null && displayName!.isNotEmpty) {
      return displayName!;
    }
    // Fallback to cleaning up the name
    return cleanName
        .replaceAll('gemini-', 'Gemini ')
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
  
  double get versionNumber {
    if (version != null) {
      return double.tryParse(version!) ?? 0;
    }
    // Fallback to parsing from name
    final versionMatch = RegExp(r'gemini-(\d+\.?\d*)-').firstMatch(cleanName);
    if (versionMatch != null) {
      return double.tryParse(versionMatch.group(1) ?? '0') ?? 0;
    }
    if (cleanName.contains('gemini-pro') && !cleanName.contains('-')) {
      return 1.0;
    }
    return 0;
  }
}

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
              .map((modelData) {
                try {
                  return GeminiModel.fromJson(modelData as Map<String, dynamic>);
                } catch (e) {
                  if (kDebugMode) {
                    print('Failed to parse model: $e');
                  }
                  return null;
                }
              })
              .where((model) => model != null && model.name.contains('gemini'))
              .cast<GeminiModel>()
              .toList();

          if (kDebugMode) {
            print('API verification successful. Found ${availableModels.length} models.');
          }

          return ApiVerificationResult(
            isValid: true,
            availableModels: availableModels.map((model) => model.name).toList(),
            geminiModels: availableModels,
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
  final List<GeminiModel>? geminiModels;
  final DateTime verifiedAt;

  ApiVerificationResult({
    required this.isValid,
    this.error,
    this.availableModels,
    this.geminiModels,
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