import 'package:flutter/material.dart';

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
          'Price trend for the last 10 purchases',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
