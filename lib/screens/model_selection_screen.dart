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
          ModelFilterButton(
            filters: filters,
            onPressed: () => _showFiltersDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          if (filters.hasActiveFilters)
            ModelFilterNotification(filters: filters),
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
      return const ModelSelectionLoadingState();
    }

    if (models == null || models.isEmpty) {
      return ModelSelectionEmptyState(filters: filters);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: models.length,
      itemBuilder: (context, index) {
        final model = models[index];
        final currentSelectedModel = aiSettingsState.settings.model;

        return ModelCard(
          model: model,
          currentSelectedModel: currentSelectedModel,
          onTap: () => _selectModel(context, ref, model.cleanName),
        );
      },
    );
  }

  List<GeminiModel> _applyFilters(
    List<GeminiModel> models,
    ModelFilters filters,
  ) {
    final filteredModels = models.where((model) {
      bool passes = true;

      // Thinking filter
      if (filters.hasThinking != null) {
        if (filters.hasThinking == true && model.thinking != true) {
          passes = false;
        } else if (filters.hasThinking == false && model.thinking == true) {
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
          passes = false;
        }
        if (filters.maxInputTokens != null &&
            inputTokens > filters.maxInputTokens!) {
          passes = false;
        }
      }

      // Output tokens filter
      if (filters.minOutputTokens != null || filters.maxOutputTokens != null) {
        final outputTokens =
            (model.outputTokenLimit ?? 0) / 1000000; // Convert to millions
        if (filters.minOutputTokens != null &&
            outputTokens < filters.minOutputTokens!) {
          passes = false;
        }
        if (filters.maxOutputTokens != null &&
            outputTokens > filters.maxOutputTokens!) {
          passes = false;
        }
      }

      // Temperature filter
      if (filters.minTemperature != null || filters.maxTemperature != null) {
        final temperature = model.temperature ?? 0;
        if (filters.minTemperature != null &&
            temperature < filters.minTemperature!) {
          passes = false;
        }
        if (filters.maxTemperature != null &&
            temperature > filters.maxTemperature!) {
          passes = false;
        }
      }

      return passes;
    }).toList();

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
      if (a.cleanName.contains('pro') && b.cleanName.contains('flash')) {
        return -1;
      }
      if (a.cleanName.contains('flash') && b.cleanName.contains('pro')) {
        return 1;
      }

      // Fallback to alphabetical
      return a.cleanName.compareTo(b.cleanName);
    });

    return models;
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
