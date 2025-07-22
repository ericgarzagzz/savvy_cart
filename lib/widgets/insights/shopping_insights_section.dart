import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shopping_insights_button.dart';

class ShoppingInsightsSection extends ConsumerWidget {
  const ShoppingInsightsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [const ShoppingInsightsButton(), Container(height: 32)],
    );
  }
}
