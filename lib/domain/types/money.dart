import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

class Money {
  int cents;

  Money({required this.cents});

  factory Money.fromJson(int value) => Money(cents: value);
  int toJson() => cents;

  @override
  String toString() => (cents / 100).toStringAsFixed(2);

  String toStringWithLocale() =>
      NumberFormat.simpleCurrency().format(cents / 100);

  Money operator +(Money other) => Money(cents: cents + other.cents);
  Money operator *(Decimal other) {
    final currentCentsDecimal = Decimal.fromInt(cents);
    final resultInFractionalCents = currentCentsDecimal * other;
    final roundedDecimalCents = resultInFractionalCents.round();
    final roundedCentsInt = roundedDecimalCents.toBigInt().toInt();
    return Money(cents: roundedCentsInt);
  }
}
