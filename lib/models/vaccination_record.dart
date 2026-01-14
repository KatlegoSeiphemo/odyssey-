class VaccinationRecord {
  final String id;
  final String childId;
  final String vaccinationId;
  final DateTime dateGiven;
  final String? location;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  VaccinationRecord({
    required this.id,
    required this.childId,
    required this.vaccinationId,
    required this.dateGiven,
    this.location,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'childId': childId,
    'vaccinationId': vaccinationId,
    'dateGiven': dateGiven.toIso8601String(),
    'location': location,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory VaccinationRecord.fromJson(Map<String, dynamic> json) => VaccinationRecord(
    id: json['id'] as String,
    childId: json['childId'] as String,
    vaccinationId: json['vaccinationId'] as String,
    dateGiven: DateTime.parse(json['dateGiven'] as String),
    location: json['location'] as String?,
    notes: json['notes'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  VaccinationRecord copyWith({
    String? id,
    String? childId,
    String? vaccinationId,
    DateTime? dateGiven,
    String? location,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => VaccinationRecord(
    id: id ?? this.id,
    childId: childId ?? this.childId,
    vaccinationId: vaccinationId ?? this.vaccinationId,
    dateGiven: dateGiven ?? this.dateGiven,
    location: location ?? this.location,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
