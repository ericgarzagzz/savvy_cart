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

  void _handleItemTap(String itemName, bool isInShopList, int? shopListItemId) async {
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

  void _handleFrequentItemTap(String itemName, bool isInShopList, int? shopListItemId) async {
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

  void _handleItemRemove(String itemName, bool isInShopList, int? shopListItemId) async {
    final title = isInShopList && shopListItemId != null ?
        "Remove Item and Suggestion?" :
        "Remove Suggestion?";
    final description = isInShopList && shopListItemId != null ?
        "This will remove \"${itemName}\" from your current shopping list and also from your suggestions." :
        "This will remove \"${itemName}\" from your suggestions. It will not affect your current shopping list.";

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

      final suggestionsMutationNotifier = ref.read(suggestionsMutationProvider.notifier);
      await suggestionsMutationNotifier.deleteSuggestionByName(itemName);

      if (isInShopList && shopListItemId != null) {
        final shopListItemMutationNotifier = ref.read(shopListItemMutationProvider.notifier);
        await shopListItemMutationNotifier.deleteItem(shopListItemId);
      }
    }
  }

  Widget _buildSearchResults(List<dynamic> results) {
    final hasSearchQuery = _searchQuery.isNotEmpty;
    final resultCount = results.length;

    if (resultCount == 0) {
      return SliverToBoxAdapter(
        child: Column(
          children: [
            if (hasSearchQuery) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Search Results (0)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Icon(
                Icons.search_off,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                'No items found',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try a different search term or add "${_searchQuery}" as a new item',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => _handleSubmit(),
                icon: const Icon(Icons.add),
                label: Text('Add "${_searchQuery}"'),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            // Header
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                hasSearchQuery ? 'Search Results ($resultCount)' : 'All Items',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          final item = results[index - 1];
          final addState = ref.watch(shopListItemMutationProvider);
          final isLoading = addState.isLoading;

          return ListTile(
            key: Key('${item.name}_${item.isInShopList}'),
            leading: Checkbox(
              value: item.isInShopList,
              onChanged: isLoading ? null : (_) => _handleItemTap(
                item.name,
                item.isInShopList,
                item.shopListItemId,
              ),
            ),
            title: Text(item.name),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
              onPressed: () => _handleItemRemove(
                item.name,
                item.isInShopList,
                item.shopListItemId,
              ),
            ),
            onTap: isLoading ? null : () => _handleItemTap(
              item.name,
              item.isInShopList,
              item.shopListItemId,
            ),
            enabled: !isLoading,
          );
        },
        childCount: resultCount + 1, // +1 for header
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final getShopListByIdAsync = ref.watch(getShopListByIdProvider(widget.shopListId));
    final searchResultsAsync = ref.watch(searchResultsProvider((widget.shopListId, _searchQuery)));

    return getShopListByIdAsync.when(
      loading: () => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stackTrace) => GenericErrorScaffold(errorMessage: err.toString()),
      data: (shopList) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text("Add item to ${shopList.name}"),
              pinned: true,
              expandedHeight: 150,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 120, 16, 16),
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                      hintText: 'Search or add new item...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _handleSubmit(),
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
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (err, stackTrace) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error loading results: ${err.toString()}',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
              data: (results) => _buildSearchResults(results),
            ),
          ],
        ),
      ),
    );
  }
}
