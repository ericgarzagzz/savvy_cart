class ShopList {
  final int? id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ShopList({this.id, required this.name, this.createdAt, this.updatedAt});

  factory ShopList.fromMap(Map<String, dynamic> json) => ShopList(
    id: json['id'],
    name: json['name'],
    createdAt: json['created_at'] != null && json['created_at'] != 0
        ? DateTime.fromMillisecondsSinceEpoch(json['created_at'])
        : null,
    updatedAt: json['updated_at'] != null && json['updated_at'] != 0
        ? DateTime.fromMillisecondsSinceEpoch(json['updated_at'])
        : null,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt?.millisecondsSinceEpoch ?? 0,
      'updated_at': updatedAt?.millisecondsSinceEpoch ?? 0,
    };
  }
}
