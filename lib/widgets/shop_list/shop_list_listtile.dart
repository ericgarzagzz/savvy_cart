import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:savvy_cart/domain/types/money.dart';
import 'package:savvy_cart/models/shop_list/shop_list_view_model.dart';
import 'package:savvy_cart/widgets/shop_list/delete_shop_list_dialog.dart';

class ShopListListTile extends StatelessWidget {
  final ShopListViewModel shopList;

  const ShopListListTile({super.key, required this.shopList});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 16,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(shopList.name,
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.bold)
                    ),
                    Text(shopList.checkedAmount.toStringWithLocale(),
                        style: Theme.of(context).textTheme.bodyMedium
                    )
                  ],
                ),
                LinearProgressIndicator(
                    value: .2,
                    backgroundColor: Colors.grey,
                    minHeight: 8
                )
              ],
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                foregroundColor: Theme.of(context).colorScheme.onError
            ),
            child: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => DeleteShopListDialog(shopList: shopList),
                barrierDismissible: false,
              );
            },
          )
        ],
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 16),
        child: Row(
          children: [
            OutlinedButton(
              child: const Row(
                children: [
                  Text("Open"),
                  SizedBox(width: 4),
                  Icon(Icons.navigate_next),
                ],
              ),
              onPressed: () => context.go("/manage/${shopList.id}"),
            )
          ],
        ),
      ),
      onTap: () => context.go("/manage/${shopList.id}"),
    );
  }
}
