import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/data/data_manager.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/domain/types/types.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/utils/utils.dart';

// Helper function to convert ShopListWithStatsViewModel to ShopListViewModel
ShopListViewModel _convertToShopListViewModel(
  ShopListWithStatsViewModel stats,
) {
  return ShopListViewModel.fromModel(
    stats.shopList,
    stats.checkedAmount,
    stats.checkedItems,
    stats.totalItems,
  );
}

final shopListCollectionProvider = FutureProvider<List<ShopListViewModel>>((
  ref,
) async {
  final dataManager = DataManager.instance;
  final results = await dataManager.shopLists.getShopListsWithStats();
  return results
      .map(
        (result) => _convertToShopListViewModel(
          ShopListWithStatsViewModel.fromQueryResult(result),
        ),
      )
      .toList();
});

final getShopListByIdProvider = FutureProvider.family<ShopList, int>((
  ref,
  id,
) async {
  final dataManager = DataManager.instance;
  var shopList = await dataManager.shopLists.getById(id);
  if (shopList == null) {
    return Future.error("Shop list not found.");
  }
  return shopList;
});

final shopListItemStatsProvider =
    FutureProvider.family<(Money uncheckedAmount, Money checkedAmount), int>((
      ref,
      shopListId,
    ) async {
      final dataManager = DataManager.instance;
      return await dataManager.shopListItems.calculateItemStats(shopListId);
    });

class PaginatedShopListsState {
  final List<ShopListViewModel> items;
  final bool hasMore;
  final bool isLoading;
  final int currentPage;

  PaginatedShopListsState({
    required this.items,
    required this.hasMore,
    required this.isLoading,
    required this.currentPage,
  });

  PaginatedShopListsState copyWith({
    List<ShopListViewModel>? items,
    bool? hasMore,
    bool? isLoading,
    int? currentPage,
  }) {
    return PaginatedShopListsState(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class PaginatedShopListsNotifier
    extends StateNotifier<PaginatedShopListsState> {
  PaginatedShopListsNotifier()
    : super(
        PaginatedShopListsState(
          items: [],
          hasMore: true,
          isLoading: false,
          currentPage: 0,
        ),
      );

  Future<void> loadInitial() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, currentPage: 0);

    try {
      final dataManager = DataManager.instance;
      final results = await dataManager.shopLists.getShopListsWithStats(
        limit: 3,
        offset: 0,
      );
      final totalCount = await dataManager.shopLists.getCount();

      final collection = results
          .map(
            (result) => _convertToShopListViewModel(
              ShopListWithStatsViewModel.fromQueryResult(result),
            ),
          )
          .toList();

      state = state.copyWith(
        items: collection,
        hasMore: collection.length < totalCount,
        isLoading: false,
        currentPage: 1,
      );
    } on DatabaseOperationException catch (e) {
      if (kDebugMode) {
        print('Database error loading shop lists: ${e.message}');
      }
      state = state.copyWith(isLoading: false);
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error loading shop lists: $e');
      }
      state = state.copyWith(isLoading: false);
      throw Exception('Failed to load shop lists: $e');
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final dataManager = DataManager.instance;
      final results = await dataManager.shopLists.getShopListsWithStats(
        limit: 3,
        offset: state.currentPage * 3,
      );

      final newItems = results
          .map(
            (result) => _convertToShopListViewModel(
              ShopListWithStatsViewModel.fromQueryResult(result),
            ),
          )
          .toList();

      state = state.copyWith(
        items: [...state.items, ...newItems],
        hasMore: newItems.length == 3,
        isLoading: false,
        currentPage: state.currentPage + 1,
      );
    } on DatabaseOperationException catch (e) {
      if (kDebugMode) {
        print('Database error loading more shop lists: ${e.message}');
      }
      state = state.copyWith(isLoading: false);
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error loading more shop lists: $e');
      }
      state = state.copyWith(isLoading: false);
      throw Exception('Failed to load more shop lists: $e');
    }
  }

  void refresh() {
    state = PaginatedShopListsState(
      items: [],
      hasMore: true,
      isLoading: false,
      currentPage: 0,
    );
    loadInitial();
  }
}

final paginatedShopListsProvider =
    StateNotifierProvider<PaginatedShopListsNotifier, PaginatedShopListsState>((
      ref,
    ) {
      return PaginatedShopListsNotifier();
    });

// Search state class for better provider key equality
class ShopListSearchParams {
  final String? query;
  final DateTime? startDate;
  final DateTime? endDate;

  const ShopListSearchParams({this.query, this.startDate, this.endDate});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopListSearchParams &&
          runtimeType == other.runtimeType &&
          query == other.query &&
          startDate == other.startDate &&
          endDate == other.endDate;

  @override
  int get hashCode => query.hashCode ^ startDate.hashCode ^ endDate.hashCode;
}

// Search provider for shop lists
final shopListSearchProvider =
    FutureProvider.family<List<ShopListViewModel>, ShopListSearchParams>((
      ref,
      params,
    ) async {
      final dataManager = DataManager.instance;
      final shopLists = await dataManager.shopLists.search(
        query: params.query?.trim().isEmpty == true
            ? null
            : params.query?.trim(),
        startDate: params.startDate,
        endDate: params.endDate,
      );

      final List<ShopListViewModel> collection = [];
      for (var shopList in shopLists) {
        final checkedAmount = await dataManager.shopListItems
            .calculateCheckedAmount(shopList.id ?? 0);
        final counts = await dataManager.shopListItems.calculateItemCounts(
          shopList.id ?? 0,
        );
        final checkedItemsCount = counts.$1;
        final totalItemsCount = counts.$2;
        collection.add(
          ShopListViewModel.fromModel(
            shopList,
            checkedAmount,
            checkedItemsCount,
            totalItemsCount,
          ),
        );
      }
      return collection;
    });
