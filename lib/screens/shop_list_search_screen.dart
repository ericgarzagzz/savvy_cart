import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:savvy_cart/database_helper.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class ShopListSearchScreen extends ConsumerStatefulWidget {
  const ShopListSearchScreen({super.key});

  @override
  ConsumerState<ShopListSearchScreen> createState() => _ShopListSearchScreenState();
}

class _ShopListSearchScreenState extends ConsumerState<ShopListSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  List<ShopListViewModel> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    // Set default date range: current date - 3 months to current date
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month - 3, now.day);
    _endDate = now;
    _performSearch();
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      final shopLists = await DatabaseHelper.instance.searchShopLists(
        query: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
      );

      final List<ShopListViewModel> collection = [];
      for (var shopList in shopLists) {
        final checkedAmount = await DatabaseHelper.instance.calculateShopListCheckedAmount(shopList.id ?? 0);
        final counts = await DatabaseHelper.instance.calculateShopListItemCounts(shopList.id ?? 0);
        final checkedItemsCount = counts.$1;
        final totalItemsCount = counts.$2;
        collection.add(ShopListViewModel.fromModel(shopList, checkedAmount, checkedItemsCount, totalItemsCount));
      }

      setState(() {
        _searchResults = collection;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
    }
  }

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
      _performSearch();
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
      _performSearch();
    }
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _startDate = null;
      _endDate = null;
    });
    _performSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Lists'),
        actions: [
          if (_searchController.text.isNotEmpty || _startDate != null || _endDate != null)
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: _clearFilters,
            ),
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
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by list name...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch();
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    _performSearch();
                  },
                ),
                SizedBox(height: 16),
                // Date Filters
                Text(
                  'Filter by Date Range',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _selectStartDate,
                        icon: Icon(Icons.date_range),
                        label: Text(_startDate != null 
                            ? DateFormat('MMM d, yyyy').format(_startDate!)
                            : 'Start Date'),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _selectEndDate,
                        icon: Icon(Icons.date_range),
                        label: Text(_endDate != null 
                            ? DateFormat('MMM d, yyyy').format(_endDate!)
                            : 'End Date'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Results Section
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _hasSearched && _searchResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No lists found',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Try adjusting your search terms or date filters',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return ShopListListTile(
                            shopList: _searchResults[index],
                            onTap: () => context.go("./manage/${_searchResults[index].id}"),
                          );
                        },
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