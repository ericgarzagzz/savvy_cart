import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class PriceChartView extends StatelessWidget {
  final String itemName;
  final List<PriceHistoryEntry> priceHistory;

  const PriceChartView({
    super.key,
    required this.itemName,
    required this.priceHistory,
  });

  @override
  Widget build(BuildContext context) {
    final reversedHistory = priceHistory.reversed.toList();
    final spots = reversedHistory.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.price.cents.toDouble());
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
        PriceChartHeader(itemName: itemName),
        const SizedBox(height: 30),
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: priceRange > 0 ? priceRange / 4 : 1,
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
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          '\$${(value / 100).toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
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
                      if (index >= 0 && index < reversedHistory.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat(
                              'MMM d',
                            ).format(reversedHistory[index].date),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
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
                      Color(0xff34d399),
                      Color(0xff10b981),
                      Color(0xff059669),
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
                    getDotPainter: (spot, percent, barData, index) {
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
                        Color(0xff34d399).withValues(alpha: 0.3),
                        Color(0xff10b981).withValues(alpha: 0.1),
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
                      if (index >= 0 && index < reversedHistory.length) {
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
        PriceChartStatistics(priceHistory: priceHistory),
      ],
    );
  }
}
