import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:savvy_cart/models/models.dart';
import 'package:savvy_cart/widgets/widgets.dart';

class ShopListListTile extends StatelessWidget {
  final ShopListViewModel shopList;

  const ShopListListTile({super.key, required this.shopList});

  bool get isCompleted => shopList.totalItems > 0 && shopList.checkedItems == shopList.totalItems;
  
  double get progressPercentage => shopList.totalItems == 0 ? 0 : shopList.checkedItems / shopList.totalItems;
  
  String get progressText => "${shopList.checkedItems} of ${shopList.totalItems} items";
  
  String get buttonText => isCompleted ? "View List" : "Continue Shopping";
  
  IconData get buttonIcon => isCompleted ? Icons.visibility : Icons.shopping_cart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => context.go("/manage/${shopList.id}"),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              shopList.name,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isCompleted) ...[
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 16,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "complete",
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: theme.colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          shopList.checkedAmount.toStringWithLocale(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => DeleteShopListDialog(shopList: shopList),
                        barrierDismissible: false,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        progressText,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        "${(progressPercentage * 100).round()}%",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progressPercentage,
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => context.go("/manage/${shopList.id}"),
                  icon: Icon(buttonIcon),
                  label: Text(buttonText),
                  style: FilledButton.styleFrom(
                    backgroundColor: isCompleted 
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.primary,
                    foregroundColor: isCompleted 
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
