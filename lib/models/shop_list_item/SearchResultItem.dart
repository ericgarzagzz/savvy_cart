class SearchResultItem {
  final String name;
  final bool isInShopList;
  final int? shopListItemId; // null if it's just a suggestion

  const SearchResultItem({
    required this.name,
    required this.isInShopList,
    this.shopListItemId,
  });

  SearchResultItem copyWith({
    String? name,
    bool? isInShopList,
    int? shopListItemId,
  }) {
    return SearchResultItem(
      name: name ?? this.name,
      isInShopList: isInShopList ?? this.isInShopList,
      shopListItemId: shopListItemId ?? this.shopListItemId,
    );
  }
}