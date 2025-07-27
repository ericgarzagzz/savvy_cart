import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/widgets.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';

class ShopListSearchScreen extends ConsumerStatefulWidget {
  const ShopListSearchScreen({super.key});

  @override
  ConsumerState<ShopListSearchScreen> createState() =>
      _ShopListSearchScreenState();
}

class _ShopListSearchScreenState extends ConsumerState<ShopListSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Set default date range: current date - 3 months to current date
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month - 3, now.day);
    _endDate = now;
  }

  ShopListSearchParams get _searchParams => ShopListSearchParams(
    query: _searchQuery,
    startDate: _startDate,
    endDate: _endDate,
  );

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now().subtract(Duration(days: 90)),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _startDate = null;
      _endDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchResultsAsync = ref.watch(shopListSearchProvider(_searchParams));
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).searchLists),
        actions: [
          if (_searchController.text.isNotEmpty ||
              _startDate != null ||
              _endDate != null)
            IconButton(icon: Icon(Icons.clear), onPressed: _clearFilters),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 2,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(
                                context,
                              ).searchByListName,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 4,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Date Filters
                Text(
                  AppLocalizations.of(context).filterByDateRange,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _selectStartDate,
                        icon: Icon(Icons.date_range),
                        label: Text(
                          _startDate != null
                              ? DateFormat('MMM d, yyyy').format(_startDate!)
                              : AppLocalizations.of(context).startDate,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _selectEndDate,
                        icon: Icon(Icons.date_range),
                        label: Text(
                          _endDate != null
                              ? DateFormat('MMM d, yyyy').format(_endDate!)
                              : AppLocalizations.of(context).endDate,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Results Section
          Expanded(
            child: searchResultsAsync.when(
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context).errorLoadingSearchResults,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context).pleaseTryAgainLater,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              data: (searchResults) => searchResults.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context).noListsFound,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context).tryAdjustingFilters,
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
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        return ShopListListTile(
                          shopList: searchResults[index],
                          onTap: () =>
                              context.go("./manage/${searchResults[index].id}"),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
