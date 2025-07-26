import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/providers/providers.dart';

class PriceSearchScreen extends ConsumerStatefulWidget {
  const PriceSearchScreen({super.key});

  @override
  ConsumerState<PriceSearchScreen> createState() => _PriceSearchScreenState();
}

class _PriceSearchScreenState extends ConsumerState<PriceSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_searchQuery != _searchController.text) {
        setState(() {
          _searchQuery = _searchController.text;
        });
      }
    });

    // Auto-focus the search field when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _searchItem() {
    final itemName = _searchController.text.trim();
    if (itemName.isNotEmpty) {
      context.go('./price-chart/${Uri.encodeComponent(itemName)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchResultsAsync = ref.watch(
      priceSearchResultsProvider(_searchQuery),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.searchItemPrice),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/insights'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.searchForItemViewHistory,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterItemName,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: _searchItem,
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _searchItem(),
            ),
            const SizedBox(height: 24),
            Text(
              _searchQuery.isEmpty
                  ? AppLocalizations.of(context)!.orChooseFromPreviousItems
                  : AppLocalizations.of(context)!.searchResults,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (_searchQuery.isNotEmpty && _searchQuery.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: FilledButton.icon(
                  onPressed: _searchItem,
                  icon: const Icon(Icons.add_chart),
                  label: Text(
                    AppLocalizations.of(context)!.viewChartFor(_searchQuery),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: searchResultsAsync.when(
                data: (suggestions) {
                  if (suggestions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _searchQuery.isEmpty
                                ? Icons.inventory_2_outlined
                                : Icons.search_off,
                            size: 64,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty
                                ? AppLocalizations.of(context)!.noItemsFound
                                : AppLocalizations.of(
                                    context,
                                  )!.noMatchingItemsFound,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchQuery.isEmpty
                                ? AppLocalizations.of(
                                    context,
                                  )!.addItemsToSeeHere
                                : AppLocalizations.of(
                                    context,
                                  )!.tryDifferentSearchTerm(_searchQuery),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = suggestions[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                            child: Icon(
                              Icons.shopping_basket,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            suggestion.name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Icon(
                            Icons.trending_up,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          onTap: () => context.go(
                            './price-chart/${Uri.encodeComponent(suggestion.name)}',
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.errorLoadingSuggestions,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
