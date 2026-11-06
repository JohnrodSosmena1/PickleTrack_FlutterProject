import '../core/constants/app_constants.dart';

class TrainingSession {
  final String id;
  final String roomId;
  final String coachId;
  final String playerId;
  final DateTime sessionDate;
  final String? startTime;
  final String? endTime;
  final AttendanceStatus attendanceStatus;
  final SessionStatus sessionStatus;
  final List<String> drillsCovered;
  final String? notes;
  final String? feedback;
  final DateTime createdAt;
  final DateTime updatedAt;

  TrainingSession({
    required this.id,
    required this.roomId,
    required this.coachId,
    required this.playerId,
    required this.sessionDate,
    this.startTime = '5:00 PM',
    this.endTime = '6:30 PM',
    this.attendanceStatus = AttendanceStatus.present,
    this.sessionStatus = SessionStatus.completed,
    this.drillsCovered = const [],
    this.notes,
    this.feedback,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomId': roomId,
      'coachId': coachId,
      'playerId': playerId,
      'sessionDate': sessionDate.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'attendanceStatus': attendanceStatus.name,
      'sessionStatus': sessionStatus.name,
      'drillsCovered': drillsCovered,
      'notes': notes,
      'feedback': feedback,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TrainingSession.fromMap(Map<String, dynamic> map, String docId) {
    return TrainingSession(
      id: docId,
      roomId: map['roomId'] ?? '',
      coachId: map['coachId'] ?? '',
      playerId: map['playerId'] ?? '',
      sessionDate: map['sessionDate'] != null
          ? DateTime.tryParse(map['sessionDate']) ?? DateTime.now()
          : DateTime.now(),
      startTime: map['startTime'],
      endTime: map['endTime'],
      attendanceStatus: AttendanceStatus.fromString(map['attendanceStatus']),
      sessionStatus: SessionStatus.fromString(map['sessionStatus']),
      drillsCovered: map['drillsCovered'] != null
          ? List<String>.from(map['drillsCovered'])
          : [],
      notes: map['notes'],
      feedback: map['feedback'],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
