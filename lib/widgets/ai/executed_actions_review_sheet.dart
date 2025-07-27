import 'package:flutter/material.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/models/models.dart';

class ExecutedActionsReviewSheet extends StatelessWidget {
  final List<GeminiAction> executedActions;

  const ExecutedActionsReviewSheet({super.key, required this.executedActions});

  @override
  Widget build(BuildContext context) {
    final updateActions = <GeminiAction>[];
    final addActions = <GeminiAction>[];
    final removeActions = <GeminiAction>[];

    // Separate actions into categories
    for (final action in executedActions) {
      if (action.operation == GeminiOperation.update ||
          action.operation == GeminiOperation.check ||
          action.operation == GeminiOperation.uncheck) {
        updateActions.add(action);
      } else if (action.operation == GeminiOperation.add) {
        addActions.add(action);
      } else if (action.operation == GeminiOperation.remove) {
        removeActions.add(action);
      }
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.25,
      maxChildSize: 0.9,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).appliedActions,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${executedActions.length}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (executedActions.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 48,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context).noActionsWereApplied,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // Update Existing Section
                    if (updateActions.isNotEmpty) ...[
                      _buildSectionHeader(
                        context,
                        AppLocalizations.of(context).updateExisting,
                        updateActions.length,
                      ),
                      const SizedBox(height: 8),
                      ...updateActions.map(
                        (action) => _buildActionCard(context, action),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Add New Section
                    if (addActions.isNotEmpty) ...[
                      _buildSectionHeader(
                        context,
                        AppLocalizations.of(context).addNew,
                        addActions.length,
                      ),
                      const SizedBox(height: 8),
                      ...addActions.map(
                        (action) => _buildActionCard(context, action),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Delete Section
                    if (removeActions.isNotEmpty) ...[
                      _buildSectionHeader(
                        context,
                        AppLocalizations.of(context).delete,
                        removeActions.length,
                      ),
                      const SizedBox(height: 8),
                      ...removeActions.map(
                        (action) => _buildActionCard(context, action),
                      ),
                    ],
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 21),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context).close),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _getOperationIcon(GeminiOperation operation) {
    switch (operation) {
      case GeminiOperation.add:
        return Icons.add_circle_outline;
      case GeminiOperation.remove:
        return Icons.remove_circle_outline;
      case GeminiOperation.update:
        return Icons.edit_outlined;
      case GeminiOperation.check:
        return Icons.check_circle_outline;
      case GeminiOperation.uncheck:
        return Icons.radio_button_unchecked;
    }
  }

  Color _getOperationColor(BuildContext context, GeminiOperation operation) {
    switch (operation) {
      case GeminiOperation.add:
        return Colors.green;
      case GeminiOperation.remove:
        return Colors.red;
      case GeminiOperation.update:
        return Colors.orange;
      case GeminiOperation.check:
        return Colors.blue;
      case GeminiOperation.uncheck:
        return Colors.grey;
    }
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              '$count',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, GeminiAction action) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Success icon
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(Icons.check_circle, color: Colors.green, size: 20),
            ),
            const SizedBox(width: 12),

            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getOperationIcon(action.operation),
                        color: _getOperationColor(context, action.operation),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          action.item,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  if (action.quantity != null || action.unitPrice != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (action.quantity != null) ...[
                          Text(
                            '${AppLocalizations.of(context).quantity}: ${action.quantity}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                          ),
                          if (action.unitPrice != null) const Text(' • '),
                        ],
                        if (action.unitPrice != null)
                          Text(
                            '\$${action.unitPrice!.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
