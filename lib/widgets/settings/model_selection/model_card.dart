import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/widgets/widgets.dart';
import 'package:savvy_cart/services/services.dart';

class ModelCard extends ConsumerWidget {
  final GeminiModel model;
  final String currentSelectedModel;
  final VoidCallback onTap;

  const ModelCard({
    super.key,
    required this.model,
    required this.currentSelectedModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = model.cleanName == currentSelectedModel;
    final isRecommended = model.cleanName == 'gemini-2.0-flash';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 3 : 1,
      color: isSelected ? Theme.of(context).colorScheme.primary : null,
      child: InkWell(
        onTap: onTap,
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
                            : Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        AppLocalizations.of(context).recommended,
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
                          ).colorScheme.onPrimary.withValues(alpha: 0.9)
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (model.version != null)
                    ModelPropertyChip(
                      label: 'Version ${model.version}',
                      icon: Icons.info_outline,
                    ),
                  if (model.thinking == true)
                    ModelPropertyChip(
                      label: 'Thinking',
                      icon: Icons.psychology,
                    ),
                  if (model.temperature != null)
                    ModelPropertyChip(
                      label: 'Temp: ${model.temperature}',
                      icon: Icons.thermostat,
                    ),
                  if (model.inputTokenLimit != null)
                    ModelPropertyChip(
                      label:
                          'Input: ${_formatTokenLimit(model.inputTokenLimit!)}',
                      icon: Icons.input,
                    ),
                  if (model.outputTokenLimit != null)
                    ModelPropertyChip(
                      label:
                          'Output: ${_formatTokenLimit(model.outputTokenLimit!)}',
                      icon: Icons.output,
                    ),
                ],
              ),
            ],
          ),
        ),
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
}
