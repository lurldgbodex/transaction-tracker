class Category {
  final int? id;
  final String name;
  final String type;

  Category({this.id, required this.name, required this.type});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'type': type};
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int?,
      name: map['name'] as String,
      type: map['type'] as String,
    );
  }

  Category copyWith({int? id, String? name, String? type}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }
}
