import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/domain/models/shop_list_item.dart';
import 'package:savvy_cart/providers/add_shop_list_item_providers.dart';
import 'package:savvy_cart/providers/shop_list_providers.dart';

final shopListItemsProvider = FutureProvider.family<List<ShopListItem>, (int, bool)>((ref, params) async {
  final shopListId = params.$1;
  final checkedItems = params.$2;

  return await DatabaseHelper.instance.getShopListItemsByStatus(shopListId, checkedItems);
});

final shopListItemMutationProvider =
StateNotifierProvider<ShopListItemMutationNotifier, AsyncValue<void>>(
        (ref) => ShopListItemMutationNotifier(ref));

class ShopListItemMutationNotifier extends StateNotifier<AsyncValue<void>> {
  ShopListItemMutationNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> updateItem(ShopListItem updatedItem) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseHelper.instance.updateShopListItem(updatedItem);

      ref.invalidate(shopListItemsProvider);
      ref.invalidate(shopListCollectionProvider);
      ref.invalidate(searchResultsProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}