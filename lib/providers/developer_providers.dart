import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/providers/providers.dart';

class DeveloperNotifier extends StateNotifier<AsyncValue<void>> {
  DeveloperNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> generateMockData() async {
    state = const AsyncValue.loading();

    try {
      await DatabaseHelper.instance.generateMockData();

      // Invalidate all providers to refresh UI with new data
      ref.invalidate(shopListCollectionProvider);
      ref.read(paginatedShopListsProvider.notifier).refresh();

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> purgeDatabase() async {
    state = const AsyncValue.loading();

    try {
      await DatabaseHelper.instance.purgeDatabase();

      // Invalidate all providers to refresh UI after database deletion
      ref.invalidate(shopListCollectionProvider);
      ref.read(paginatedShopListsProvider.notifier).refresh();

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final developerProvider =
    StateNotifierProvider<DeveloperNotifier, AsyncValue<void>>(
      (ref) => DeveloperNotifier(ref),
    );
