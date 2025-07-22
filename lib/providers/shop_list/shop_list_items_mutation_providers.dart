import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:decimal/decimal.dart';
import 'package:savvy_cart/data/data_manager.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/domain/types/types.dart';
import 'package:savvy_cart/providers/providers.dart';

class ShopListItemMutationNotifier extends StateNotifier<AsyncValue<void>> {
  ShopListItemMutationNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> addItem(int shopListId, String itemName) async {
    state = const AsyncValue.loading();

    try {
      final dataManager = DataManager.instance;

      // Check if item already exists in shop list
      final exists = await dataManager.shopListItems.exists(
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

      // Get the last recorded price for this item
      final lastRecordedPrice = await dataManager.shopListItems
          .getLastRecordedPrice(itemName);

      // Use transaction for atomic multi-step operation
      await dataManager.transaction((tx) async {
        // Add to suggestions if it doesn't exist
        await tx.suggestions.add(itemName);

        // Add to shop list
        final newItem = ShopListItem(
          shopListId: shopListId,
          name: itemName.toLowerCase(),
          quantity: Decimal.one,
          unitPrice: lastRecordedPrice ?? Money(cents: 0),
          checked: false,
        );

        await tx.shopListItems.add(newItem);
      });

      // Refresh all related providers
      ShopListInvalidationHelper.invalidateShopListItemRelated(ref);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateItem(ShopListItem updatedItem) async {
    state = const AsyncValue.loading();

    try {
      final dataManager = DataManager.instance;
      await dataManager.shopListItems.update(updatedItem);

      ShopListInvalidationHelper.invalidateShopListItemRelated(ref);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> setChecked(int shopListItemId, bool checked) async {
    state = const AsyncValue.loading();

    try {
      final dataManager = DataManager.instance;
      await dataManager.shopListItems.setChecked(shopListItemId, checked);

      ShopListInvalidationHelper.invalidateShopListItemRelated(ref);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteItem(int shopListItemId) async {
    state = const AsyncValue.loading();

    try {
      final dataManager = DataManager.instance;
      await dataManager.shopListItems.remove(shopListItemId);

      ShopListInvalidationHelper.invalidateShopListItemRelated(ref);

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
