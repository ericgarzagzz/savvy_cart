import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/providers/settings_providers.dart';
import 'package:savvy_cart/services/gemini_api_verification_service.dart';

class ModelSelectionScreen extends ConsumerWidget {
  const ModelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiSettingsState = ref.watch(aiSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select AI Model'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: _buildBody(context, ref, aiSettingsState),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, AiSettingsState aiSettingsState) {
    final rawModels = aiSettingsState.verificationResult?.geminiModels;
    final models = rawModels != null ? _sortModels(List.from(rawModels)) : null;

    if (aiSettingsState.isVerifying) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading available models...'),
          ],
        ),
      );
    }

    if (models == null || models.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'No models available',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your API key and connection',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: models.length,
      itemBuilder: (context, index) {
        final model = models[index];
        final currentSelectedModel = aiSettingsState.settings.model;
        final isSelected = model.cleanName == currentSelectedModel;
        final isRecommended = model.cleanName == 'gemini-2.0-flash';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: isSelected ? 3 : 1,
          color: isSelected 
            ? Theme.of(context).colorScheme.primary
            : null,
          child: InkWell(
            onTap: () => _selectModel(context, ref, model.cleanName),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          model.userFriendlyName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Theme.of(context).colorScheme.onPrimary : null,
                          ),
                        ),
                      ),
                      if (isRecommended)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected 
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Recommended',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isSelected 
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      if (isSelected)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                  if (model.description != null && model.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      model.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected 
                          ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.9)
                          : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (model.version != null)
                        _buildChip(context, 'Version ${model.version}', Icons.info_outline),
                      if (model.thinking == true)
                        _buildChip(context, 'Thinking', Icons.psychology),
                      if (model.temperature != null)
                        _buildChip(context, 'Temp: ${model.temperature}', Icons.thermostat),
                      if (model.inputTokenLimit != null)
                        _buildChip(context, 'Input: ${_formatTokenLimit(model.inputTokenLimit!)}', Icons.input),
                      if (model.outputTokenLimit != null)
                        _buildChip(context, 'Output: ${_formatTokenLimit(model.outputTokenLimit!)}', Icons.output),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChip(BuildContext context, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTokenLimit(int limit) {
    if (limit >= 1000000) {
      return '${(limit / 1000000).toStringAsFixed(1)}M';
    } else if (limit >= 1000) {
      return '${(limit / 1000).toStringAsFixed(0)}K';
    }
    return limit.toString();
  }

  List<GeminiModel> _sortModels(List<GeminiModel> models) {
    models.sort((a, b) {
      // Recommended model (gemini-2.0-flash) always goes first
      if (a.cleanName == 'gemini-2.0-flash') return -1;
      if (b.cleanName == 'gemini-2.0-flash') return 1;
      
      // Sort by version descending (newer versions first)
      final versionA = double.tryParse(a.version ?? '0') ?? 0;
      final versionB = double.tryParse(b.version ?? '0') ?? 0;
      final versionCompare = versionB.compareTo(versionA);
      if (versionCompare != 0) return versionCompare;
      
      // If same version, sort by model type (pro before flash)
      if (a.cleanName.contains('pro') && b.cleanName.contains('flash')) return -1;
      if (a.cleanName.contains('flash') && b.cleanName.contains('pro')) return 1;
      
      // Fallback to alphabetical
      return a.cleanName.compareTo(b.cleanName);
    });
    
    return models;
  }

  void _selectModel(BuildContext context, WidgetRef ref, String modelName) {
    ref.read(aiSettingsProvider.notifier).updateModelOnly(modelName);
    // Stay on screen - user navigates back manually when ready
  }
}