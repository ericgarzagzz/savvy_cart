import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/providers/providers.dart';

/// Centralized helper for managing provider invalidations to avoid duplication
/// and ensure consistency across all mutation operations.
class ShopListInvalidationHelper {
  /// Invalidates providers related to shop lists (collections, pagination, search)
  /// Use when shop lists are added, removed, or when mock data is generated/purged.
  static void invalidateShopListRelated(Ref ref) {
    ref.invalidate(shopListCollectionProvider);
    ref.read(paginatedShopListsProvider.notifier).refresh();
    ref.invalidate(shopListSearchProvider);
  }

  /// Invalidates providers related to shop list items and their associated shop lists.
  /// Use when shop list items are added, updated, deleted, or checked/unchecked.
  /// This also invalidates shop list related providers since item changes affect list statistics.
  static void invalidateShopListItemRelated(Ref ref) {
    // Item-specific providers
    ref.invalidate(shopListItemsProvider);
    ref.invalidate(getShopListItemByIdProvider);
    ref.invalidate(shopListItemStatsProvider);
    ref.invalidate(shopListItemCountProvider);
    ref.invalidate(frequentlyBoughtItemsProvider);
    ref.invalidate(searchResultsProvider);

    // Also invalidate shop list related providers since items affect list stats
    invalidateShopListRelated(ref);
  }

  /// Invalidates all shop list and item related providers.
  /// Use for operations that affect both lists and items comprehensively
  /// (like database purge, comprehensive mock data generation).
  static void invalidateAll(Ref ref) {
    invalidateShopListItemRelated(ref);
    // Note: invalidateShopListItemRelated already calls invalidateShopListRelated
  }
}
