import 'package:savvy_cart/domain/types/types.dart';

class PriceHistoryEntry {
  final Money price;
  final DateTime date;

  const PriceHistoryEntry({required this.price, required this.date});

  factory PriceHistoryEntry.fromMap(Map<String, dynamic> map) {
    return PriceHistoryEntry(
      price: Money(cents: map['unit_price'] as int),
      date: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceHistoryEntry &&
          runtimeType == other.runtimeType &&
          price == other.price &&
          date == other.date;

  @override
  int get hashCode => price.hashCode ^ date.hashCode;

  @override
  String toString() {
    return 'PriceHistoryEntry(price: $price, date: $date)';
  }
}
