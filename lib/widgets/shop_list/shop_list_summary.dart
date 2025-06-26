import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/domain/types/money.dart';

class ShopListSummary extends ConsumerWidget {
  const ShopListSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 32,
      children: [
        _SummaryStatWidget(label: "Unchecked", amount: Money(cents: 0)),
        _SummaryStatWidget(label: "Checked", amount: Money(cents: 0)),
        _SummaryStatWidget(label: "Total", amount: Money(cents: 0)),
      ],
    );
  }
}

class _SummaryStatWidget extends StatelessWidget {
  final String label;
  final Money amount;

  const _SummaryStatWidget({super.key, required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(amount.toStringWithLocale(), style: Theme.of(context).textTheme.bodyLarge)
      ],
    );
  }
}
