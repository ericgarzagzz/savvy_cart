import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/shop_list/shop_list_listtile.dart';

class ShopListListview extends ConsumerWidget {
  const ShopListListview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopListCollectionAsync = ref.watch(shopListCollectionProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Shop lists", style: Theme.of(context).textTheme.bodyLarge),
        SizedBox(height: 16),
        shopListCollectionAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text("Could not load shop lists due to an error.")),
          data: (data) => data.isEmpty ?
          Center(child: Text("No shop list yet.")) : ListView(
            shrinkWrap: true,
            primary: false,
            children: data.map((shopList) {
              return ShopListListTile(shopList: shopList);
            }).toList(),
          )
        ),
      ],
    );
  }
}
