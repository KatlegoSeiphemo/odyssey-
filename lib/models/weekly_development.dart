class WeeklyDevelopment {
  final String id;
  final int week;
  final String title;
  final String description;
  final String sizeComparison;
  final String motherChanges;
  final List<String> tips;
  final DateTime createdAt;
  final DateTime updatedAt;

  WeeklyDevelopment({
    required this.id,
    required this.week,
    required this.title,
    required this.description,
    required this.sizeComparison,
    required this.motherChanges,
    required this.tips,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'week': week,
    'title': title,
    'description': description,
    'sizeComparison': sizeComparison,
    'motherChanges': motherChanges,
    'tips': tips,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory WeeklyDevelopment.fromJson(Map<String, dynamic> json) => WeeklyDevelopment(
    id: json['id'] as String,
    week: json['week'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    sizeComparison: json['sizeComparison'] as String,
    motherChanges: json['motherChanges'] as String,
    tips: List<String>.from(json['tips'] as List),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  WeeklyDevelopment copyWith({
    String? id,
    int? week,
    String? title,
    String? description,
    String? sizeComparison,
    String? motherChanges,
    List<String>? tips,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WeeklyDevelopment(
    id: id ?? this.id,
    week: week ?? this.week,
    title: title ?? this.title,
    description: description ?? this.description,
    sizeComparison: sizeComparison ?? this.sizeComparison,
    motherChanges: motherChanges ?? this.motherChanges,
    tips: tips ?? this.tips,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
