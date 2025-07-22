import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/domain/types/types.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/utils/utils.dart';

final shopListCollectionProvider = FutureProvider<List<ShopListViewModel>>((
  ref,
) async {
  var shopLists = await DatabaseHelper.instance.getShopLists();
  final List<ShopListViewModel> collection = [];
  for (var shopList in shopLists) {
    final checkedAmount = await DatabaseHelper.instance
        .calculateShopListCheckedAmount(shopList.id ?? 0);
    final counts = await DatabaseHelper.instance.calculateShopListItemCounts(
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

final getShopListByIdProvider = FutureProvider.family<ShopList, int>((
  ref,
  id,
) async {
  var shopList = await DatabaseHelper.instance.getShopListById(id);
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
      return await DatabaseHelper.instance.calculateShopListItemStats(
        shopListId,
      );
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
      final shopLists = await DatabaseHelper.instance.getShopListsPaginated(
        limit: 3,
        offset: 0,
      );
      final totalCount = await DatabaseHelper.instance.getShopListsCount();

      final List<ShopListViewModel> collection = [];
      for (var shopList in shopLists) {
        final checkedAmount = await DatabaseHelper.instance
            .calculateShopListCheckedAmount(shopList.id ?? 0);
        final counts = await DatabaseHelper.instance
            .calculateShopListItemCounts(shopList.id ?? 0);
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
      // Re-throw to let UI handle the error appropriately
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
      final shopLists = await DatabaseHelper.instance.getShopListsPaginated(
        limit: 3,
        offset: state.currentPage * 3,
      );

      final List<ShopListViewModel> newItems = [];
      for (var shopList in shopLists) {
        final checkedAmount = await DatabaseHelper.instance
            .calculateShopListCheckedAmount(shopList.id ?? 0);
        final counts = await DatabaseHelper.instance
            .calculateShopListItemCounts(shopList.id ?? 0);
        final checkedItemsCount = counts.$1;
        final totalItemsCount = counts.$2;
        newItems.add(
          ShopListViewModel.fromModel(
            shopList,
            checkedAmount,
            checkedItemsCount,
            totalItemsCount,
          ),
        );
      }

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
      // Re-throw to let UI handle the error appropriately
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
      final shopLists = await DatabaseHelper.instance.searchShopLists(
        query: params.query?.trim().isEmpty == true
            ? null
            : params.query?.trim(),
        startDate: params.startDate,
        endDate: params.endDate,
      );

      final List<ShopListViewModel> collection = [];
      for (var shopList in shopLists) {
        final checkedAmount = await DatabaseHelper.instance
            .calculateShopListCheckedAmount(shopList.id ?? 0);
        final counts = await DatabaseHelper.instance
            .calculateShopListItemCounts(shopList.id ?? 0);
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
