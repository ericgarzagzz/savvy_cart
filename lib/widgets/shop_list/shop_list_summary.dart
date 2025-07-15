import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/domain/types/types.dart';
import 'package:savvy_cart/providers/providers.dart';

class ShopListSummary extends ConsumerWidget {
  final int shopListId;

  const ShopListSummary({super.key, required this.shopListId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(shopListItemStatsProvider(shopListId));

    return statsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (stats) {
        final (uncheckedAmount, checkedAmount) = stats;
        final totalAmount = uncheckedAmount + checkedAmount;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SummaryStatWidget(label: "Unchecked", amount: uncheckedAmount),
            const SizedBox(width: 32),
            _SummaryStatWidget(label: "Checked", amount: checkedAmount),
            const SizedBox(width: 32),
            _SummaryStatWidget(label: "Total", amount: totalAmount),
          ],
        );
      },
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
