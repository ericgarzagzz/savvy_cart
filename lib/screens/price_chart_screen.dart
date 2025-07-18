import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/providers/providers.dart';

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
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Header
                          Text(
                            widget.itemName,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Price trend for the last 10 purchases',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          Icon(
                            Icons.show_chart,
                            size: 64,
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No price history available',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Purchase this item to start tracking its price trends',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    }

                    if (priceHistory.length == 1) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Header
                          Text(
                            widget.itemName,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Price trend for the last 10 purchases',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          Icon(
                            Icons.shopping_cart,
                            size: 64,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Only one purchase found',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Last purchased for ${priceHistory.first.price.toStringWithLocale()}',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'on ${DateFormat('MMM d, yyyy').format(priceHistory.first.date)}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Purchase this item more times to see price trends',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    }

                    // Reverse to show oldest to newest
                    final reversedHistory = priceHistory.reversed.toList();
                    final spots = reversedHistory.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value.price.cents.toDouble(),
                      );
                    }).toList();

                    final minPrice = reversedHistory
                        .map((e) => e.price.cents)
                        .reduce((a, b) => a < b ? a : b);
                    final maxPrice = reversedHistory
                        .map((e) => e.price.cents)
                        .reduce((a, b) => a > b ? a : b);
                    final priceRange = maxPrice - minPrice;
                    final padding = priceRange * 0.1;

                    return Column(
                      children: [
                        // Header inside the gradient
                        Text(
                          widget.itemName,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Price trend for the last 10 purchases',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        // Chart section
                        Expanded(
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: priceRange > 0
                                    ? priceRange / 4
                                    : 1,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 55,
                                    getTitlesWidget: (value, meta) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8.0,
                                        ),
                                        child: Text(
                                          '\$${(value / 100).toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.8,
                                            ),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 35,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      final index = value.toInt();
                                      if (index >= 0 &&
                                          index < reversedHistory.length) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                          ),
                                          child: Text(
                                            DateFormat('MMM d').format(
                                              reversedHistory[index].date,
                                            ),
                                            style: TextStyle(
                                              color: Colors.white.withValues(
                                                alpha: 0.8,
                                              ),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border(
                                  left: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              minX: 0,
                              maxX: (reversedHistory.length - 1).toDouble(),
                              minY: (minPrice - padding).toDouble(),
                              maxY: (maxPrice + padding).toDouble(),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: spots,
                                  isCurved: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff34d399), // Emerald green
                                      Color(0xff10b981), // Green
                                      Color(0xff059669), // Dark green
                                    ],
                                  ),
                                  barWidth: 4,
                                  isStrokeCapRound: true,
                                  shadow: Shadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) {
                                          return FlDotCirclePainter(
                                            radius: 8,
                                            color: Colors.white,
                                            strokeWidth: 3,
                                            strokeColor: Color(0xff10b981),
                                          );
                                        },
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(
                                          0xff34d399,
                                        ).withValues(alpha: 0.3),
                                        Color(
                                          0xff10b981,
                                        ).withValues(alpha: 0.1),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              lineTouchData: LineTouchData(
                                enabled: true,
                                touchTooltipData: LineTouchTooltipData(
                                  getTooltipColor: (group) =>
                                      Colors.black.withValues(alpha: 0.8),
                                  getTooltipItems: (touchedSpots) {
                                    return touchedSpots.map((spot) {
                                      final index = spot.x.toInt();
                                      if (index >= 0 &&
                                          index < reversedHistory.length) {
                                        final entry = reversedHistory[index];
                                        return LineTooltipItem(
                                          '${entry.price.toStringWithLocale()}\n${DateFormat('MMM d, yyyy').format(entry.date)}',
                                          TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        );
                                      }
                                      return null;
                                    }).toList();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildPriceStats(context, priceHistory),
                      ],
                    );
                  },
                  loading: () => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.itemName,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Price trend for the last 10 purchases',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ],
                  ),
                  error: (error, stackTrace) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.itemName,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Price trend for the last 10 purchases',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Error loading price history',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        error.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
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

  Widget _buildPriceStats(
    BuildContext context,
    List<PriceHistoryEntry> priceHistory,
  ) {
    final prices = priceHistory.map((e) => e.price.cents).toList();
    final avgPrice = prices.reduce((a, b) => a + b) / prices.length;
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            'Average',
            '\$${(avgPrice / 100).toStringAsFixed(2)}',
            Icons.trending_flat,
            Color(0xff3b82f6), // Blue - neutral
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          _buildStatItem(
            context,
            'Lowest',
            '\$${(minPrice / 100).toStringAsFixed(2)}',
            Icons.trending_down,
            Color(0xff10b981), // Green - good/low price
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          _buildStatItem(
            context,
            'Highest',
            '\$${(maxPrice / 100).toStringAsFixed(2)}',
            Icons.trending_up,
            Color(0xfff59e0b), // Amber/Orange - warning/high price
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
