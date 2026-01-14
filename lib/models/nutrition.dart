class Nutrition {
  final String id;
  final int trimester;
  final String category;
  final String name;
  final String description;
  final String benefits;
  final DateTime createdAt;
  final DateTime updatedAt;

  Nutrition({
    required this.id,
    required this.trimester,
    required this.category,
    required this.name,
    required this.description,
    required this.benefits,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'trimester': trimester,
    'category': category,
    'name': name,
    'description': description,
    'benefits': benefits,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Nutrition.fromJson(Map<String, dynamic> json) => Nutrition(
    id: json['id'] as String,
    trimester: json['trimester'] as int,
    category: json['category'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    benefits: json['benefits'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  Nutrition copyWith({
    String? id,
    int? trimester,
    String? category,
    String? name,
    String? description,
    String? benefits,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Nutrition(
    id: id ?? this.id,
    trimester: trimester ?? this.trimester,
    category: category ?? this.category,
    name: name ?? this.name,
    description: description ?? this.description,
    benefits: benefits ?? this.benefits,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
