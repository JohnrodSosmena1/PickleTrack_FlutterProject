class DrillAssignment {
  final String id;
  final String roomId;
  final String programId;
  final String drillId;
  final String drillName;
  final String drillCategory;
  final int targetRepetitions;
  final int targetSuccessfulAttempts;
  final double targetAccuracy;
  final int weekNumber;
  final DateTime? scheduledDate;
  final String? instructions;
  final String? coachNotes;
  final String status; // 'assigned', 'in_progress', 'completed'
  final DateTime createdAt;
  final DateTime updatedAt;

  DrillAssignment({
    required this.id,
    required this.roomId,
    required this.programId,
    required this.drillId,
    required this.drillName,
    required this.drillCategory,
    this.targetRepetitions = 20,
    this.targetSuccessfulAttempts = 14,
    this.targetAccuracy = 70.0,
    this.weekNumber = 1,
    this.scheduledDate,
    this.instructions,
    this.coachNotes,
    this.status = 'assigned',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomId': roomId,
      'programId': programId,
      'drillId': drillId,
      'drillName': drillName,
      'drillCategory': drillCategory,
      'targetRepetitions': targetRepetitions,
      'targetSuccessfulAttempts': targetSuccessfulAttempts,
      'targetAccuracy': targetAccuracy,
      'weekNumber': weekNumber,
      'scheduledDate': scheduledDate?.toIso8601String(),
      'instructions': instructions,
      'coachNotes': coachNotes,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory DrillAssignment.fromMap(Map<String, dynamic> map, String docId) {
    return DrillAssignment(
      id: docId,
      roomId: map['roomId'] ?? '',
      programId: map['programId'] ?? '',
      drillId: map['drillId'] ?? '',
      drillName: map['drillName'] ?? 'Drill',
      drillCategory: map['drillCategory'] ?? 'Dinking',
      targetRepetitions: map['targetRepetitions'] ?? 20,
      targetSuccessfulAttempts: map['targetSuccessfulAttempts'] ?? 14,
      targetAccuracy: (map['targetAccuracy'] as num?)?.toDouble() ?? 70.0,
      weekNumber: map['weekNumber'] ?? 1,
      scheduledDate: map['scheduledDate'] != null ? DateTime.tryParse(map['scheduledDate']) : null,
      instructions: map['instructions'],
      coachNotes: map['coachNotes'],
      status: map['status'] ?? 'assigned',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
