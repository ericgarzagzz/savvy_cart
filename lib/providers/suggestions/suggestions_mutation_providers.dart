import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/data/data_manager.dart';
import 'package:savvy_cart/providers/providers.dart';

class SuggestionsMutationNotifier extends StateNotifier<AsyncValue<void>> {
  SuggestionsMutationNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> deleteSuggestionByName(String name) async {
    state = const AsyncValue.loading();

    try {
      final dataManager = DataManager.instance;
      await dataManager.suggestions.removeByName(name);

      ref.invalidate(searchResultsProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final suggestionsMutationProvider =
    StateNotifierProvider<SuggestionsMutationNotifier, AsyncValue<void>>(
      (ref) => SuggestionsMutationNotifier(ref),
    );
