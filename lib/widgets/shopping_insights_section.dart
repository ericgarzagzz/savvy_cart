import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvy_cart/providers/providers.dart';
import 'package:savvy_cart/widgets/shopping_insights_button.dart';

class ShoppingInsightsSection extends ConsumerWidget {
  const ShoppingInsightsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopListCollectionAsync = ref.watch(shopListCollectionProvider);

    return shopListCollectionAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (shopLists) {
        if (shopLists.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [const ShoppingInsightsButton(), Container(height: 32)],
        );
      },
    );
  }
}
