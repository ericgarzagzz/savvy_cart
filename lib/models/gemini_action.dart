enum GeminiOperation {
  add,
  remove,
  update,
  check,
  uncheck,
}

class GeminiAction {
  final GeminiOperation operation;
  final String item;
  final int? id;
  final double? quantity;
  final double? unitPrice;

  GeminiAction({
    required this.operation,
    required this.item,
    this.id,
    this.quantity,
    this.unitPrice,
  });

  factory GeminiAction.fromJson(Map<String, dynamic> json) {
    return GeminiAction(
      operation: GeminiOperation.values.firstWhere(
        (e) => e.toString().split('.').last == json['operation'],
      ),
      item: json['item'],
      id: json['id'],
      quantity: (json['quantity'] as num?)?.toDouble(),
      unitPrice: (json['unit_price'] as num?)?.toDouble(),
    );
  }
}
