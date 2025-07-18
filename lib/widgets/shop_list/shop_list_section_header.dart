import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/providers/providers.dart';

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
        return Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: items.isEmpty
                  ? Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
                  : Theme.of(context).colorScheme.onSurface,
            ),
            SizedBox(width: 8),
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
                label: const Text('Add Item'),
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
