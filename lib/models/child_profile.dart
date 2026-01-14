class ChildProfile {
  final String id;
  final String userId;
  final String name;
  final DateTime birthDate;
  final String gender;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChildProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.createdAt,
    required this.updatedAt,
  });

  int get ageInMonths {
    final now = DateTime.now();
    final difference = now.difference(birthDate);
    return (difference.inDays / 30).floor();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'birthDate': birthDate.toIso8601String(),
    'gender': gender,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory ChildProfile.fromJson(Map<String, dynamic> json) => ChildProfile(
    id: json['id'] as String,
    userId: json['userId'] as String,
    name: json['name'] as String,
    birthDate: DateTime.parse(json['birthDate'] as String),
    gender: json['gender'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  ChildProfile copyWith({
    String? id,
    String? userId,
    String? name,
    DateTime? birthDate,
    String? gender,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ChildProfile(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    birthDate: birthDate ?? this.birthDate,
    gender: gender ?? this.gender,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
