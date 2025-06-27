import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/domain/models/shop_list.dart';
import 'package:savvy_cart/domain/types/money.dart';
import 'package:savvy_cart/models/shop_list/shop_list_view_model.dart';

final shopListCollectionProvider = FutureProvider<List<ShopListViewModel>>((ref) async {
  var shopLists = await DatabaseHelper.instance.getShopLists();
  final List<ShopListViewModel> collection = [];
  for (var shopList in shopLists) {
    final checkedAmount = await DatabaseHelper.instance.calculateShopListCheckedAmount(shopList.id ?? 0);
    final counts = await DatabaseHelper.instance.calculateShopListItemCounts(shopList.id ?? 0);
    final checkedItemsCount = counts.$1;
    final totalItemsCount = counts.$2;
    collection.add(ShopListViewModel.fromModel(shopList, checkedAmount, checkedItemsCount, totalItemsCount));
  }
  return collection;
});

final getShopListByIdProvider = FutureProvider.family<ShopList, int>((ref, id) async {
  var shopList = await DatabaseHelper.instance.getShopListById(id);
  if (shopList == null) {
    return Future.error("Shop list not found.");
  }
  return shopList;
});

final shopListItemStatsProvider = FutureProvider.family<(Money uncheckedAmount, Money checkedAmount), int>((ref, shopListId) async {
  return await DatabaseHelper.instance.calculateShopListItemStats(shopListId);
});