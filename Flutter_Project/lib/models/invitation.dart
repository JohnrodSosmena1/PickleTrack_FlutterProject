import '../core/constants/app_constants.dart';

class Invitation {
  final String id;
  final String coachId;
  final String coachName;
  final String? coachAvatarUrl;
  final String playerId;
  final String playerName;
  final String playerEmail;
  final String proposedProgramName;
  final String proposedDuration; // e.g. '3 Months'
  final DateTime proposedStartDate;
  final String? message;
  final InvitationStatus status;
  final DateTime createdAt;
  final DateTime? respondedAt;

  Invitation({
    required this.id,
    required this.coachId,
    required this.coachName,
    this.coachAvatarUrl,
    required this.playerId,
    required this.playerName,
    required this.playerEmail,
    required this.proposedProgramName,
    this.proposedDuration = '3 Months',
    required this.proposedStartDate,
    this.message,
    this.status = InvitationStatus.pending,
    DateTime? createdAt,
    this.respondedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isPending => status == InvitationStatus.pending;
  bool get isAccepted => status == InvitationStatus.accepted;
  bool get isDeclined => status == InvitationStatus.declined;

  Invitation copyWith({
    InvitationStatus? status,
    DateTime? respondedAt,
  }) {
    return Invitation(
      id: id,
      coachId: coachId,
      coachName: coachName,
      coachAvatarUrl: coachAvatarUrl,
      playerId: playerId,
      playerName: playerName,
      playerEmail: playerEmail,
      proposedProgramName: proposedProgramName,
      proposedDuration: proposedDuration,
      proposedStartDate: proposedStartDate,
      message: message,
      status: status ?? this.status,
      createdAt: createdAt,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'coachId': coachId,
      'coachName': coachName,
      'coachAvatarUrl': coachAvatarUrl,
      'playerId': playerId,
      'playerName': playerName,
      'playerEmail': playerEmail,
      'proposedProgramName': proposedProgramName,
      'proposedDuration': proposedDuration,
      'proposedStartDate': proposedStartDate.toIso8601String(),
      'message': message,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'respondedAt': respondedAt?.toIso8601String(),
    };
  }

  factory Invitation.fromMap(Map<String, dynamic> map, String docId) {
    return Invitation(
      id: docId,
      coachId: map['coachId'] ?? '',
      coachName: map['coachName'] ?? 'Coach',
      coachAvatarUrl: map['coachAvatarUrl'],
      playerId: map['playerId'] ?? '',
      playerName: map['playerName'] ?? 'Player',
      playerEmail: map['playerEmail'] ?? '',
      proposedProgramName: map['proposedProgramName'] ?? 'Pickleball Training',
      proposedDuration: map['proposedDuration'] ?? '3 Months',
      proposedStartDate: map['proposedStartDate'] != null
          ? DateTime.tryParse(map['proposedStartDate']) ?? DateTime.now()
          : DateTime.now(),
      message: map['message'],
      status: InvitationStatus.fromString(map['status']),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      respondedAt: map['respondedAt'] != null
          ? DateTime.tryParse(map['respondedAt'])
          : null,
    );
  }
}
