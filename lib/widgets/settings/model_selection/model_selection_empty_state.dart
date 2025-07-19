import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/providers/providers.dart';

class ModelSelectionEmptyState extends ConsumerWidget {
  final ModelFilters filters;

  const ModelSelectionEmptyState({super.key, required this.filters});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            hasFilters ? 'No models match your filters' : 'No models available',
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
}
