import 'package:flutter/material.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/models/models.dart';

class PriceChartStatistics extends StatelessWidget {
  final List<PriceHistoryEntry> priceHistory;

  const PriceChartStatistics({super.key, required this.priceHistory});

  @override
  Widget build(BuildContext context) {
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
            AppLocalizations.of(context)!.average,
            '\$${(avgPrice / 100).toStringAsFixed(2)}',
            Icons.trending_flat,
            Color(0xff3b82f6),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          _buildStatItem(
            context,
            AppLocalizations.of(context)!.lowest,
            '\$${(minPrice / 100).toStringAsFixed(2)}',
            Icons.trending_down,
            Color(0xff10b981),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          _buildStatItem(
            context,
            AppLocalizations.of(context)!.highest,
            '\$${(maxPrice / 100).toStringAsFixed(2)}',
            Icons.trending_up,
            Color(0xfff59e0b),
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
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
