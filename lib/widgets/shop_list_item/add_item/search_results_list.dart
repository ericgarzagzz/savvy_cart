import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class SearchResultsList extends ConsumerWidget {
  final List<dynamic> results;
  final String searchQuery;
  final Function(String, bool, int?) onItemTap;
  final Function(String, bool, int?) onItemRemove;

  const SearchResultsList({
    super.key,
    required this.results,
    required this.searchQuery,
    required this.onItemTap,
    required this.onItemRemove,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasSearchQuery = searchQuery.isNotEmpty;
    final resultCount = results.length;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            // Header
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                hasSearchQuery
                    ? 'Search Results ($resultCount)'
                    : 'All Items ($resultCount)',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            );
          }

          final item = results[index - 1];
          final addState = ref.watch(shopListItemMutationProvider);
          final isLoading = addState.isLoading;

          return SearchResultItemTile(
            item: item,
            isLoading: isLoading,
            onTap: () =>
                onItemTap(item.name, item.isInShopList, item.shopListItemId),
            onRemove: () =>
                onItemRemove(item.name, item.isInShopList, item.shopListItemId),
          );
        },
        childCount: resultCount + 1, // +1 for header
      ),
    );
  }
}
