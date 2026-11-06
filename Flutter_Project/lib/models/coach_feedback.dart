class CoachFeedback {
  final String id;
  final String roomId;
  final String coachId;
  final String coachName;
  final String playerId;
  final String? sessionId;
  final String? assignmentId;
  final String message;
  final DateTime createdAt;

  CoachFeedback({
    required this.id,
    required this.roomId,
    required this.coachId,
    required this.coachName,
    required this.playerId,
    this.sessionId,
    this.assignmentId,
    required this.message,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomId': roomId,
      'coachId': coachId,
      'coachName': coachName,
      'playerId': playerId,
      'sessionId': sessionId,
      'assignmentId': assignmentId,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CoachFeedback.fromMap(Map<String, dynamic> map, String docId) {
    return CoachFeedback(
      id: docId,
      roomId: map['roomId'] ?? '',
      coachId: map['coachId'] ?? '',
      coachName: map['coachName'] ?? 'Coach',
      playerId: map['playerId'] ?? '',
      sessionId: map['sessionId'],
      assignmentId: map['assignmentId'],
      message: map['message'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
