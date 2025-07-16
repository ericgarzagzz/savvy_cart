import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class ShopListListview extends ConsumerWidget {
  const ShopListListview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopListCollectionAsync = ref.watch(shopListCollectionProvider);
    return shopListCollectionAsync.when(
      loading: () => SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => SliverToBoxAdapter(
        child: Center(child: Text("Could not load shop lists due to an error.")),
      ),
      data: (data) {
        if (data.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(child: Text("No shop list yet.")),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Your Lists", style: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                        Text("${data.length} lists", style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                    SizedBox(height: 16),
                    ShopListListTile(shopList: data[index]),
                  ],
                );
              }
              return ShopListListTile(shopList: data[index]);
            },
            childCount: data.length,
          ),
        );
      },
    );
  }
}
