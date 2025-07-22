import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:savvy_cart/data/data_manager.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/domain/models/models.dart';

final weeklyInsightsProvider = FutureProvider<WeeklyInsights>((ref) async {
  final dataManager = DataManager.instance;

  final listsCreated = await dataManager.shopLists.getCountLastWeek();
  final totalAmount = await dataManager.analytics.getTotalAmountLastWeek();

  return WeeklyInsights(listsCreated: listsCreated, totalAmount: totalAmount);
});

final monthlyFrequentlyBoughtItemsProvider =
    FutureProvider<List<FrequentlyBoughtItem>>((ref) async {
      final dataManager = DataManager.instance;
      return await dataManager.analytics.getFrequentlyBoughtItemsLastMonth();
    });

final itemPriceHistoryProvider =
    FutureProvider.family<List<PriceHistoryEntry>, String>((
      ref,
      itemName,
    ) async {
      final dataManager = DataManager.instance;
      return await dataManager.analytics.getItemPriceHistory(
        itemName,
        limit: 10,
      );
    });

final suggestionsProvider = FutureProvider<List<Suggestion>>((ref) async {
  final dataManager = DataManager.instance;
  return await dataManager.suggestions.getAll();
});

final priceSearchResultsProvider =
    FutureProvider.family<List<Suggestion>, String>((ref, query) async {
      final dataManager = DataManager.instance;
      final suggestions = await dataManager.suggestions.getAll();

      // If query is empty, return all suggestions sorted alphabetically
      if (query.trim().isEmpty) {
        return suggestions..sort((a, b) => a.name.compareTo(b.name));
      }

      // Use fuzzy search to find matching suggestions
      final fuse = Fuzzy(
        suggestions.map((suggestion) => suggestion.name).toList(),
        options: FuzzyOptions(threshold: 0.4),
      );

      final results = fuse.search(query);
      final matchedNames = results.map((r) => r.item).toSet();

      return suggestions
          .where((suggestion) => matchedNames.contains(suggestion.name))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    });
