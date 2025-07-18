class FrequentlyBoughtItem {
  final String name;
  final int frequency;

  const FrequentlyBoughtItem({required this.name, required this.frequency});

  factory FrequentlyBoughtItem.fromMap(Map<String, dynamic> map) {
    return FrequentlyBoughtItem(
      name: map['name'] as String,
      frequency: map['frequency'] as int,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrequentlyBoughtItem &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          frequency == other.frequency;

  @override
  int get hashCode => name.hashCode ^ frequency.hashCode;

  @override
  String toString() {
    return 'FrequentlyBoughtItem(name: $name, frequency: $frequency)';
  }
}
