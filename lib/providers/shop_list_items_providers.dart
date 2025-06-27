import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/domain/models/shop_list_item.dart';

final shopListItemsProvider = FutureProvider.family<List<ShopListItem>, (int, bool)>((ref, params) async {
  final shopListId = params.$1;
  final checkedItems = params.$2;

  return await DatabaseHelper.instance.getShopListItemsByStatus(shopListId, checkedItems);
});