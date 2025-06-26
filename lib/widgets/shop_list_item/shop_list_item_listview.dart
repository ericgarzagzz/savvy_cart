import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/providers/shop_list_items_providers.dart';
import 'package:savvy_cart/widgets/shop_list_item/shop_list_item_listtile.dart';

class ShopListItemListview extends ConsumerWidget {
  final int shopListId;
  final bool checkedItems;

  const ShopListItemListview({super.key, required this.shopListId, required this.checkedItems});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopListItemAsync = ref.watch(shopListItemsProvider((shopListId, checkedItems)));
    return shopListItemAsync.when(
      loading: () => SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => SliverToBoxAdapter(
        child: Center(child: Text("Could not load shop list's items due to an error.")),
      ),
      data: (data) {
        if (data.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(child: Text("No items ${checkedItems ? "checked": "unchecked"} yet.")),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              return ShopListItemListtile(shopListItem: data[index]);
            },
            childCount: data.length,
          ),
        );
      },
    );
  }
}
