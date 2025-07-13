import 'package:flutter/material.dart';
import 'package:savvy_cart/models/gemini_action.dart';

class ExecutedActionsReviewSheet extends StatelessWidget {
  final List<GeminiAction> executedActions;

  const ExecutedActionsReviewSheet({
    super.key,
    required this.executedActions,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.25,
      maxChildSize: 0.9,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Applied Actions',
                style: Theme.of(context).textTheme.headlineSmall,
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
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No actions were applied',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: executedActions.length,
                  itemBuilder: (context, index) {
                    final action = executedActions[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: Icon(
                          _getOperationIcon(action.operation),
                          color: _getOperationColor(context, action.operation),
                          size: 24,
                        ),
                        title: Text(
                          _getActionDescription(action),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: _buildActionSubtitle(context, action),
                        trailing: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        ),
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
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

  String _getActionDescription(GeminiAction action) {
    switch (action.operation) {
      case GeminiOperation.add:
        return "Added ${action.item}";
      case GeminiOperation.remove:
        return "Removed ${action.item}";
      case GeminiOperation.update:
        return "Updated ${action.item}";
      case GeminiOperation.check:
        return "Marked ${action.item} as completed";
      case GeminiOperation.uncheck:
        return "Marked ${action.item} as not completed";
    }
  }

  Widget? _buildActionSubtitle(BuildContext context, GeminiAction action) {
    List<String> details = [];
    
    if (action.quantity != null) {
      details.add("Quantity: ${action.quantity}");
    }
    
    if (action.unitPrice != null && action.unitPrice! > 0) {
      details.add("Price: \$${action.unitPrice!.toStringAsFixed(2)}");
    }
    
    if (details.isEmpty) return null;
    
    return Text(
      details.join(" • "),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
      ),
    );
  }
}