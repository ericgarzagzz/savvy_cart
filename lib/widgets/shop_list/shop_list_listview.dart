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
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 64, horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_basket_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "No Shopping Lists Yet",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Create your first shopping list above to start organizing your groceries and never forget an item again!",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
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
