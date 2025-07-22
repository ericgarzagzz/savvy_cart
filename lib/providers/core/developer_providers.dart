import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/data/data_manager.dart';
import 'package:savvy_cart/providers/providers.dart';

class DeveloperNotifier extends StateNotifier<AsyncValue<void>> {
  DeveloperNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> generateMockData() async {
    state = const AsyncValue.loading();

    try {
      final dataManager = DataManager.instance;
      await dataManager.mockData.generateMockData();

      // Invalidate all providers to refresh UI with new data
      ShopListInvalidationHelper.invalidateAll(ref);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> purgeDatabase() async {
    state = const AsyncValue.loading();

    try {
      final dataManager = DataManager.instance;
      await dataManager.purgeDatabase();

      // Invalidate all providers to refresh UI after database deletion
      ShopListInvalidationHelper.invalidateAll(ref);

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
