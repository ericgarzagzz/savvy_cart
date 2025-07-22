import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/providers/providers.dart';

class ShopListMutationNotifier extends StateNotifier<AsyncValue<void>> {
  ShopListMutationNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> addShopList(String name) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseHelper.instance.addShopList(ShopList(name: name));

      // Invalidate providers to refresh UI
      ShopListInvalidationHelper.invalidateShopListRelated(ref);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> removeShopList(int shopListId) async {
    state = const AsyncValue.loading();

    try {
      await DatabaseHelper.instance.removeShopList(shopListId);

      // Invalidate providers to refresh UI
      ShopListInvalidationHelper.invalidateShopListRelated(ref);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final shopListMutationProvider =
    StateNotifierProvider<ShopListMutationNotifier, AsyncValue<void>>(
      (ref) => ShopListMutationNotifier(ref),
    );
