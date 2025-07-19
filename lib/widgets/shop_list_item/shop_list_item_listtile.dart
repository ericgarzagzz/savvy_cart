import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class ShopListItemListtile extends ConsumerWidget {
  final ShopListItem shopListItem;

  const ShopListItemListtile({super.key, required this.shopListItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      key: ValueKey(shopListItem.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              context.go(
                './price-chart/${Uri.encodeComponent(shopListItem.name)}',
              );
            },
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            icon: Icons.trending_up,
          ),
          SlidableAction(
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (ctx) =>
                    ShopListItemNameEditDialog(shopListItem: shopListItem),
              );
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            icon: Icons.edit,
          ),
          SlidableAction(
            onPressed: (context) async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Item'),
                  content: Text(
                    'Are you sure you want to delete "${shopListItem.name}"?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirm != true) return;

              await ref
                  .read(shopListItemMutationProvider.notifier)
                  .deleteItem(shopListItem.id ?? 0);
            },
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Colors.white,
            icon: Icons.delete,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        leading: Transform.scale(
          scale: 1.2,
          child: Checkbox(
            value: shopListItem.checked,
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(shopListItemMutationProvider.notifier)
                    .setChecked(shopListItem.id ?? 0, value);
              }
            },
          ),
        ),
        title: Text(
          shopListItem.name,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            decoration: shopListItem.checked
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Text(
              shopListItem.quantity.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              (shopListItem.unitPrice * shopListItem.quantity)
                  .toStringWithLocale(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (ctx) => ShopListItemEditForm(shopListItem: shopListItem),
          );
        },
      ),
    );
  }
}
