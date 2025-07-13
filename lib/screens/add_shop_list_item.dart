import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:savvy_cart/providers/suggestions_mutation_providers.dart';
import 'package:savvy_cart/widgets/generic_alert_dialog.dart';
import 'package:savvy_cart/widgets/generic_error_scaffold.dart';
import 'package:savvy_cart/providers/providers.dart';

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

  @override
  Widget build(BuildContext context) {
    final getShopListByIdAsync = ref.watch(getShopListByIdProvider(widget.shopListId));
    final searchResultsAsync = ref.watch(searchResultsProvider((widget.shopListId, _searchQuery)));
    final addState = ref.watch(shopListItemMutationProvider);

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
              data: (results) => SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final item = results[index];
                    final isLoading = addState.isLoading;

                    return ListTile(
                      key: Key(shopList.name),
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
                        icon: Icon(Icons.delete),
                        color: Theme.of(context).colorScheme.error,
                        onPressed: () => _handleItemRemove(
                          item.name,
                          item.isInShopList,
                          item.shopListItemId
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
                  childCount: results.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
