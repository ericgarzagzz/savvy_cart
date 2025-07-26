import 'package:flutter/material.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';

class PriceChartHeader extends StatelessWidget {
  final String itemName;

  const PriceChartHeader({super.key, required this.itemName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          itemName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.priceTrendForLastPurchases,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
