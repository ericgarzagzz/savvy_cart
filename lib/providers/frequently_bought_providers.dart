import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/models/models.dart';

final frequentlyBoughtItemsProvider = FutureProvider.family<List<SearchResultItem>, int>((ref, shopListId) async {
  final results = await DatabaseHelper.instance.getFrequentlyBoughtItemsWithStatus(limit: 5, shopListId: shopListId);
  
  return results.map((row) => SearchResultItem(
    name: row['name'] as String,
    isInShopList: (row['is_in_current_list'] as int) == 1,
    shopListItemId: row['shop_list_item_id'] as int?,
  )).toList();
});