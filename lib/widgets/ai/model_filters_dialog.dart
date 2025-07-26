import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/providers/providers.dart';

class ModelFiltersDialog extends ConsumerStatefulWidget {
  const ModelFiltersDialog({super.key});

  @override
  ConsumerState<ModelFiltersDialog> createState() => _ModelFiltersDialogState();
}

class _ModelFiltersDialogState extends ConsumerState<ModelFiltersDialog> {
  late ModelFilters _tempFilters;

  @override
  void initState() {
    super.initState();
    _tempFilters = ref.read(modelFiltersProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.filterModels,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Clear All Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear_all, size: 18),
                label: Text(AppLocalizations.of(context)!.clearAll),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Thinking Capabilities Filter
            _buildThinkingFilter(),
            const SizedBox(height: 24),

            // Token Limits Filters
            _buildTokenLimitsFilter(),
            const SizedBox(height: 24),

            // Temperature Filter
            _buildTemperatureFilter(),
            const SizedBox(height: 32),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _applyFilters,
                  child: Text(AppLocalizations.of(context)!.apply),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThinkingFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.thinkingCapabilities,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        SegmentedButton<bool?>(
          segments: [
            ButtonSegment<bool?>(
              value: null,
              label: Text(AppLocalizations.of(context)!.all),
              icon: Icon(Icons.all_inclusive),
            ),
            ButtonSegment<bool?>(
              value: true,
              label: Text(AppLocalizations.of(context)!.yes),
              icon: Icon(Icons.psychology),
            ),
            ButtonSegment<bool?>(
              value: false,
              label: Text(AppLocalizations.of(context)!.no),
              icon: Icon(Icons.psychology_outlined),
            ),
          ],
          selected: {_tempFilters.hasThinking},
          onSelectionChanged: (Set<bool?> selection) {
            setState(() {
              final selectedValue = selection.first;
              if (selectedValue == null) {
                // When "All" is selected, clear the hasThinking filter
                _tempFilters = _tempFilters.copyWith(clearHasThinking: true);
              } else {
                _tempFilters = _tempFilters.copyWith(
                  hasThinking: selectedValue,
                );
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildTokenLimitsFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.tokenLimits,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),

        // Input Tokens
        Text(
          AppLocalizations.of(context)!.inputTokensInMillions,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: RangeValues(
            _tempFilters.minInputTokens ?? 0,
            _tempFilters.maxInputTokens ?? 10,
          ),
          min: 0,
          max: 10,
          divisions: 20,
          labels: RangeLabels(
            '${(_tempFilters.minInputTokens ?? 0).toStringAsFixed(1)}M',
            '${(_tempFilters.maxInputTokens ?? 10).toStringAsFixed(1)}M',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _tempFilters = _tempFilters.copyWith(
                minInputTokens: values.start,
                maxInputTokens: values.end,
              );
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.minValue.replaceAll(
                  '{value}',
                  '${(_tempFilters.minInputTokens ?? 0).toStringAsFixed(1)}M',
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.maxValue.replaceAll(
                  '{value}',
                  '${(_tempFilters.maxInputTokens ?? 10).toStringAsFixed(1)}M',
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Output Tokens
        Text(
          AppLocalizations.of(context)!.outputTokensInMillions,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: RangeValues(
            _tempFilters.minOutputTokens ?? 0,
            _tempFilters.maxOutputTokens ?? 5,
          ),
          min: 0,
          max: 5,
          divisions: 20,
          labels: RangeLabels(
            '${(_tempFilters.minOutputTokens ?? 0).toStringAsFixed(1)}M',
            '${(_tempFilters.maxOutputTokens ?? 5).toStringAsFixed(1)}M',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _tempFilters = _tempFilters.copyWith(
                minOutputTokens: values.start,
                maxOutputTokens: values.end,
              );
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.minValue.replaceAll(
                  '{value}',
                  '${(_tempFilters.minOutputTokens ?? 0).toStringAsFixed(1)}M',
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.maxValue.replaceAll(
                  '{value}',
                  '${(_tempFilters.maxOutputTokens ?? 5).toStringAsFixed(1)}M',
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTemperatureFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.temperatureRange,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: RangeValues(
            _tempFilters.minTemperature ?? 0,
            _tempFilters.maxTemperature ?? 2,
          ),
          min: 0,
          max: 2,
          divisions: 20,
          labels: RangeLabels(
            (_tempFilters.minTemperature ?? 0).toStringAsFixed(1),
            (_tempFilters.maxTemperature ?? 2).toStringAsFixed(1),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _tempFilters = _tempFilters.copyWith(
                minTemperature: values.start,
                maxTemperature: values.end,
              );
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.minValue.replaceAll(
                  '{value}',
                  '${(_tempFilters.minTemperature ?? 0).toStringAsFixed(1)}',
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.maxValue.replaceAll(
                  '{value}',
                  '${(_tempFilters.maxTemperature ?? 2).toStringAsFixed(1)}',
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _clearFilters() {
    setState(() {
      _tempFilters = const ModelFilters();
    });
  }

  void _applyFilters() {
    ref.read(modelFiltersProvider.notifier).updateFilters(_tempFilters);
    Navigator.of(context).pop();
  }
}
