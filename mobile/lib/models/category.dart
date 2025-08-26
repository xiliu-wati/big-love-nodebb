class Category {
  final int id;
  final String name;
  final String description;
  final String color;
  final int postCount;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.postCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      color: json['color'] ?? '#6B46C1',
      postCount: json['postCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color,
      'postCount': postCount,
    };
  }

  Category copyWith({
    int? id,
    String? name,
    String? description,
    String? color,
    int? postCount,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      postCount: postCount ?? this.postCount,
    );
  }
}
