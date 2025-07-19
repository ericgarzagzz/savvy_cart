import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class PriceChartScreen extends ConsumerStatefulWidget {
  final String itemName;

  const PriceChartScreen({super.key, required this.itemName});

  @override
  ConsumerState<PriceChartScreen> createState() => _PriceChartScreenState();
}

class _PriceChartScreenState extends ConsumerState<PriceChartScreen> {
  @override
  void initState() {
    super.initState();
    // Force landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Hide status bar for full immersion
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    // Restore portrait orientation and system UI
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final priceHistoryAsync = ref.watch(
      itemPriceHistoryProvider(widget.itemName),
    );

    return Material(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(
                0xff2e5010,
              ), // Darker primary green (matching create_shop_list)
              Color(
                0xff6b7f6f,
              ), // Lighter blue-gray green (matching create_shop_list)
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main content
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: priceHistoryAsync.when(
                  data: (priceHistory) {
                    if (priceHistory.isEmpty) {
                      return PriceChartEmptyState(itemName: widget.itemName);
                    }

                    if (priceHistory.length == 1) {
                      return PriceChartSinglePurchaseState(
                        itemName: widget.itemName,
                        priceHistory: priceHistory,
                      );
                    }

                    return PriceChartView(
                      itemName: widget.itemName,
                      priceHistory: priceHistory,
                    );
                  },
                  loading: () =>
                      PriceChartLoadingState(itemName: widget.itemName),
                  error: (error, stackTrace) => PriceChartErrorState(
                    itemName: widget.itemName,
                    error: error,
                  ),
                ),
              ),
              // Back button positioned at top-left
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () => context.pop(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
