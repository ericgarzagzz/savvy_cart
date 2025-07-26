import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';

class ShopListSectionHeader extends ConsumerWidget {
  final IconData icon;
  final String title;
  final int shopListId;
  final bool checkedItems;
  final VoidCallback? onAddItem;

  const ShopListSectionHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.shopListId,
    required this.checkedItems,
    this.onAddItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(
      shopListItemsProvider((shopListId, checkedItems)),
    );

    return itemsAsync.when(
      loading: () => SizedBox.shrink(),
      error: (_, __) => SizedBox.shrink(),
      data: (items) {
        // Determine colors based on section meaning
        final Color backgroundColor;
        final Color iconColor;

        if (checkedItems) {
          // "In Cart" - completed items (green theme)
          backgroundColor = Colors.green.shade50;
          iconColor = Colors.green.shade600;
        } else {
          // "To Buy" - incomplete items (orange theme)
          backgroundColor = Colors.orange.shade50;
          iconColor = Colors.orange.shade600;
        }

        return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: items.isEmpty
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    : backgroundColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                size: 18,
                color: items.isEmpty
                    ? Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
                    : iconColor,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                '$title (${items.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: items.isEmpty
                      ? Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            if (onAddItem != null && items.isNotEmpty)
              FilledButton.icon(
                onPressed: onAddItem,
                icon: const Icon(Icons.add, size: 18),
                label: Text(AppLocalizations.of(context).addItem),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  minimumSize: const Size(0, 44),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
