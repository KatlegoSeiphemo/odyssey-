class PregnancyProfile {
  final String id;
  final String userId;
  final DateTime dueDate;
  final DateTime lastPeriodDate;
  final int currentWeek;
  final DateTime createdAt;
  final DateTime updatedAt;

  PregnancyProfile({
    required this.id,
    required this.userId,
    required this.dueDate,
    required this.lastPeriodDate,
    required this.currentWeek,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'dueDate': dueDate.toIso8601String(),
    'lastPeriodDate': lastPeriodDate.toIso8601String(),
    'currentWeek': currentWeek,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory PregnancyProfile.fromJson(Map<String, dynamic> json) => PregnancyProfile(
    id: json['id'] as String,
    userId: json['userId'] as String,
    dueDate: DateTime.parse(json['dueDate'] as String),
    lastPeriodDate: DateTime.parse(json['lastPeriodDate'] as String),
    currentWeek: json['currentWeek'] as int,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  PregnancyProfile copyWith({
    String? id,
    String? userId,
    DateTime? dueDate,
    DateTime? lastPeriodDate,
    int? currentWeek,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PregnancyProfile(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    dueDate: dueDate ?? this.dueDate,
    lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
    currentWeek: currentWeek ?? this.currentWeek,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
