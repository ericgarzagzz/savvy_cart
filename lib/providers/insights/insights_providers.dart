import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/domain/models/models.dart';

final weeklyInsightsProvider = FutureProvider<WeeklyInsights>((ref) async {
  final db = DatabaseHelper.instance;

  final listsCreated = await db.getShopListsCountLastWeek();
  final totalAmount = await db.getTotalAmountLastWeek();

  return WeeklyInsights(listsCreated: listsCreated, totalAmount: totalAmount);
});

final monthlyFrequentlyBoughtItemsProvider =
    FutureProvider<List<FrequentlyBoughtItem>>((ref) async {
      final db = DatabaseHelper.instance;
      return await db.getFrequentlyBoughtItemsLastMonth();
    });

final itemPriceHistoryProvider =
    FutureProvider.family<List<PriceHistoryEntry>, String>((
      ref,
      itemName,
    ) async {
      final db = DatabaseHelper.instance;
      return await db.getItemPriceHistory(itemName, limit: 10);
    });

final suggestionsProvider = FutureProvider<List<Suggestion>>((ref) async {
  final db = DatabaseHelper.instance;
  return await db.getSuggestions();
});

final priceSearchResultsProvider =
    FutureProvider.family<List<Suggestion>, String>((ref, query) async {
      final db = DatabaseHelper.instance;
      final suggestions = await db.getSuggestions();

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
