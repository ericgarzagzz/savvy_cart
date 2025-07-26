import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/widgets.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';

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
          child: Text(AppLocalizations.of(context).errorLoadingShopListItems),
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
                          ? AppLocalizations.of(context).noItemsInCartYet
                          : AppLocalizations.of(context).readyToStartShopping,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      checkedItems
                          ? AppLocalizations.of(
                              context,
                            ).itemsYouCheckOffWillAppearHere
                          : AppLocalizations.of(
                              context,
                            ).tapPlusButtonToAddFirstItem,
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
                title = AppLocalizations.of(context).noItemsInCartYet;
                subtitle = AppLocalizations.of(
                  context,
                ).itemsYouCheckOffWillAppearHere;
                icon = Icons.shopping_cart_outlined;
              } else {
                if (hasItemsInOppositeSection) {
                  title = AppLocalizations.of(context).needMoreItems;
                  subtitle = onAddItem != null
                      ? AppLocalizations.of(
                          context,
                        ).tapButtonBelowToAddMoreItems
                      : AppLocalizations.of(context).addItemsYouStillNeedToBuy;
                  icon = Icons.playlist_add;
                } else {
                  title = AppLocalizations.of(context).readyToStartShopping;
                  subtitle = onAddItem != null
                      ? AppLocalizations.of(
                          context,
                        ).tapButtonBelowToAddFirstItem
                      : AppLocalizations.of(context).addFirstItemToGetStarted;
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
                          label: Text(AppLocalizations.of(context).addItem),
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
