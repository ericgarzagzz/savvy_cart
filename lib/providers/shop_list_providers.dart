import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/models/shop_list/shop_list_view_model.dart';

final shopListCollectionProvider = FutureProvider<List<ShopListViewModel>>((ref) async {
  var shopLists = await DatabaseHelper.instance.getShopLists();
  final List<ShopListViewModel> collection = [];
  for (var shopList in shopLists) {
    final checkedAmount = await DatabaseHelper.instance.calculateShopListCheckedAmount(shopList.id ?? 0);
    collection.add(ShopListViewModel.fromModel(shopList, checkedAmount));
  }
  return collection;
});