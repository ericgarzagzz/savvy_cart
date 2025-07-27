import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';
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
    final updateActions = <int, GeminiAction>{};
    final addActions = <int, GeminiAction>{};
    final removeActions = <int, GeminiAction>{};

    // Separate actions into update (existing) and add (new) categories
    for (int i = 0; i < widget.geminiResponse.actions.length; i++) {
      final action = widget.geminiResponse.actions[i];
      if (action.operation == GeminiOperation.update ||
          action.operation == GeminiOperation.check ||
          action.operation == GeminiOperation.uncheck) {
        updateActions[i] = action;
      } else if (action.operation == GeminiOperation.add) {
        addActions[i] = action;
      } else if (action.operation == GeminiOperation.remove) {
        removeActions[i] = action;
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
                      AppLocalizations.of(context).reviewAiSuggestions,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        final allSelected = _selectedActions.every(
                          (selected) => selected,
                        );
                        for (int i = 0; i < _selectedActions.length; i++) {
                          _selectedActions[i] = !allSelected;
                        }
                      });
                    },
                    icon: Icon(
                      _selectedActions.every((selected) => selected)
                          ? Icons.deselect
                          : Icons.select_all,
                      size: 18,
                    ),
                    label: Text(AppLocalizations.of(context).selectAll),
                  ),
                ],
              ),
            ),

            // Selection count bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).selectedItems(
                        _selectedActions.where((selected) => selected).length,
                        _selectedActions.length,
                      ),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(
                      context,
                    ).totalCost(_calculateTotalCost()),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

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
                    ...updateActions.entries.map(
                      (entry) =>
                          _buildActionCard(context, entry.value, entry.key),
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
                    ...addActions.entries.map(
                      (entry) =>
                          _buildActionCard(context, entry.value, entry.key),
                    ),
                  ],

                  // Delete Section
                  if (removeActions.isNotEmpty) ...[
                    _buildSectionHeader(
                      context,
                      AppLocalizations.of(context).delete,
                      removeActions.length,
                    ),
                    const SizedBox(height: 8),
                    ...removeActions.entries.map(
                      (entry) =>
                          _buildActionCard(context, entry.value, entry.key),
                    ),
                  ],
                ],
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
                              AppLocalizations.of(
                                context,
                              ).pleaseSelectAtLeastOneAction,
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                        padding: EdgeInsets.symmetric(vertical: 21),
                      ),
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
                      child: Text(
                        AppLocalizations.of(context).executeSelectedActions,
                      ),
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

  String _calculateTotalCost() {
    double total = 0.0;
    for (int i = 0; i < widget.geminiResponse.actions.length; i++) {
      if (_selectedActions[i]) {
        final action = widget.geminiResponse.actions[i];
        if (action.unitPrice != null && action.quantity != null) {
          total += action.unitPrice! * action.quantity!;
        }
      }
    }
    return total > 0 ? '\$${total.toStringAsFixed(2)}' : '';
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
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              '$count',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    GeminiAction action,
    int index,
  ) {
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            setState(() {
              _selectedActions[index] = !_selectedActions[index];
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Checkbox
                Checkbox(
                  value: _selectedActions[index],
                  onChanged: (bool? value) {
                    setState(() {
                      _selectedActions[index] = value!;
                    });
                  },
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
                            color: _getOperationColor(
                              context,
                              action.operation,
                            ),
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
                      if (action.quantity != null ||
                          action.unitPrice != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (action.quantity != null) ...[
                              Text(
                                '${AppLocalizations.of(context).quantity}: ${action.quantity}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
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
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
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
        ),
      ),
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
}
