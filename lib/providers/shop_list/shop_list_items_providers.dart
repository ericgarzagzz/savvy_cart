import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/data/data_manager.dart';
import 'package:savvy_cart/domain/models/models.dart';

final shopListItemsProvider =
    FutureProvider.family<List<ShopListItem>, (int, bool)>((ref, params) async {
      final shopListId = params.$1;
      final checkedItems = params.$2;

      final dataManager = DataManager.instance;
      final items = await dataManager.shopListItems.getByShopListIdAndStatus(
        shopListId,
        checkedItems,
      );

      // Sort items alphabetically by name (case-insensitive)
      items.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

      return items;
    });

final getShopListItemsProvider = FutureProvider.family<List<ShopListItem>, int>(
  (ref, shopListId) async {
    final dataManager = DataManager.instance;
    final items = await dataManager.shopListItems.getByShopListId(shopListId);

    // Sort items alphabetically by name (case-insensitive)
    items.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return items;
  },
);

final getShopListItemByIdProvider = FutureProvider.family<ShopListItem?, int>((
  ref,
  itemId,
) async {
  final dataManager = DataManager.instance;
  return await dataManager.shopListItems.getById(itemId);
});
