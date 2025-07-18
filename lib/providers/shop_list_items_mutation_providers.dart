import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:decimal/decimal.dart';
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/domain/types/types.dart';
import 'package:savvy_cart/providers/providers.dart';

class ShopListItemMutationNotifier extends StateNotifier<AsyncValue<void>> {
  ShopListItemMutationNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> addItem(int shopListId, String itemName) async {
    state = const AsyncValue.loading();

    try {
      // Check if item already exists in shop list
      final exists = await DatabaseHelper.instance.shopListItemExists(
        shopListId,
        itemName,
      );
      if (exists) {
        state = AsyncValue.error(
          'Item already on the list',
          StackTrace.current,
        );
        return;
      }

      // Add to suggestions if it doesn't exist
      await DatabaseHelper.instance.addSuggestion(itemName);

      // Get the last recorded price for this item
      final lastRecordedPrice = await DatabaseHelper.instance
          .getLastRecordedPrice(itemName);

      // Add to shop list
      final newItem = ShopListItem(
        shopListId: shopListId,
        name: itemName.toLowerCase(),
        quantity: Decimal.one,
        unitPrice: lastRecordedPrice ?? Money(cents: 0),
        checked: false,
      );

      await DatabaseHelper.instance.addShopListItem(newItem);

      // Refresh
      ref.invalidate(shopListItemsProvider);
      ref.invalidate(getShopListItemByIdProvider);
      ref.invalidate(shopListCollectionProvider);
      ref.invalidate(searchResultsProvider);
      ref.invalidate(shopListItemStatsProvider);
      ref.invalidate(frequentlyBoughtItemsProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateItem(ShopListItem updatedItem) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseHelper.instance.updateShopListItem(updatedItem);

      ref.invalidate(shopListItemsProvider);
      ref.invalidate(getShopListItemByIdProvider);
      ref.invalidate(shopListCollectionProvider);
      ref.invalidate(searchResultsProvider);
      ref.invalidate(shopListItemStatsProvider);
      ref.invalidate(frequentlyBoughtItemsProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> setChecked(int shopListItemId, bool checked) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseHelper.instance.setShopListItemChecked(
        shopListItemId,
        checked,
      );

      ref.invalidate(shopListItemsProvider);
      ref.invalidate(getShopListItemByIdProvider);
      ref.invalidate(shopListCollectionProvider);
      ref.invalidate(searchResultsProvider);
      ref.invalidate(shopListItemStatsProvider);
      ref.invalidate(frequentlyBoughtItemsProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteItem(int shopListItemId) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseHelper.instance.removeShopListItem(shopListItemId);

      ref.invalidate(shopListItemsProvider);
      ref.invalidate(shopListCollectionProvider);
      ref.invalidate(searchResultsProvider);
      ref.invalidate(shopListItemStatsProvider);
      ref.invalidate(frequentlyBoughtItemsProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final shopListItemMutationProvider =
    StateNotifierProvider<ShopListItemMutationNotifier, AsyncValue<void>>(
      (ref) => ShopListItemMutationNotifier(ref),
    );
