import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/domain/models/shop_list_item.dart';
import 'package:savvy_cart/domain/types/money.dart';
import 'package:savvy_cart/models/shop_list_item/SearchResultItem.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/providers/shop_list_items_providers.dart';

final searchResultsProvider = FutureProvider.family<List<SearchResultItem>, (int, String)>((ref, params) async {
  final shopListId = params.$1;
  final query = params.$2.trim();

  // Get suggestions and existing shop list items
  final suggestions = await DatabaseHelper.instance.getSuggestions();
  final shopListItems = await DatabaseHelper.instance.getShopListItems(shopListId);

  // Create a combined list of all possible items
  final allItems = <String, SearchResultItem>{};

  // Add suggestions
  for (final suggestion in suggestions) {
    allItems[suggestion.name.toLowerCase()] = SearchResultItem(
      name: suggestion.name,
      isInShopList: false,
    );
  }

  // Add existing shop list items (override suggestions if they exist)
  for (final item in shopListItems) {
    allItems[item.name.toLowerCase()] = SearchResultItem(
      name: item.name,
      isInShopList: true,
      shopListItemId: item.id,
    );
  }

  final allItemsList = allItems.values.toList();

  // If query is empty, return all items
  if (query.isEmpty) {
    return allItemsList..sort((a, b) => a.name.compareTo(b.name));
  }

  // Use fuzzy search
  final fuse = Fuzzy(
    allItemsList.map((item) => item.name).toList(),
    options: FuzzyOptions(threshold: 0.4),
  );

  final results = fuse.search(query);
  final matchedNames = results.map((r) => r.item).toSet();

  return allItemsList
      .where((item) => matchedNames.contains(item.name))
      .toList()
    ..sort((a, b) => a.name.compareTo(b.name));
});

class AddShopListItemNotifier extends StateNotifier<AsyncValue<void>> {
  AddShopListItemNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> addItem(int shopListId, String itemName) async {
    state = const AsyncValue.loading();

    try {
      // Check if item already exists in shop list
      final exists = await DatabaseHelper.instance.shopListItemExists(shopListId, itemName);
      if (exists) {
        state = AsyncValue.error('Item already on the list', StackTrace.current);
        return;
      }

      // Add to suggestions if it doesn't exist
      await DatabaseHelper.instance.addSuggestion(itemName);

      // Add to shop list
      final newItem = ShopListItem(
        shopListId: shopListId,
        name: itemName.toLowerCase(),
        quantity: Decimal.one,
        unitPrice: Money(cents: 0),
        checked: false,
      );

      await DatabaseHelper.instance.addShopListItem(newItem);

      // Refresh the search results
      ref.invalidate(searchResultsProvider);
      ref.invalidate(shopListItemsProvider);
      ref.invalidate(shopListCollectionProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> removeItem(int shopListItemId) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseHelper.instance.removeShopListItem(shopListItemId);

      // Refresh the search results
      ref.invalidate(searchResultsProvider);
      ref.invalidate(shopListItemsProvider);
      ref.invalidate(shopListCollectionProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final addShopListItemProvider = StateNotifierProvider<AddShopListItemNotifier, AsyncValue<void>>((ref) {
  return AddShopListItemNotifier(ref);
});