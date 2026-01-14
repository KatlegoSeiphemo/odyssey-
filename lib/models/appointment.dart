class Appointment {
  final String id;
  final String userId;
  final String title;
  final String type;
  final DateTime dateTime;
  final String? location;
  final String? notes;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Appointment({
    required this.id,
    required this.userId,
    required this.title,
    required this.type,
    required this.dateTime,
    this.location,
    this.notes,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'type': type,
    'dateTime': dateTime.toIso8601String(),
    'location': location,
    'notes': notes,
    'isCompleted': isCompleted,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    id: json['id'] as String,
    userId: json['userId'] as String,
    title: json['title'] as String,
    type: json['type'] as String,
    dateTime: DateTime.parse(json['dateTime'] as String),
    location: json['location'] as String?,
    notes: json['notes'] as String?,
    isCompleted: json['isCompleted'] as bool? ?? false,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  Appointment copyWith({
    String? id,
    String? userId,
    String? title,
    String? type,
    DateTime? dateTime,
    String? location,
    String? notes,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Appointment(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    type: type ?? this.type,
    dateTime: dateTime ?? this.dateTime,
    location: location ?? this.location,
    notes: notes ?? this.notes,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
