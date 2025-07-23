import 'package:savvy_cart/domain/models/models.dart';
import 'package:savvy_cart/domain/types/types.dart';

class ShopListWithStatsViewModel {
  final ShopList shopList;
  final int totalItems;
  final int checkedItems;
  final Money checkedAmount;
  final Money uncheckedAmount;

  ShopListWithStatsViewModel({
    required this.shopList,
    required this.totalItems,
    required this.checkedItems,
    required this.checkedAmount,
    required this.uncheckedAmount,
  });

  int get uncheckedItems => totalItems - checkedItems;
  Money get totalAmount => checkedAmount + uncheckedAmount;
  double get progress => totalItems > 0 ? checkedItems / totalItems : 0.0;

  factory ShopListWithStatsViewModel.fromQueryResult(
    Map<String, dynamic> result,
  ) {
    return ShopListWithStatsViewModel(
      shopList: ShopList(
        id: result['id'] as int?,
        name: result['name'] as String,
        createdAt: result['created_at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                (result['created_at'] as num).round(),
              )
            : null,
        updatedAt: result['updated_at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                (result['updated_at'] as num).round(),
              )
            : null,
      ),
      totalItems: (result['total_items'] as num?)?.round() ?? 0,
      checkedItems: (result['checked_items'] as num?)?.round() ?? 0,
      checkedAmount: Money(
        cents: (result['checked_amount'] as num?)?.round() ?? 0,
      ),
      uncheckedAmount: Money(
        cents: (result['unchecked_amount'] as num?)?.round() ?? 0,
      ),
    );
  }

  factory ShopListWithStatsViewModel.fromShopList(
    ShopList shopList, {
    int totalItems = 0,
    int checkedItems = 0,
    Money? checkedAmount,
    Money? uncheckedAmount,
  }) {
    return ShopListWithStatsViewModel(
      shopList: shopList,
      totalItems: totalItems,
      checkedItems: checkedItems,
      checkedAmount: checkedAmount ?? Money(cents: 0),
      uncheckedAmount: uncheckedAmount ?? Money(cents: 0),
    );
  }
}
