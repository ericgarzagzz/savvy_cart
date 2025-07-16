import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class ShopListItemListtile extends ConsumerWidget {
  final ShopListItem shopListItem;
  
  const ShopListItemListtile({super.key, required this.shopListItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8),
      leading: Checkbox(
        value: shopListItem.checked,
        onChanged: (value) {
          if (value != null) {
            ref
                .read(shopListItemMutationProvider.notifier)
                .setChecked(shopListItem.id ?? 0, value);
          }
        },
      ),
      title: Text(
        shopListItem.name, 
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          decoration: shopListItem.checked ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Text(shopListItem.quantity.toString(), style: Theme.of(context).textTheme.bodyMedium),
          Text((shopListItem.unitPrice * shopListItem.quantity).toStringWithLocale(), style: Theme.of(context).textTheme.bodyMedium)
        ],
      ),
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (ctx) => ShopListItemEditForm(shopListItem: shopListItem)
        );
      },
    );
  }
}
