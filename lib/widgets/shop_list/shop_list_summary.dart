import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/domain/types/types.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';

class ShopListSummary extends ConsumerWidget {
  final int shopListId;

  const ShopListSummary({super.key, required this.shopListId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(shopListItemStatsProvider(shopListId));

    return statsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(
        child: Text(
          AppLocalizations.of(context).errorWithDetails(e.toString()),
        ),
      ),
      data: (stats) {
        final (uncheckedAmount, checkedAmount) = stats;
        final totalAmount = uncheckedAmount + checkedAmount;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
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
                Expanded(
                  child: _SummaryStatWidget(
                    label: AppLocalizations.of(context).remaining,
                    amount: uncheckedAmount,
                    color: Colors.white,
                    isSecondary: true,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                Expanded(
                  child: _SummaryStatWidget(
                    label: AppLocalizations.of(context).inCart,
                    amount: checkedAmount,
                    color: Colors.white,
                    isPrimary: true,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                Expanded(
                  child: _SummaryStatWidget(
                    label: AppLocalizations.of(context).total,
                    amount: totalAmount,
                    color: Colors.white,
                    isSecondary: true,
                  ),
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
