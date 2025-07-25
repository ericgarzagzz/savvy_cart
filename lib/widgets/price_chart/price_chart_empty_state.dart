import 'package:flutter/material.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class PriceChartEmptyState extends StatelessWidget {
  final String itemName;

  const PriceChartEmptyState({super.key, required this.itemName});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PriceChartHeader(itemName: itemName),
        const SizedBox(height: 40),
        Icon(
          Icons.show_chart,
          size: 64,
          color: Colors.white.withValues(alpha: 0.4),
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context).noPriceHistoryAvailable,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context).purchaseItemToTrackPrice,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
