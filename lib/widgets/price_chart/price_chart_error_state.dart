import 'package:flutter/material.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class PriceChartErrorState extends StatelessWidget {
  final String itemName;
  final Object error;

  const PriceChartErrorState({
    super.key,
    required this.itemName,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PriceChartHeader(itemName: itemName),
        const SizedBox(height: 40),
        Icon(
          Icons.error_outline,
          size: 48,
          color: Colors.white.withValues(alpha: 0.8),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.errorLoadingPriceHistory,
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
    );
  }
}
