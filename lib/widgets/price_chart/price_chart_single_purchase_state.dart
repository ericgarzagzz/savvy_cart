import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';
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
          AppLocalizations.of(context).onlyOnePurchaseFound,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(
            context,
          ).lastPurchasedFor(priceHistory.first.price.toStringWithLocale()),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context).purchasedOn(
            DateFormat('MMM d, yyyy').format(priceHistory.first.date),
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context).purchaseMoreTimesToSeeTrends,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
