enum CoachingRequestType {
  coaching,
  session,
}

enum CoachingRequestStatus {
  pending,
  accepted,
  declined,
}

class CoachingRequest {
  final String id;
  final CoachingRequestType requestType;
  final String targetId;
  final String targetTitle;
  final String playerId;
  final String playerName;
  final String playerEmail;
  final String coachId;
  final String coachName;
  final String preferredSchedule;
  final String skillLevel;
  final String? message;
  final CoachingRequestStatus status;
  final DateTime createdAt;
  final DateTime? respondedAt;

  const CoachingRequest({
    required this.id,
    required this.requestType,
    required this.targetId,
    required this.targetTitle,
    required this.playerId,
    required this.playerName,
    required this.playerEmail,
    required this.coachId,
    required this.coachName,
    required this.preferredSchedule,
    required this.skillLevel,
    this.message,
    this.status = CoachingRequestStatus.pending,
    required this.createdAt,
    this.respondedAt,
  });

  bool get isPending => status == CoachingRequestStatus.pending;
  bool get isAccepted => status == CoachingRequestStatus.accepted;
  bool get isDeclined => status == CoachingRequestStatus.declined;

  factory CoachingRequest.fromMap(Map<String, dynamic> map, {String? id}) {
    return CoachingRequest(
      id: id ?? map['id'] ?? '',
      requestType: map['requestType'] == 'session' || map['request_type'] == 'session'
          ? CoachingRequestType.session
          : CoachingRequestType.coaching,
      targetId: map['targetId'] ?? map['target_id'] ?? '',
      targetTitle: map['targetTitle'] ?? map['target_title'] ?? '',
      playerId: map['playerId'] ?? map['player_id'] ?? '',
      playerName: map['playerName'] ?? map['player_name'] ?? 'Player',
      playerEmail: map['playerEmail'] ?? map['player_email'] ?? '',
      coachId: map['coachId'] ?? map['coach_id'] ?? '',
      coachName: map['coachName'] ?? map['coach_name'] ?? 'Coach',
      preferredSchedule: map['preferredSchedule'] ?? map['preferred_schedule'] ?? 'Flexible',
      skillLevel: map['skillLevel'] ?? map['skill_level'] ?? 'Intermediate',
      message: map['message'],
      status: map['status'] == 'accepted'
          ? CoachingRequestStatus.accepted
          : map['status'] == 'declined'
              ? CoachingRequestStatus.declined
              : CoachingRequestStatus.pending,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : map['created_at'] != null
              ? DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now()
              : DateTime.now(),
      respondedAt: map['respondedAt'] != null
          ? DateTime.tryParse(map['respondedAt'].toString())
          : map['responded_at'] != null
              ? DateTime.tryParse(map['responded_at'].toString())
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'request_type': requestType.name,
      'target_id': targetId,
      'target_title': targetTitle,
      'player_id': playerId,
      'playerId': playerId,
      'player_name': playerName,
      'playerName': playerName,
      'player_email': playerEmail,
      'playerEmail': playerEmail,
      'coach_id': coachId,
      'coachId': coachId,
      'coach_name': coachName,
      'coachName': coachName,
      'preferred_schedule': preferredSchedule,
      'skill_level': skillLevel,
      'message': message,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'responded_at': respondedAt?.toIso8601String(),
    };
  }

  CoachingRequest copyWith({
    String? id,
    CoachingRequestType? requestType,
    String? targetId,
    String? targetTitle,
    String? playerId,
    String? playerName,
    String? playerEmail,
    String? coachId,
    String? coachName,
    String? preferredSchedule,
    String? skillLevel,
    String? message,
    CoachingRequestStatus? status,
    DateTime? createdAt,
    DateTime? respondedAt,
  }) {
    return CoachingRequest(
      id: id ?? this.id,
      requestType: requestType ?? this.requestType,
      targetId: targetId ?? this.targetId,
      targetTitle: targetTitle ?? this.targetTitle,
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      playerEmail: playerEmail ?? this.playerEmail,
      coachId: coachId ?? this.coachId,
      coachName: coachName ?? this.coachName,
      preferredSchedule: preferredSchedule ?? this.preferredSchedule,
      skillLevel: skillLevel ?? this.skillLevel,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }
}
