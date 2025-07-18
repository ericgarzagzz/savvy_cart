import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class ShopListItemListview extends ConsumerWidget {
  final int shopListId;
  final bool checkedItems;
  final VoidCallback? onAddItem;

  const ShopListItemListview({
    super.key,
    required this.shopListId,
    required this.checkedItems,
    this.onAddItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopListItemAsync = ref.watch(
      shopListItemsProvider((shopListId, checkedItems)),
    );
    final oppositeItemsAsync = ref.watch(
      shopListItemsProvider((shopListId, !checkedItems)),
    );

    return shopListItemAsync.when(
      loading: () =>
          SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
      error: (_, __) => SliverToBoxAdapter(
        child: Center(
          child: Text("Could not load shop list's items due to an error."),
        ),
      ),
      data: (data) {
        if (data.isEmpty) {
          return oppositeItemsAsync.when(
            loading: () => SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        checkedItems
                            ? Icons.shopping_cart_outlined
                            : Icons.add_shopping_cart,
                        size: 32,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      checkedItems
                          ? "No items in cart yet"
                          : "Ready to start shopping?",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      checkedItems
                          ? "Items you check off will appear here"
                          : "Tap the + button below to add your first item",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            data: (oppositeData) {
              final hasItemsInOppositeSection = oppositeData.isNotEmpty;

              String title;
              String subtitle;
              IconData icon;

              if (checkedItems) {
                title = "No items in cart yet";
                subtitle = "Items you check off will appear here";
                icon = Icons.shopping_cart_outlined;
              } else {
                if (hasItemsInOppositeSection) {
                  title = "Need more items?";
                  subtitle = onAddItem != null
                      ? "Tap the button below to add more items"
                      : "Add items you still need to buy";
                  icon = Icons.playlist_add;
                } else {
                  title = "Ready to start shopping?";
                  subtitle = onAddItem != null
                      ? "Tap the button below to add your first item"
                      : "Add your first item to get started";
                  icon = Icons.add_shopping_cart;
                }
              }

              return SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          size: 32,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (!checkedItems && onAddItem != null) ...[
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: onAddItem,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Item'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            minimumSize: const Size(0, 48),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return ShopListItemListtile(shopListItem: data[index]);
          }, childCount: data.length),
        );
      },
    );
  }
}
