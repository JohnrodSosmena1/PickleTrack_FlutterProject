import '../core/constants/app_constants.dart';

class CoachingRoom {
  final String id;
  final String coachId;
  final String coachName;
  final String? coachAvatarUrl;
  final String playerId;
  final String playerName;
  final String? playerAvatarUrl;
  final String? invitationId;
  final String programName;
  final DateTime startDate;
  final DateTime plannedEndDate;
  final DateTime? completedAt;
  final CoachingRoomStatus status;
  final String mainGoal;
  final List<String> secondaryGoals;
  final String trainingFrequency;
  final int totalSessions;
  final double? latestEvaluationScore;
  final String? completionNotes;
  final DateTime createdAt;
  final DateTime updatedAt;

  CoachingRoom({
    required this.id,
    required this.coachId,
    required this.coachName,
    this.coachAvatarUrl,
    required this.playerId,
    required this.playerName,
    this.playerAvatarUrl,
    this.invitationId,
    required this.programName,
    required this.startDate,
    required this.plannedEndDate,
    this.completedAt,
    this.status = CoachingRoomStatus.active,
    required this.mainGoal,
    this.secondaryGoals = const [],
    this.trainingFrequency = '2x per week',
    this.totalSessions = 0,
    this.latestEvaluationScore,
    this.completionNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  bool get isActive => status == CoachingRoomStatus.active;
  bool get isCompleted => status == CoachingRoomStatus.completed;
  bool get isArchived => status == CoachingRoomStatus.archived;

  CoachingRoom copyWith({
    String? coachName,
    String? coachAvatarUrl,
    String? playerName,
    String? playerAvatarUrl,
    String? programName,
    DateTime? startDate,
    DateTime? plannedEndDate,
    DateTime? completedAt,
    CoachingRoomStatus? status,
    String? mainGoal,
    List<String>? secondaryGoals,
    String? trainingFrequency,
    int? totalSessions,
    double? latestEvaluationScore,
    String? completionNotes,
    DateTime? updatedAt,
  }) {
    return CoachingRoom(
      id: id,
      coachId: coachId,
      coachName: coachName ?? this.coachName,
      coachAvatarUrl: coachAvatarUrl ?? this.coachAvatarUrl,
      playerId: playerId,
      playerName: playerName ?? this.playerName,
      playerAvatarUrl: playerAvatarUrl ?? this.playerAvatarUrl,
      invitationId: invitationId,
      programName: programName ?? this.programName,
      startDate: startDate ?? this.startDate,
      plannedEndDate: plannedEndDate ?? this.plannedEndDate,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
      mainGoal: mainGoal ?? this.mainGoal,
      secondaryGoals: secondaryGoals ?? this.secondaryGoals,
      trainingFrequency: trainingFrequency ?? this.trainingFrequency,
      totalSessions: totalSessions ?? this.totalSessions,
      latestEvaluationScore: latestEvaluationScore ?? this.latestEvaluationScore,
      completionNotes: completionNotes ?? this.completionNotes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
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
      'playerAvatarUrl': playerAvatarUrl,
      'invitationId': invitationId,
      'programName': programName,
      'startDate': startDate.toIso8601String(),
      'plannedEndDate': plannedEndDate.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'status': status.name,
      'mainGoal': mainGoal,
      'secondaryGoals': secondaryGoals,
      'trainingFrequency': trainingFrequency,
      'totalSessions': totalSessions,
      'latestEvaluationScore': latestEvaluationScore,
      'completionNotes': completionNotes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory CoachingRoom.fromMap(Map<String, dynamic> map, String docId) {
    return CoachingRoom(
      id: docId,
      coachId: map['coachId'] ?? '',
      coachName: map['coachName'] ?? 'Coach',
      coachAvatarUrl: map['coachAvatarUrl'],
      playerId: map['playerId'] ?? '',
      playerName: map['playerName'] ?? 'Player',
      playerAvatarUrl: map['playerAvatarUrl'],
      invitationId: map['invitationId'],
      programName: map['programName'] ?? 'Pickleball Development',
      startDate: map['startDate'] != null
          ? DateTime.tryParse(map['startDate']) ?? DateTime.now()
          : DateTime.now(),
      plannedEndDate: map['plannedEndDate'] != null
          ? DateTime.tryParse(map['plannedEndDate']) ?? DateTime.now().add(const Duration(days: 90))
          : DateTime.now().add(const Duration(days: 90)),
      completedAt: map['completedAt'] != null ? DateTime.tryParse(map['completedAt']) : null,
      status: CoachingRoomStatus.fromString(map['status']),
      mainGoal: map['mainGoal'] ?? '',
      secondaryGoals: map['secondaryGoals'] != null
          ? List<String>.from(map['secondaryGoals'])
          : [],
      trainingFrequency: map['trainingFrequency'] ?? '2x per week',
      totalSessions: map['totalSessions'] ?? 0,
      latestEvaluationScore: (map['latestEvaluationScore'] as num?)?.toDouble(),
      completionNotes: map['completionNotes'],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
