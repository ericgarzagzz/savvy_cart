class ShopList {
  final int? id;
  final String name;

  ShopList({this.id, required this.name});

  factory ShopList.fromMap(Map<String, dynamic> json) => ShopList(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}