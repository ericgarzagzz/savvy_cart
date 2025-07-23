import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/widgets.dart';
import 'dart:math' as math;

// Confetti animation constants
const Duration _kConfettiDelay = Duration(milliseconds: 500);

class ShopListManager extends ConsumerStatefulWidget {
  final int shopListId;

  const ShopListManager({super.key, required this.shopListId});

  @override
  ConsumerState<ShopListManager> createState() => _ShopListManagerState();
}

class _ShopListManagerState extends ConsumerState<ShopListManager>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTopFab = false;
  late AnimationController _confettiController;
  bool _hasShownConfetti = false;
  bool _wasIncompleteLastCheck = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _confettiController.dispose();
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

  void _triggerConfetti() {
    if (!_hasShownConfetti) {
      _hasShownConfetti = true;
      _confettiController.forward().then((_) {
        _confettiController.reset();
      });
    }
  }

  void _checkIfAllItemsComplete(List toBuyItems, List inCartItems) {
    final isCurrentlyComplete = toBuyItems.isEmpty && inCartItems.isNotEmpty;

    if (toBuyItems.isNotEmpty) {
      // List is incomplete - update our tracking
      _hasShownConfetti = false;
      _wasIncompleteLastCheck = true;
    } else if (isCurrentlyComplete &&
        _wasIncompleteLastCheck &&
        !_hasShownConfetti) {
      // List just became complete (transition from incomplete to complete)
      _wasIncompleteLastCheck = false;
      Future.delayed(_kConfettiDelay, () {
        _triggerConfetti();
      });
    }
  }

  Widget _buildConfetti() {
    return AnimatedBuilder(
      animation: _confettiController,
      builder: (context, child) {
        return Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: ConfettiPainter(_confettiController.value),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final getShopListByIdAsync = ref.watch(
      getShopListByIdProvider(widget.shopListId),
    );

    // Watch both lists to check completion status
    final toBuyItemsAsync = ref.watch(
      shopListItemsProvider((widget.shopListId, false)),
    );
    final inCartItemsAsync = ref.watch(
      shopListItemsProvider((widget.shopListId, true)),
    );

    // Check if all items are complete
    toBuyItemsAsync.whenData((toBuyItems) {
      inCartItemsAsync.whenData((inCartItems) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkIfAllItemsComplete(toBuyItems, inCartItems);
        });
      });
    });

    return getShopListByIdAsync.when(
      loading: () => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stackTrace) =>
          GenericErrorScaffold(errorMessage: err.toString()),
      data: (shopList) => Stack(
        children: [
          Scaffold(
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
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
                              const Icon(
                                Icons.smart_toy,
                                color: Colors.white,
                                size: 18,
                              ),
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
                  ),
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
                  sliver: ShopListItemListview(
                    shopListId: widget.shopListId,
                    checkedItems: false,
                    onAddItem: () {
                      context.go("./add-item");
                    },
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
                  sliver: ShopListItemListview(
                    shopListId: widget.shopListId,
                    checkedItems: true,
                  ),
                ),
              ],
            ),
            floatingActionButton: _showScrollToTopFab
                ? FloatingActionButton(
                    onPressed: _scrollToTop,
                    mini: true,
                    tooltip: 'Scroll to top to add items',
                    child: const Icon(Icons.keyboard_double_arrow_up),
                  )
                : null,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
          _buildConfetti(),
        ],
      ),
    );
  }
}

class ConfettiPainter extends CustomPainter {
  final double progress;

  ConfettiPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final paint = Paint()..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent animation

    // Generate confetti pieces
    for (int i = 0; i < 50; i++) {
      final startX = random.nextDouble() * size.width;
      final startY = size.height + 50; // Start further below screen

      // Animation progress affects height and rotation - with staggered start
      final pieceDelay = i * 0.01; // Reduced delay for smoother cascade
      final animationProgress = math.max(
        0,
        (progress - pieceDelay) * 1.2,
      ); // Slightly faster

      // Calculate position - start completely off screen and animate up
      final totalTravelDistance =
          size.height + 100; // Extra distance to ensure smooth start
      final y = startY - (animationProgress * totalTravelDistance);
      final x = startX + (math.sin(animationProgress * math.pi * 2) * 30);

      // Don't draw if animation hasn't started for this piece
      if (animationProgress <= 0) continue;

      // Different colors for confetti
      final colors = [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.yellow,
        Colors.purple,
        Colors.orange,
        Colors.pink,
      ];

      // Calculate opacity with smooth fade-in and fade-out
      double opacity = 1.0;

      // Fade in smoothly when entering from bottom
      if (y > size.height - 100) {
        final fadeInProgress = (size.height - y) / 100;
        opacity = math.min(1.0, fadeInProgress);
      }

      // Fade out in second half of animation
      if (progress > 0.5) {
        final fadeOutProgress = (progress - 0.5) * 2;
        opacity *= (1.0 - fadeOutProgress);
      }

      paint.color = colors[i % colors.length].withValues(
        alpha: math.max(0, opacity),
      );

      // Rotation
      final rotation = animationProgress * math.pi * 4;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      // Draw confetti piece (small rectangle)
      canvas.drawRect(const Rect.fromLTWH(-3, -8, 6, 16), paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
