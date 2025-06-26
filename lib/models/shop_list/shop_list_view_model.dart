import 'package:savvy_cart/domain/models/shop_list.dart';
import 'package:savvy_cart/domain/types/money.dart';

class ShopListViewModel {
  final int? id;
  final String name;
  final Money checkedAmount;

  ShopListViewModel({this.id, required this.name, required this.checkedAmount});

  factory ShopListViewModel.fromModel(ShopList shopList, Money checkedAmount) => ShopListViewModel(
    id: shopList.id,
    name: shopList.name,
    checkedAmount: checkedAmount
  );
}