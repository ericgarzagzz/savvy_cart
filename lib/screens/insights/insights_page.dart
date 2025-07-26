import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:savvy_cart/l10n/app_localizations.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class InsightsPage extends ConsumerWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyInsightsAsync = ref.watch(weeklyInsightsProvider);
    final shopListCollectionAsync = ref.watch(shopListCollectionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.shoppingInsights),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: shopListCollectionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            InsightsErrorState(error: error, stackTrace: stackTrace),
        data: (shopLists) {
          if (shopLists.isEmpty) {
            return const InsightsEmptyState();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.weeklyOverview,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                weeklyInsightsAsync.when(
                  data: (insights) => Row(
                    children: [
                      Expanded(
                        child: WeeklyInsightsCard(
                          title: AppLocalizations.of(context)!.listsCreated,
                          value: insights.listsCreated.toString(),
                          icon: Icons.shopping_cart,
                          iconColor: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: WeeklyInsightsCard(
                          title: AppLocalizations.of(context)!.totalSpent,
                          value: insights.totalAmount.toStringWithLocale(),
                          icon: Icons.attach_money,
                          iconColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  loading: () => const Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                      ),
                    ],
                  ),
                  error: (error, stackTrace) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.errorLoadingInsights,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            error.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const FrequentlyBoughtItemsList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
