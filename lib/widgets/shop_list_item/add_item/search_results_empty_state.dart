import 'package:flutter/material.dart';

class SearchResultsEmptyState extends StatelessWidget {
  final String searchQuery;
  final VoidCallback onAddItem;

  const SearchResultsEmptyState({
    super.key,
    required this.searchQuery,
    required this.onAddItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Search Results (0)',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Icon(
          Icons.search_off,
          size: 64,
          color: Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(height: 16),
        Text(
          'No items found',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Try a different search term or add "$searchQuery" as a new item',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: onAddItem,
          icon: const Icon(Icons.add),
          label: Text('Add "$searchQuery"'),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
