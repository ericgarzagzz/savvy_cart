import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/domain/models/shop_list_item.dart';
import 'package:savvy_cart/domain/types/money.dart';

final shopListItemsProvider = FutureProvider.family<List<ShopListItem>, (int, bool)>((ref, params) async {
  final shopListId = params.$1;
  final checkedItems = params.$2;

  List<ShopListItem> collection = [
    ShopListItem(
      shopListId: shopListId,
      name: "plátano",
      quantity: Decimal.parse("0.672"),
      unitPrice: Money(cents: 20 * 100),
      checked: true
    ),
    ShopListItem(
      shopListId: shopListId,
      name: "leche",
      quantity: Decimal.parse("2"),
      unitPrice: Money(cents: 15 * 100),
      checked: true
    ),
    ShopListItem(
      shopListId: shopListId,
      name: "pan",
      quantity: Decimal.parse("1"),
      unitPrice: Money(cents: 25 * 100),
    ),
    ShopListItem(
      shopListId: shopListId,
      name: "huevos",
      quantity: Decimal.parse("12"),
      unitPrice: Money(cents: 30 * 100),
      checked: true
    ),
    ShopListItem(
      shopListId: shopListId,
      name: "manzana",
      quantity: Decimal.parse("1.5"),
      unitPrice: Money(cents: 18 * 100),
    ),
    ShopListItem(
      shopListId: shopListId,
      name: "arroz",
      quantity: Decimal.parse("1"),
      unitPrice: Money(cents: 22 * 100),
    ),
    ShopListItem(
      shopListId: shopListId,
      name: "pollo",
      quantity: Decimal.parse("1"),
      unitPrice: Money(cents: 80 * 100),
    ),
    ShopListItem(
      shopListId: shopListId,
      name: "queso",
      quantity: Decimal.parse("0.5"),
      unitPrice: Money(cents: 40 * 100),
    ),
    ShopListItem(
      shopListId: shopListId,
      name: "tomate",
      quantity: Decimal.parse("1"),
      unitPrice: Money(cents: 12 * 100),
    ),
    ShopListItem(
      shopListId: shopListId,
      name: "cebolla",
      quantity: Decimal.parse("1"),
      unitPrice: Money(cents: 10 * 100),
    ),
  ];

  return collection.where((item) => (checkedItems && item.checked) || (!checkedItems && !item.checked)).toList();
});