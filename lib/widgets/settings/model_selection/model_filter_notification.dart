import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/providers/providers.dart';

class ModelFilterNotification extends ConsumerWidget {
  final ModelFilters filters;

  const ModelFilterNotification({super.key, required this.filters});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = <String>[];

    if (filters.hasThinking != null) {
      activeFilters.add(
        '${AppLocalizations.of(context).thinking}: ${filters.hasThinking! ? AppLocalizations.of(context).yes : AppLocalizations.of(context).no}',
      );
    }

    if (filters.minInputTokens != null || filters.maxInputTokens != null) {
      final min = filters.minInputTokens?.toStringAsFixed(1) ?? '0.0';
      final max = filters.maxInputTokens?.toStringAsFixed(1) ?? '10.0';
      activeFilters.add(
        '${AppLocalizations.of(context).input}: $min${AppLocalizations.of(context).tokensUnit}-$max${AppLocalizations.of(context).tokensUnit}',
      );
    }

    if (filters.minOutputTokens != null || filters.maxOutputTokens != null) {
      final min = filters.minOutputTokens?.toStringAsFixed(1) ?? '0.0';
      final max = filters.maxOutputTokens?.toStringAsFixed(1) ?? '5.0';
      activeFilters.add(
        '${AppLocalizations.of(context).output}: $min${AppLocalizations.of(context).tokensUnit}-$max${AppLocalizations.of(context).tokensUnit}',
      );
    }

    if (filters.minTemperature != null || filters.maxTemperature != null) {
      final min = filters.minTemperature?.toStringAsFixed(1) ?? '0.0';
      final max = filters.maxTemperature?.toStringAsFixed(1) ?? '2.0';
      activeFilters.add(
        '${AppLocalizations.of(context).temperature}: $min-$max',
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
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
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  '${AppLocalizations.of(context).filteredBy}: ',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
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
                        ).colorScheme.primaryContainer.withValues(alpha: 0.5),
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
                ).colorScheme.errorContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                AppLocalizations.of(context).clear,
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
}
