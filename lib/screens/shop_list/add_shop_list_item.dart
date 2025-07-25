import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class AddShopListItem extends ConsumerStatefulWidget {
  final int shopListId;

  const AddShopListItem({super.key, required this.shopListId});

  @override
  ConsumerState<AddShopListItem> createState() => _AddShopListItemState();
}

class _AddShopListItemState extends ConsumerState<AddShopListItem> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      if (_searchQuery != _textController.text) {
        setState(() {
          _searchQuery = _textController.text;
        });
      }
    });

    // Auto-focus after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final query = _textController.text.trim();
    if (query.isEmpty) return;

    final addNotifier = ref.read(shopListItemMutationProvider.notifier);
    await addNotifier.addItem(widget.shopListId, query);

    final addState = ref.read(shopListItemMutationProvider);
    addState.whenOrNull(
      error: (error, _) {
        if (mounted) {
          GenericAlertDialog.show(
            context,
            title: 'Error',
            message: error.toString(),
            confirmText: 'OK',
          );
        }
      },
      data: (_) {
        _textController.clear();
        setState(() {
          _searchQuery = '';
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _focusNode.requestFocus();
        });
      },
    );
  }

  void _handleItemTap(
    String itemName,
    bool isInShopList,
    int? shopListItemId,
  ) async {
    if (isInShopList && shopListItemId != null) {
      // Remove item
      final addNotifier = ref.read(shopListItemMutationProvider.notifier);
      await addNotifier.deleteItem(shopListItemId);

      final addState = ref.read(shopListItemMutationProvider);
      addState.whenOrNull(
        error: (error, _) {
          if (mounted) {
            GenericAlertDialog.show(
              context,
              title: 'Error',
              message: 'Failed to remove item: ${error.toString()}',
              confirmText: 'OK',
            );
          }
        },
      );
    } else {
      // Add item
      final addNotifier = ref.read(shopListItemMutationProvider.notifier);
      await addNotifier.addItem(widget.shopListId, itemName);

      final addState = ref.read(shopListItemMutationProvider);
      addState.whenOrNull(
        error: (error, _) {
          if (mounted) {
            GenericAlertDialog.show(
              context,
              title: 'Error',
              message: error.toString(),
              confirmText: 'OK',
            );
          }
        },
      );
    }
  }

  void _handleFrequentItemTap(
    String itemName,
    bool isInShopList,
    int? shopListItemId,
  ) async {
    final mutationNotifier = ref.read(shopListItemMutationProvider.notifier);

    if (isInShopList && shopListItemId != null) {
      // Remove item from shopping list
      await mutationNotifier.deleteItem(shopListItemId);
    } else {
      // Add item to shopping list
      await mutationNotifier.addItem(widget.shopListId, itemName);
    }

    final mutationState = ref.read(shopListItemMutationProvider);
    mutationState.whenOrNull(
      error: (error, _) {
        if (mounted) {
          GenericAlertDialog.show(
            context,
            title: 'Error',
            message: error.toString(),
            confirmText: 'OK',
          );
        }
      },
    );
  }

  void _handleItemRemove(
    String itemName,
    bool isInShopList,
    int? shopListItemId,
  ) async {
    final title = isInShopList && shopListItemId != null
        ? "Remove Item and Suggestion?"
        : "Remove Suggestion?";
    final description = isInShopList && shopListItemId != null
        ? "This will remove \"$itemName\" from your current shopping list and also from your suggestions."
        : "This will remove \"$itemName\" from your suggestions. It will not affect your current shopping list.";

    if (mounted) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Remove'),
            ),
          ],
        ),
      );
      if (confirm != true) return;

      final suggestionsMutationNotifier = ref.read(
        suggestionsMutationProvider.notifier,
      );
      await suggestionsMutationNotifier.deleteSuggestionByName(itemName);

      if (isInShopList && shopListItemId != null) {
        final shopListItemMutationNotifier = ref.read(
          shopListItemMutationProvider.notifier,
        );
        await shopListItemMutationNotifier.deleteItem(shopListItemId);
      }
    }
  }

  Widget _buildSearchResults(List<dynamic> results) {
    final hasSearchQuery = _searchQuery.isNotEmpty;
    final resultCount = results.length;

    if (resultCount == 0 && hasSearchQuery) {
      return SliverToBoxAdapter(
        child: SearchResultsEmptyState(
          searchQuery: _searchQuery,
          onAddItem: _handleSubmit,
        ),
      );
    }

    return SearchResultsList(
      results: results,
      searchQuery: _searchQuery,
      onItemTap: _handleItemTap,
      onItemRemove: _handleItemRemove,
    );
  }

  @override
  Widget build(BuildContext context) {
    final getShopListByIdAsync = ref.watch(
      getShopListByIdProvider(widget.shopListId),
    );
    final searchResultsAsync = ref.watch(
      searchResultsProvider((widget.shopListId, _searchQuery)),
    );
    final itemCountAsync = ref.watch(
      shopListItemCountProvider(widget.shopListId),
    );

    return getShopListByIdAsync.when(
      loading: () => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stackTrace) =>
          GenericErrorScaffold(errorMessage: err.toString()),
      data: (shopList) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Add Item",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    shopList.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              actions: [
                itemCountAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (itemCount) => Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      "$itemCount selected",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
              pinned: true,
              expandedHeight: 150,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 120, 16, 16),
                  child: AddItemSearchField(
                    controller: _textController,
                    focusNode: _focusNode,
                    onSubmitted: _handleSubmit,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FrequentlyBoughtSection(
                shopListId: widget.shopListId,
                onItemTap: _handleFrequentItemTap,
              ),
            ),
            searchResultsAsync.when(
              loading: () => const SearchLoadingState(),
              error: (err, stackTrace) =>
                  SearchErrorState(error: err.toString()),
              data: (results) => _buildSearchResults(results),
            ),
          ],
        ),
      ),
    );
  }
}
