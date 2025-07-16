import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/domain/types/types.dart';
import 'package:savvy_cart/models/models.dart';

final shopListCollectionProvider = FutureProvider<List<ShopListViewModel>>((ref) async {
  var shopLists = await DatabaseHelper.instance.getShopLists();
  final List<ShopListViewModel> collection = [];
  for (var shopList in shopLists) {
    final checkedAmount = await DatabaseHelper.instance.calculateShopListCheckedAmount(shopList.id ?? 0);
    final counts = await DatabaseHelper.instance.calculateShopListItemCounts(shopList.id ?? 0);
    final checkedItemsCount = counts.$1;
    final totalItemsCount = counts.$2;
    collection.add(ShopListViewModel.fromModel(shopList, checkedAmount, checkedItemsCount, totalItemsCount));
  }
  return collection;
});

final getShopListByIdProvider = FutureProvider.family<ShopList, int>((ref, id) async {
  var shopList = await DatabaseHelper.instance.getShopListById(id);
  if (shopList == null) {
    return Future.error("Shop list not found.");
  }
  return shopList;
});

final shopListItemStatsProvider = FutureProvider.family<(Money uncheckedAmount, Money checkedAmount), int>((ref, shopListId) async {
  return await DatabaseHelper.instance.calculateShopListItemStats(shopListId);
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

class PaginatedShopListsNotifier extends StateNotifier<PaginatedShopListsState> {
  PaginatedShopListsNotifier() : super(PaginatedShopListsState(
    items: [],
    hasMore: true,
    isLoading: false,
    currentPage: 0,
  ));

  Future<void> loadInitial() async {
    if (state.isLoading) return;
    
    state = state.copyWith(isLoading: true, currentPage: 0);
    
    try {
      final shopLists = await DatabaseHelper.instance.getShopListsPaginated(limit: 3, offset: 0);
      final totalCount = await DatabaseHelper.instance.getShopListsCount();
      
      final List<ShopListViewModel> collection = [];
      for (var shopList in shopLists) {
        final checkedAmount = await DatabaseHelper.instance.calculateShopListCheckedAmount(shopList.id ?? 0);
        final counts = await DatabaseHelper.instance.calculateShopListItemCounts(shopList.id ?? 0);
        final checkedItemsCount = counts.$1;
        final totalItemsCount = counts.$2;
        collection.add(ShopListViewModel.fromModel(shopList, checkedAmount, checkedItemsCount, totalItemsCount));
      }
      
      state = state.copyWith(
        items: collection,
        hasMore: collection.length < totalCount,
        isLoading: false,
        currentPage: 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    
    state = state.copyWith(isLoading: true);
    
    try {
      final shopLists = await DatabaseHelper.instance.getShopListsPaginated(
        limit: 3, 
        offset: state.currentPage * 3
      );
      
      final List<ShopListViewModel> newItems = [];
      for (var shopList in shopLists) {
        final checkedAmount = await DatabaseHelper.instance.calculateShopListCheckedAmount(shopList.id ?? 0);
        final counts = await DatabaseHelper.instance.calculateShopListItemCounts(shopList.id ?? 0);
        final checkedItemsCount = counts.$1;
        final totalItemsCount = counts.$2;
        newItems.add(ShopListViewModel.fromModel(shopList, checkedAmount, checkedItemsCount, totalItemsCount));
      }
      
      state = state.copyWith(
        items: [...state.items, ...newItems],
        hasMore: newItems.length == 3,
        isLoading: false,
        currentPage: state.currentPage + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
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

final paginatedShopListsProvider = StateNotifierProvider<PaginatedShopListsNotifier, PaginatedShopListsState>((ref) {
  return PaginatedShopListsNotifier();
});