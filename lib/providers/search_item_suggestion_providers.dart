import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/models/shop_list_item/SearchResultItem.dart';

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