class Vaccination {
  final String id;
  final String name;
  final int ageInMonths;
  final String description;
  final bool isRequired;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vaccination({
    required this.id,
    required this.name,
    required this.ageInMonths,
    required this.description,
    this.isRequired = true,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'ageInMonths': ageInMonths,
    'description': description,
    'isRequired': isRequired,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Vaccination.fromJson(Map<String, dynamic> json) => Vaccination(
    id: json['id'] as String,
    name: json['name'] as String,
    ageInMonths: json['ageInMonths'] as int,
    description: json['description'] as String,
    isRequired: json['isRequired'] as bool? ?? true,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  Vaccination copyWith({
    String? id,
    String? name,
    int? ageInMonths,
    String? description,
    bool? isRequired,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Vaccination(
    id: id ?? this.id,
    name: name ?? this.name,
    ageInMonths: ageInMonths ?? this.ageInMonths,
    description: description ?? this.description,
    isRequired: isRequired ?? this.isRequired,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
