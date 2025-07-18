import 'package:decimal/decimal.dart';
import 'package:savvy_cart/domain/types/types.dart';

class ShopListItem {
  final int? id;
  final int shopListId;
  final String name;
  final Decimal quantity;
  final Money unitPrice;
  final bool checked;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? checkedAt;

  ShopListItem({
    this.id,
    required this.shopListId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    this.checked = false,
    this.createdAt,
    this.updatedAt,
    this.checkedAt,
  });

  factory ShopListItem.fromMap(Map<String, dynamic> json) => ShopListItem(
    id: json['id'],
    shopListId: json['shop_list_id'],
    name: json['name'],
    quantity: Decimal.fromJson(json['quantity']),
    unitPrice: Money.fromJson(json['unit_price']),
    checked: json['checked'].toString() == "1",
    createdAt: json['created_at'] != null && json['created_at'] != 0
        ? DateTime.fromMillisecondsSinceEpoch(json['created_at'])
        : null,
    updatedAt: json['updated_at'] != null && json['updated_at'] != 0
        ? DateTime.fromMillisecondsSinceEpoch(json['updated_at'])
        : null,
    checkedAt: json['checked_at'] != null && json['checked_at'] != 0
        ? DateTime.fromMillisecondsSinceEpoch(json['checked_at'])
        : null,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shop_list_id': shopListId,
      'name': name,
      'quantity': quantity.toJson(),
      'unit_price': unitPrice.toJson(),
      'checked': checked ? 1 : 0,
      'created_at': createdAt?.millisecondsSinceEpoch ?? 0,
      'updated_at': updatedAt?.millisecondsSinceEpoch ?? 0,
      'checked_at': checkedAt?.millisecondsSinceEpoch,
    };
  }

  ShopListItem copyWith({
    String? name,
    Decimal? quantity,
    Money? unitPrice,
    bool? checked,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? checkedAt,
  }) {
    return ShopListItem(
      id: id,
      shopListId: shopListId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      checked: checked ?? this.checked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      checkedAt: checkedAt ?? this.checkedAt,
    );
  }
}
