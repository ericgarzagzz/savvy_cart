import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class ShopListListview extends ConsumerStatefulWidget {
  const ShopListListview({super.key});

  @override
  ConsumerState<ShopListListview> createState() => _ShopListListviewState();
}

class _ShopListListviewState extends ConsumerState<ShopListListview> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paginatedShopListsProvider.notifier).loadInitial();
    });
  }

  @override
  Widget build(BuildContext context) {
    final paginatedState = ref.watch(paginatedShopListsProvider);

    if (paginatedState.items.isEmpty && paginatedState.isLoading) {
      return SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (paginatedState.items.isEmpty && !paginatedState.isLoading) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 64, horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.3),
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
                    Text(
                      "Recent Lists",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Row(
                      children: [
                        Text(
                          "${paginatedState.items.length} shown",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(width: 8),
                        InkWell(
                          onTap: () => context.go("./search-lists"),
                          borderRadius: BorderRadius.circular(4),
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.search,
                              size: 20,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            );
          }

          final actualIndex = index - 1;
          if (actualIndex < paginatedState.items.length) {
            return ShopListListTile(
              shopList: paginatedState.items[actualIndex],
            );
          }

          // Load more button
          if (paginatedState.hasMore) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: paginatedState.isLoading
                    ? CircularProgressIndicator()
                    : OutlinedButton.icon(
                        onPressed: () => ref
                            .read(paginatedShopListsProvider.notifier)
                            .loadMore(),
                        icon: Icon(Icons.expand_more),
                        label: Text("Load More"),
                      ),
              ),
            );
          }

          return SizedBox.shrink();
        },
        childCount:
            paginatedState.items.length + 1 + (paginatedState.hasMore ? 1 : 0),
      ),
    );
  }
}
