import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:savvy_cart/providers/settings_providers.dart';
import 'package:savvy_cart/services/gemini_api_verification_service.dart';
import 'package:savvy_cart/widgets/settings/ai_settings_form.dart';

class AiSettingsScreen extends ConsumerWidget {
  const AiSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiSettingsState = ref.watch(aiSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Settings'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI Assistant Configuration',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Configure your AI assistant to help manage shopping lists and provide suggestions.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // API Configuration section
            Text(
              'API Configuration',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Set up your Google Gemini API key to enable AI features',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),

            // AI Settings Form
            const AiSettingsForm(),

            const SizedBox(height: 24),

            // Status section
            Text(
              'Connection Status',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getStatusColor(aiSettingsState).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: aiSettingsState.isVerifying
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: _getStatusColor(aiSettingsState),
                                  ),
                                )
                              : Icon(
                                  _getStatusIcon(aiSettingsState),
                                  color: _getStatusColor(aiSettingsState),
                                  size: 20,
                                ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getStatusTitle(aiSettingsState),
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: _getStatusColor(aiSettingsState),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _getStatusSubtitle(aiSettingsState),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (aiSettingsState.settings.apiKey.isNotEmpty && !aiSettingsState.isVerifying)
                          IconButton(
                            onPressed: () => ref.read(aiSettingsProvider.notifier).verifyApiKey(),
                            icon: const Icon(Icons.refresh),
                            tooltip: 'Verify API key',
                          ),
                      ],
                    ),
                    if (aiSettingsState.verificationResult?.availableModels?.isNotEmpty == true) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Available Models (${aiSettingsState.verificationResult!.availableModels!.length})',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade700,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              aiSettingsState.verificationResult!.availableModels!
                                  .take(3)
                                  .map((model) => model.split('/').last)
                                  .join(', ') +
                                  (aiSettingsState.verificationResult!.availableModels!.length > 3 
                                      ? '...' : ''),
                              style: TextStyle(
                                color: Colors.blue.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Information section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'About Google Gemini',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoPoint(context, 'Get your free API key from Google AI Studio'),
                  _buildInfoPoint(context, 'AI features include chat assistance and smart suggestions'),
                  _buildInfoPoint(context, 'Your API key is stored securely on your device'),
                  _buildInfoPoint(context, 'API usage may be subject to Google\'s rate limits'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(AiSettingsState state) {
    if (state.isVerifying) return Colors.blue.shade600;
    
    switch (state.connectionStatus) {
      case ApiConnectionStatus.connected:
        return Colors.green.shade600;
      case ApiConnectionStatus.invalidKey:
        return Colors.red.shade600;
      case ApiConnectionStatus.networkError:
        return Colors.orange.shade600;
      case ApiConnectionStatus.error:
        return Colors.red.shade600;
      case ApiConnectionStatus.notVerified:
        return state.settings.apiKey.isEmpty 
            ? Colors.orange.shade600 
            : Colors.grey.shade600;
    }
  }

  IconData _getStatusIcon(AiSettingsState state) {
    switch (state.connectionStatus) {
      case ApiConnectionStatus.connected:
        return Icons.check_circle;
      case ApiConnectionStatus.invalidKey:
        return Icons.error;
      case ApiConnectionStatus.networkError:
        return Icons.wifi_off;
      case ApiConnectionStatus.error:
        return Icons.error;
      case ApiConnectionStatus.notVerified:
        return state.settings.apiKey.isEmpty ? Icons.warning : Icons.help_outline;
    }
  }

  String _getStatusTitle(AiSettingsState state) {
    if (state.isVerifying) return 'Verifying API Key...';
    
    switch (state.connectionStatus) {
      case ApiConnectionStatus.connected:
        return 'API Connected';
      case ApiConnectionStatus.invalidKey:
        return 'Invalid API Key';
      case ApiConnectionStatus.networkError:
        return 'Network Error';
      case ApiConnectionStatus.error:
        return 'Connection Error';
      case ApiConnectionStatus.notVerified:
        return state.settings.apiKey.isEmpty ? 'API Key Required' : 'Not Verified';
    }
  }

  String _getStatusSubtitle(AiSettingsState state) {
    if (state.isVerifying) return 'Checking connection to Gemini API...';
    
    if (state.verificationResult != null) {
      return state.verificationResult!.statusMessage;
    }
    
    switch (state.connectionStatus) {
      case ApiConnectionStatus.connected:
        return 'AI features are ready to use';
      case ApiConnectionStatus.invalidKey:
        return 'Please check your API key';
      case ApiConnectionStatus.networkError:
        return 'Check your internet connection';
      case ApiConnectionStatus.error:
        return 'Unable to connect to Gemini API';
      case ApiConnectionStatus.notVerified:
        return state.settings.apiKey.isEmpty 
            ? 'Enter your API key to enable AI features'
            : 'Click refresh to verify your API key';
    }
  }
}