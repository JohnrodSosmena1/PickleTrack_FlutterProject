import '../core/utils/validators.dart';

class DrillResult {
  final String id;
  final String roomId;
  final String sessionId;
  final String drillId;
  final String drillName;
  final String? assignmentId;
  final int attempts;
  final int successfulAttempts;
  final double accuracy; // percentage e.g. 70.0
  final String? notes;
  final String recordedBy;
  final DateTime createdAt;

  DrillResult({
    required this.id,
    required this.roomId,
    required this.sessionId,
    required this.drillId,
    required this.drillName,
    this.assignmentId,
    required this.attempts,
    required this.successfulAttempts,
    double? accuracy,
    this.notes,
    required this.recordedBy,
    DateTime? createdAt,
  })  : accuracy = accuracy ?? Validators.calculateAccuracy(successfulAttempts, attempts),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomId': roomId,
      'sessionId': sessionId,
      'drillId': drillId,
      'drillName': drillName,
      'assignmentId': assignmentId,
      'attempts': attempts,
      'successfulAttempts': successfulAttempts,
      'accuracy': accuracy,
      'notes': notes,
      'recordedBy': recordedBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory DrillResult.fromMap(Map<String, dynamic> map, String docId) {
    final att = (map['attempts'] as num?)?.toInt() ?? 0;
    final succ = (map['successfulAttempts'] as num?)?.toInt() ?? 0;
    final acc = (map['accuracy'] as num?)?.toDouble() ?? Validators.calculateAccuracy(succ, att);

    return DrillResult(
      id: docId,
      roomId: map['roomId'] ?? '',
      sessionId: map['sessionId'] ?? '',
      drillId: map['drillId'] ?? '',
      drillName: map['drillName'] ?? 'Drill',
      assignmentId: map['assignmentId'],
      attempts: att,
      successfulAttempts: succ,
      accuracy: acc,
      notes: map['notes'],
      recordedBy: map['recordedBy'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
