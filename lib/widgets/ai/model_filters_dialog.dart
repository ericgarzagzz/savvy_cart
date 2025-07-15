import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                  'Filter Models',
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
                label: const Text('Clear All'),
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
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _applyFilters,
                  child: const Text('Apply'),
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
          'Thinking Capabilities',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        SegmentedButton<bool?>(
          segments: const [
            ButtonSegment<bool?>(
              value: null,
              label: Text('All'),
              icon: Icon(Icons.all_inclusive),
            ),
            ButtonSegment<bool?>(
              value: true,
              label: Text('Yes'),
              icon: Icon(Icons.psychology),
            ),
            ButtonSegment<bool?>(
              value: false,
              label: Text('No'),
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
                _tempFilters = _tempFilters.copyWith(hasThinking: selectedValue);
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
          'Token Limits',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        
        // Input Tokens
        Text(
          'Input Tokens (in millions)',
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
                'Min: ${(_tempFilters.minInputTokens ?? 0).toStringAsFixed(1)}M',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Max: ${(_tempFilters.maxInputTokens ?? 10).toStringAsFixed(1)}M',
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
          'Output Tokens (in millions)',
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
                'Min: ${(_tempFilters.minOutputTokens ?? 0).toStringAsFixed(1)}M',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Max: ${(_tempFilters.maxOutputTokens ?? 5).toStringAsFixed(1)}M',
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
          'Temperature Range',
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
                'Min: ${(_tempFilters.minTemperature ?? 0).toStringAsFixed(1)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Max: ${(_tempFilters.maxTemperature ?? 2).toStringAsFixed(1)}',
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