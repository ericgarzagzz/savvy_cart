import 'package:flutter/material.dart';
import 'package:savvy_cart/domain/models/shop_list_item.dart';
import 'package:savvy_cart/widgets/shop_list_item/shop_list_item_edit_form.dart';

class ShopListItemListtile extends StatelessWidget {
  final ShopListItem shopListItem;
  
  const ShopListItemListtile({super.key, required this.shopListItem});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8),
      leading: Checkbox(
        value: shopListItem.checked,
        onChanged: (value) => {},
      ),
      title: Text(shopListItem.name, style: Theme.of(context).textTheme.bodyLarge),
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
