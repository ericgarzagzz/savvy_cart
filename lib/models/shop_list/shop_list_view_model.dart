import 'package:savvy_cart/domain/models/shop_list.dart';
import 'package:savvy_cart/domain/types/money.dart';

class ShopListViewModel {
  final int? id;
  final String name;
  final Money checkedAmount;
  final int checkedItems;
  final int totalItems;

  ShopListViewModel({this.id, required this.name, required this.checkedAmount, required this.checkedItems, required this.totalItems});

  factory ShopListViewModel.fromModel(ShopList shopList, Money checkedAmount, int checkedItems, int totalItems) => ShopListViewModel(
    id: shopList.id,
    name: shopList.name,
    checkedAmount: checkedAmount,
    checkedItems: checkedItems,
    totalItems: totalItems,
  );
}