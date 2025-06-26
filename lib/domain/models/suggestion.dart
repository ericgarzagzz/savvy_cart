class Suggestion {
  final int? id;
  final String name;

  Suggestion({this.id, required this.name});

  factory Suggestion.fromMap(Map<String, dynamic> json) => Suggestion(
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