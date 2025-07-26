import 'package:flutter/material.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';

class ModelFilterButton extends StatelessWidget {
  final ModelFilters filters;
  final VoidCallback onPressed;

  const ModelFilterButton({
    super.key,
    required this.filters,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: filters.hasActiveFilters
          ? FilledButton.tonalIcon(
              onPressed: onPressed,
              icon: const Icon(Icons.filter_list, size: 18),
              label: Text(
                AppLocalizations.of(
                  context,
                ).filtersWithCount(_getActiveFilterCount(filters)),
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            )
          : TextButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.filter_list, size: 18),
              label: Text(AppLocalizations.of(context).filter),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
    );
  }

  int _getActiveFilterCount(ModelFilters filters) {
    int count = 0;
    if (filters.hasThinking != null) count++;
    if (filters.minInputTokens != null || filters.maxInputTokens != null) {
      count++;
    }
    if (filters.minOutputTokens != null || filters.maxOutputTokens != null) {
      count++;
    }
    if (filters.minTemperature != null || filters.maxTemperature != null) {
      count++;
    }
    return count;
  }
}
