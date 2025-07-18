import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/models/models.dart';

class AiActionSelectionSheet extends ConsumerStatefulWidget {
  final GeminiResponse geminiResponse;
  final int shopListId;

  const AiActionSelectionSheet({
    super.key,
    required this.geminiResponse,
    required this.shopListId,
  });

  @override
  ConsumerState<AiActionSelectionSheet> createState() =>
      _AiActionSelectionSheetState();
}

class _AiActionSelectionSheetState
    extends ConsumerState<AiActionSelectionSheet> {
  late List<bool> _selectedActions;

  @override
  void initState() {
    super.initState();
    _selectedActions = List.generate(
      widget.geminiResponse.actions.length,
      (index) => true,
    ); // All actions initially selected
  }

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
                'Review AI Suggestions',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: widget.geminiResponse.actions.length,
                itemBuilder: (context, index) {
                  final action = widget.geminiResponse.actions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: CheckboxListTile(
                      title: Row(
                        children: [
                          Icon(
                            _getOperationIcon(action.operation),
                            color: _getOperationColor(
                              context,
                              action.operation,
                            ),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _getActionDescription(action),
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      subtitle: _buildActionSubtitle(context, action),
                      value: _selectedActions[index],
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedActions[index] = value!;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_hasSelectedActions())
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Please select at least one action to execute',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _hasSelectedActions()
                          ? () {
                              final List<GeminiAction> actionsToExecute = [];
                              for (
                                int i = 0;
                                i < _selectedActions.length;
                                i++
                              ) {
                                if (_selectedActions[i]) {
                                  actionsToExecute.add(
                                    widget.geminiResponse.actions[i],
                                  );
                                }
                              }
                              Navigator.of(context).pop(actionsToExecute);
                            }
                          : null,
                      child: const Text('Execute Selected Actions'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  bool _hasSelectedActions() {
    return _selectedActions.any((selected) => selected);
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
        return "Add ${action.item}";
      case GeminiOperation.remove:
        return "Remove ${action.item}";
      case GeminiOperation.update:
        return "Update ${action.item}";
      case GeminiOperation.check:
        return "Mark ${action.item} as completed";
      case GeminiOperation.uncheck:
        return "Mark ${action.item} as not completed";
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

    return Padding(
      padding: const EdgeInsets.only(left: 28),
      child: Text(
        details.join(" • "),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
