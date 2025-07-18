import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/services/services.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class ModelSelectionScreen extends ConsumerStatefulWidget {
  const ModelSelectionScreen({super.key});

  @override
  ConsumerState<ModelSelectionScreen> createState() =>
      _ModelSelectionScreenState();
}

class _ModelSelectionScreenState extends ConsumerState<ModelSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final aiSettingsState = ref.watch(aiSettingsProvider);
    final filters = ref.watch(modelFiltersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Gemini™ Model'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: filters.hasActiveFilters
                ? FilledButton.tonalIcon(
                    onPressed: () => _showFiltersDialog(context),
                    icon: const Icon(Icons.filter_list, size: 18),
                    label: Text('Filters (${_getActiveFilterCount(filters)})'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  )
                : TextButton.icon(
                    onPressed: () => _showFiltersDialog(context),
                    icon: const Icon(Icons.filter_list, size: 18),
                    label: const Text('Filter'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (filters.hasActiveFilters)
            _buildFilterNotification(context, filters),
          Expanded(child: _buildBody(context, ref, aiSettingsState, filters)),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AiSettingsState aiSettingsState,
    ModelFilters filters,
  ) {
    final rawModels = aiSettingsState.verificationResult?.geminiModels;
    final filteredModels = rawModels != null
        ? _applyFilters(rawModels, filters)
        : null;
    final models = filteredModels != null
        ? _sortModels(List.from(filteredModels))
        : null;

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
      final hasFilters = filters.hasActiveFilters;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasFilters ? Icons.filter_list_off : Icons.error_outline,
              size: 64,
              color: hasFilters
                  ? Theme.of(context).colorScheme.outline
                  : Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              hasFilters
                  ? 'No models match your filters'
                  : 'No models available',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              hasFilters
                  ? 'Try adjusting your filter settings to see more models'
                  : 'Unable to load models from the API',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  ref.read(modelFiltersProvider.notifier).clearFilters();
                },
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear All Filters'),
              ),
            ],
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
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
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
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : null,
                              ),
                        ),
                      ),
                      if (isRecommended)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Recommended',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
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
                  if (model.description != null &&
                      model.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      model.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? Theme.of(
                                context,
                              ).colorScheme.onPrimary.withOpacity(0.9)
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (model.version != null)
                        _buildChip(
                          context,
                          'Version ${model.version}',
                          Icons.info_outline,
                        ),
                      if (model.thinking == true)
                        _buildChip(context, 'Thinking', Icons.psychology),
                      if (model.temperature != null)
                        _buildChip(
                          context,
                          'Temp: ${model.temperature}',
                          Icons.thermostat,
                        ),
                      if (model.inputTokenLimit != null)
                        _buildChip(
                          context,
                          'Input: ${_formatTokenLimit(model.inputTokenLimit!)}',
                          Icons.input,
                        ),
                      if (model.outputTokenLimit != null)
                        _buildChip(
                          context,
                          'Output: ${_formatTokenLimit(model.outputTokenLimit!)}',
                          Icons.output,
                        ),
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
          Icon(
            icon,
            size: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
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

  List<GeminiModel> _applyFilters(
    List<GeminiModel> models,
    ModelFilters filters,
  ) {
    print('\n=== FILTERING MODELS ===');
    print('Filter settings:');
    print('  hasThinking: ${filters.hasThinking}');
    print('  minInputTokens: ${filters.minInputTokens}');
    print('  maxInputTokens: ${filters.maxInputTokens}');
    print('  minOutputTokens: ${filters.minOutputTokens}');
    print('  maxOutputTokens: ${filters.maxOutputTokens}');
    print('  minTemperature: ${filters.minTemperature}');
    print('  maxTemperature: ${filters.maxTemperature}');
    print('\nAvailable models before filtering:');
    for (final model in models) {
      print('  ${model.userFriendlyName}:');
      print('    thinking: ${model.thinking}');
      print('    inputTokenLimit: ${model.inputTokenLimit}');
      print('    outputTokenLimit: ${model.outputTokenLimit}');
      print('    temperature: ${model.temperature}');
    }

    final filteredModels = models.where((model) {
      bool passes = true;

      // Thinking filter
      if (filters.hasThinking != null) {
        if (filters.hasThinking == true && model.thinking != true) {
          print(
            '  ${model.userFriendlyName} FILTERED OUT: thinking ${model.thinking} != true (Yes filter)',
          );
          passes = false;
        } else if (filters.hasThinking == false && model.thinking == true) {
          print(
            '  ${model.userFriendlyName} FILTERED OUT: thinking ${model.thinking} == true (No filter)',
          );
          passes = false;
        }
        // For "No" filter (false), we accept both false and null
        // For "Yes" filter (true), we only accept true
      }

      // Input tokens filter
      if (filters.minInputTokens != null || filters.maxInputTokens != null) {
        final inputTokens =
            (model.inputTokenLimit ?? 0) / 1000000; // Convert to millions
        if (filters.minInputTokens != null &&
            inputTokens < filters.minInputTokens!) {
          print(
            '  ${model.userFriendlyName} FILTERED OUT: inputTokens $inputTokens < ${filters.minInputTokens}',
          );
          passes = false;
        }
        if (filters.maxInputTokens != null &&
            inputTokens > filters.maxInputTokens!) {
          print(
            '  ${model.userFriendlyName} FILTERED OUT: inputTokens $inputTokens > ${filters.maxInputTokens}',
          );
          passes = false;
        }
      }

      // Output tokens filter
      if (filters.minOutputTokens != null || filters.maxOutputTokens != null) {
        final outputTokens =
            (model.outputTokenLimit ?? 0) / 1000000; // Convert to millions
        if (filters.minOutputTokens != null &&
            outputTokens < filters.minOutputTokens!) {
          print(
            '  ${model.userFriendlyName} FILTERED OUT: outputTokens $outputTokens < ${filters.minOutputTokens}',
          );
          passes = false;
        }
        if (filters.maxOutputTokens != null &&
            outputTokens > filters.maxOutputTokens!) {
          print(
            '  ${model.userFriendlyName} FILTERED OUT: outputTokens $outputTokens > ${filters.maxOutputTokens}',
          );
          passes = false;
        }
      }

      // Temperature filter
      if (filters.minTemperature != null || filters.maxTemperature != null) {
        final temperature = model.temperature ?? 0;
        if (filters.minTemperature != null &&
            temperature < filters.minTemperature!) {
          print(
            '  ${model.userFriendlyName} FILTERED OUT: temperature $temperature < ${filters.minTemperature}',
          );
          passes = false;
        }
        if (filters.maxTemperature != null &&
            temperature > filters.maxTemperature!) {
          print(
            '  ${model.userFriendlyName} FILTERED OUT: temperature $temperature > ${filters.maxTemperature}',
          );
          passes = false;
        }
      }

      if (passes) {
        print('  ${model.userFriendlyName} PASSES filter');
      }

      return passes;
    }).toList();

    print('\nFiltered models result: ${filteredModels.length} models');
    for (final model in filteredModels) {
      print('  - ${model.userFriendlyName}');
    }
    print('=== END FILTERING ===\n');

    return filteredModels;
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
      if (a.cleanName.contains('pro') && b.cleanName.contains('flash'))
        return -1;
      if (a.cleanName.contains('flash') && b.cleanName.contains('pro'))
        return 1;

      // Fallback to alphabetical
      return a.cleanName.compareTo(b.cleanName);
    });

    return models;
  }

  Widget _buildFilterNotification(BuildContext context, ModelFilters filters) {
    final activeFilters = <String>[];

    if (filters.hasThinking != null) {
      activeFilters.add('Thinking: ${filters.hasThinking! ? "Yes" : "No"}');
    }

    if (filters.minInputTokens != null || filters.maxInputTokens != null) {
      final min = filters.minInputTokens?.toStringAsFixed(1) ?? '0.0';
      final max = filters.maxInputTokens?.toStringAsFixed(1) ?? '10.0';
      activeFilters.add('Input: ${min}M-${max}M tokens');
    }

    if (filters.minOutputTokens != null || filters.maxOutputTokens != null) {
      final min = filters.minOutputTokens?.toStringAsFixed(1) ?? '0.0';
      final max = filters.maxOutputTokens?.toStringAsFixed(1) ?? '5.0';
      activeFilters.add('Output: ${min}M-${max}M tokens');
    }

    if (filters.minTemperature != null || filters.maxTemperature != null) {
      final min = filters.minTemperature?.toStringAsFixed(1) ?? '0.0';
      final max = filters.maxTemperature?.toStringAsFixed(1) ?? '2.0';
      activeFilters.add('Temperature: ${min}-${max}');
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              Icons.filter_list,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Filtered by: ',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                ...activeFilters.map(
                  (filter) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              ref.read(modelFiltersProvider.notifier).clearFilters();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.errorContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Clear',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getActiveFilterCount(ModelFilters filters) {
    int count = 0;
    if (filters.hasThinking != null) count++;
    if (filters.minInputTokens != null || filters.maxInputTokens != null)
      count++;
    if (filters.minOutputTokens != null || filters.maxOutputTokens != null)
      count++;
    if (filters.minTemperature != null || filters.maxTemperature != null)
      count++;
    return count;
  }

  void _showFiltersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ModelFiltersDialog(),
    );
  }

  void _selectModel(BuildContext context, WidgetRef ref, String modelName) {
    ref.read(aiSettingsProvider.notifier).updateModelOnly(modelName);
    // Stay on screen - user navigates back manually when ready
  }
}
