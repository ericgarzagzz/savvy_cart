import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class ShopListManager extends ConsumerStatefulWidget {
  final int shopListId;

  const ShopListManager({super.key, required this.shopListId});

  @override
  ConsumerState<ShopListManager> createState() => _ShopListManagerState();
}

class _ShopListManagerState extends ConsumerState<ShopListManager> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTopFab = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final isScrolledAway = _scrollController.offset > 100;
      if (_showScrollToTopFab != isScrolledAway) {
        setState(() {
          _showScrollToTopFab = isScrolledAway;
        });
      }
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final getShopListByIdAsync = ref.watch(getShopListByIdProvider(widget.shopListId));

    return getShopListByIdAsync.when(
      loading: () => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stackTrace) => GenericErrorScaffold(errorMessage: err.toString()),
      data: (shopList) => Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              title: Text(shopList.name),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () {
                      context.go('./chat');
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.smart_toy, color: Colors.white, size: 18),
                          const SizedBox(width: 4),
                          const Text(
                            'AI',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: ShopListSummary(shopListId: widget.shopListId),
              )
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: ShopListSectionHeader(
                  icon: Icons.shopping_cart_outlined,
                  title: 'To Buy',
                  shopListId: widget.shopListId,
                  checkedItems: false,
                  onAddItem: () {
                    context.go("./add-item");
                  },
                ),
              ),
            ),
            SliverSafeArea(
              top: false,
              sliver: SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                sliver: ShopListItemListview(
                  shopListId: widget.shopListId,
                  checkedItems: false,
                  onAddItem: () {
                    context.go("./add-item");
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: ShopListSectionHeader(
                  icon: Icons.check,
                  title: 'In Cart',
                  shopListId: widget.shopListId,
                  checkedItems: true,
                ),
              ),
            ),
            SliverSafeArea(
              top: false,
              sliver: SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                sliver: ShopListItemListview(
                  shopListId: widget.shopListId,
                  checkedItems: true,
                ),
              ),
            )
          ],
        ),
        floatingActionButton: _showScrollToTopFab ? FloatingActionButton(
          onPressed: _scrollToTop,
          mini: true,
          tooltip: 'Scroll to top to add items',
          child: const Icon(Icons.keyboard_double_arrow_up),
        ) : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      )
    );
  }
}
