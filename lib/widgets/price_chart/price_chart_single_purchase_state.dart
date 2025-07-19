import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class PriceChartSinglePurchaseState extends StatelessWidget {
  final String itemName;
  final List<PriceHistoryEntry> priceHistory;

  const PriceChartSinglePurchaseState({
    super.key,
    required this.itemName,
    required this.priceHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PriceChartHeader(itemName: itemName),
        const SizedBox(height: 40),
        Icon(
          Icons.shopping_cart,
          size: 64,
          color: Colors.white.withValues(alpha: 0.8),
        ),
        const SizedBox(height: 16),
        Text(
          'Only one purchase found',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Last purchased for ${priceHistory.first.price.toStringWithLocale()}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'on ${DateFormat('MMM d, yyyy').format(priceHistory.first.date)}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Purchase this item more times to see price trends',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
