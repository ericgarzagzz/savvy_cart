import 'package:decimal/decimal.dart';
import 'package:savvy_cart/domain/types/money.dart';

class ShopListItem {
  final int? id;
  final int shopListId;
  final String name;
  final Decimal quantity;
  final Money unitPrice;

  ShopListItem({this.id, required this.shopListId, required this.name, required this.quantity, required this.unitPrice});

  factory ShopListItem.fromMap(Map<String, dynamic> json) => ShopListItem(
    id: json['id'],
    shopListId: json['shop_list_id'],
    name: json['name'],
    quantity: Decimal.fromJson(json['quantity']),
    unitPrice: Money.fromJson(json['unit_price_cents']),
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shop_list_id': shopListId,
      'name': name,
      'quantity': quantity.toJson(),
      'unit_price': unitPrice.toJson(),
    };
  }
}