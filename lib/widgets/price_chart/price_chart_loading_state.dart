import 'package:flutter/material.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class PriceChartLoadingState extends StatelessWidget {
  final String itemName;

  const PriceChartLoadingState({super.key, required this.itemName});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PriceChartHeader(itemName: itemName),
        const SizedBox(height: 40),
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ],
    );
  }
}
