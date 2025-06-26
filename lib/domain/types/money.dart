import 'package:intl/intl.dart';

class Money {
  int cents;

  Money({required this.cents});

  factory Money.fromJson(int value) => Money(cents: value);
  int toJson() => cents;

  @override
  String toString() => (cents / 100).toStringAsFixed(2);

  String toStringWithLocale() => NumberFormat.currency().format(cents / 100);

  Money operator +(Money other) => Money(cents: cents + other.cents);
}