import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/models/models.dart';

// Riverpod provider for model filters
final modelFiltersProvider =
    StateNotifierProvider<ModelFiltersNotifier, ModelFilters>((ref) {
      return ModelFiltersNotifier();
    });

class ModelFiltersNotifier extends StateNotifier<ModelFilters> {
  ModelFiltersNotifier() : super(const ModelFilters());

  void updateFilters(ModelFilters filters) {
    state = filters;
  }

  void clearFilters() {
    state = const ModelFilters();
  }
}
