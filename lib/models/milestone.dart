class Milestone {
  final String id;
  final String type;
  final int weekOrMonth;
  final String title;
  final String description;
  final String? icon;
  final DateTime createdAt;
  final DateTime updatedAt;

  Milestone({
    required this.id,
    required this.type,
    required this.weekOrMonth,
    required this.title,
    required this.description,
    this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'weekOrMonth': weekOrMonth,
    'title': title,
    'description': description,
    'icon': icon,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Milestone.fromJson(Map<String, dynamic> json) => Milestone(
    id: json['id'] as String,
    type: json['type'] as String,
    weekOrMonth: json['weekOrMonth'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    icon: json['icon'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  Milestone copyWith({
    String? id,
    String? type,
    int? weekOrMonth,
    String? title,
    String? description,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Milestone(
    id: id ?? this.id,
    type: type ?? this.type,
    weekOrMonth: weekOrMonth ?? this.weekOrMonth,
    title: title ?? this.title,
    description: description ?? this.description,
    icon: icon ?? this.icon,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
