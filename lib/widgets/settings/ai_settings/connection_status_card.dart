import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/services/services.dart';

class ConnectionStatusCard extends ConsumerWidget {
  const ConnectionStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiSettingsState = ref.watch(aiSettingsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      aiSettingsState,
                    ).withValues(alpha: 0.1),
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
                        _getStatusTitle(aiSettingsState, context),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(aiSettingsState),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getStatusSubtitle(aiSettingsState, context),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                if (aiSettingsState.settings.apiKey.isNotEmpty &&
                    !aiSettingsState.isVerifying)
                  IconButton(
                    onPressed: () =>
                        ref.read(aiSettingsProvider.notifier).verifyApiKey(),
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Verify API key',
                  ),
              ],
            ),
          ],
        ),
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
        return state.settings.apiKey.isEmpty
            ? Icons.warning
            : Icons.help_outline;
    }
  }

  String _getStatusTitle(AiSettingsState state, BuildContext context) {
    if (state.isVerifying) return AppLocalizations.of(context).verifyingApiKey;

    switch (state.connectionStatus) {
      case ApiConnectionStatus.connected:
        return AppLocalizations.of(context).apiConnected;
      case ApiConnectionStatus.invalidKey:
        return 'Invalid API Key';
      case ApiConnectionStatus.networkError:
        return 'Network Error';
      case ApiConnectionStatus.error:
        return 'Connection Error';
      case ApiConnectionStatus.notVerified:
        return state.settings.apiKey.isEmpty
            ? 'API Key Required'
            : 'Not Verified';
    }
  }

  String _getStatusSubtitle(AiSettingsState state, BuildContext context) {
    if (state.isVerifying) {
      return AppLocalizations.of(context).checkingConnectionGemini;
    }

    if (state.verificationResult != null) {
      final result = state.verificationResult!;
      if (result.isValid) {
        final modelCount = result.availableModels?.length ?? 0;
        if (modelCount > 0) {
          return AppLocalizations.of(context).connectedWithModels(modelCount);
        } else {
          return AppLocalizations.of(context).connected;
        }
      } else {
        return result.error ?? 'Verification failed';
      }
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
