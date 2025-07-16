import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/providers/providers.dart';

class ShopListSectionHeader extends ConsumerWidget {
  final IconData icon;
  final String title;
  final int shopListId;
  final bool checkedItems;

  const ShopListSectionHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.shopListId,
    required this.checkedItems,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(shopListItemsProvider((shopListId, checkedItems)));
    
    return itemsAsync.when(
      loading: () => SizedBox.shrink(),
      error: (_, __) => SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty && checkedItems) {
          return SizedBox.shrink();
        }
        
        return Row(
          children: [
            Icon(icon, size: 20),
            SizedBox(width: 8),
            Text(
              '$title (${items.length})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }
}