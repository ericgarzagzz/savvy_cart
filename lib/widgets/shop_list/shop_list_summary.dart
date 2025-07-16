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

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xff2e5010),
                Color(0xff6b7f6f),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SummaryStatWidget(
                  label: "Remaining", 
                  amount: uncheckedAmount,
                  color: Colors.white,
                  isSecondary: true,
                ),
                _SummaryStatWidget(
                  label: "In Cart", 
                  amount: checkedAmount,
                  color: Colors.white,
                  isPrimary: true,
                ),
                _SummaryStatWidget(
                  label: "Total", 
                  amount: totalAmount,
                  color: Colors.white,
                  isSecondary: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SummaryStatWidget extends StatelessWidget {
  final String label;
  final Money amount;
  final Color color;
  final bool isPrimary;
  final bool isSecondary;

  const _SummaryStatWidget({
    required this.label,
    required this.amount,
    required this.color,
    this.isPrimary = false,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        Text(
          amount.toStringWithLocale(), 
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
        Text(
          label, 
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: isPrimary ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
