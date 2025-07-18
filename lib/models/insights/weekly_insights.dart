import 'package:savvy_cart/domain/types/types.dart';

class WeeklyInsights {
  final int listsCreated;
  final Money totalAmount;

  const WeeklyInsights({
    required this.listsCreated,
    required this.totalAmount,
  });

  factory WeeklyInsights.empty() {
    return WeeklyInsights(
      listsCreated: 0,
      totalAmount: Money(cents: 0),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyInsights &&
          runtimeType == other.runtimeType &&
          listsCreated == other.listsCreated &&
          totalAmount == other.totalAmount;

  @override
  int get hashCode => listsCreated.hashCode ^ totalAmount.hashCode;

  @override
  String toString() {
    return 'WeeklyInsights(listsCreated: $listsCreated, totalAmount: $totalAmount)';
  }
}