import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/generic_error_scaffold.dart';
import 'package:savvy_cart/widgets/shop_list/shop_list_summary.dart';
import 'package:savvy_cart/widgets/shop_list_item/shop_list_item_listview.dart';

class ShopListManager extends ConsumerStatefulWidget {
  final int shopListId;

  const ShopListManager({super.key, required this.shopListId});

  @override
  ConsumerState<ShopListManager> createState() => _ShopListManagerState();
}

class _ShopListManagerState extends ConsumerState<ShopListManager> {
  @override
  Widget build(BuildContext context) {
    final getShopListByIdAsync = ref.watch(getShopListByIdProvider(widget.shopListId));

    return getShopListByIdAsync.when(
      loading: () => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stackTrace) => GenericErrorScaffold(errorMessage: err.toString()),
      data: (shopList) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
                title: Text(shopList.name)
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: ShopListItemListview(
                shopListId: widget.shopListId,
                checkedItems: false,
              ),
            ),
            SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: ShopListSummary(),
                )
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: ShopListItemListview(
                shopListId: widget.shopListId,
                checkedItems: true,
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text("Add item"),
          onPressed: () {
            context.go("./add-item");
          },
        )
      )
    );
  }
}
