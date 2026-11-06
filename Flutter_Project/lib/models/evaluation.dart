import '../core/constants/app_constants.dart';

class Evaluation {
  final String id;
  final String roomId;
  final String coachId;
  final String playerId;
  final String evaluationType; // 'initial', 'progress', 'final'
  final DateTime evaluationDate;
  final Map<String, int> skillRatings; // Skill name -> rating (1-10)
  final Map<String, String> observations; // Skill name -> observation note
  final String? generalNotes;
  final double overallScore;
  final PlayerLevel assignedLevel;
  final DateTime createdAt;

  Evaluation({
    required this.id,
    required this.roomId,
    required this.coachId,
    required this.playerId,
    this.evaluationType = 'progress',
    required this.evaluationDate,
    required this.skillRatings,
    this.observations = const {},
    this.generalNotes,
    double? overallScore,
    this.assignedLevel = PlayerLevel.intermediate,
    DateTime? createdAt,
  })  : overallScore = overallScore ?? _calculateAverage(skillRatings),
        createdAt = createdAt ?? DateTime.now();

  static double _calculateAverage(Map<String, int> ratings) {
    if (ratings.isEmpty) return 0.0;
    int sum = 0;
    int count = 0;
    for (final score in ratings.values) {
      if (score > 0) {
        sum += score;
        count++;
      }
    }
    if (count == 0) return 0.0;
    return double.parse((sum / count).toStringAsFixed(1));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomId': roomId,
      'coachId': coachId,
      'playerId': playerId,
      'evaluationType': evaluationType,
      'evaluationDate': evaluationDate.toIso8601String(),
      'skillRatings': skillRatings,
      'observations': observations,
      'generalNotes': generalNotes,
      'overallScore': overallScore,
      'assignedLevel': assignedLevel.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Evaluation.fromMap(Map<String, dynamic> map, String docId) {
    final rawRatings = map['skillRatings'] as Map<dynamic, dynamic>? ?? {};
    final parsedRatings = rawRatings.map((k, v) => MapEntry(k.toString(), (v as num).toInt()));

    final rawObservations = map['observations'] as Map<dynamic, dynamic>? ?? {};
    final parsedObservations = rawObservations.map((k, v) => MapEntry(k.toString(), v.toString()));

    return Evaluation(
      id: docId,
      roomId: map['roomId'] ?? '',
      coachId: map['coachId'] ?? '',
      playerId: map['playerId'] ?? '',
      evaluationType: map['evaluationType'] ?? 'progress',
      evaluationDate: map['evaluationDate'] != null
          ? DateTime.tryParse(map['evaluationDate']) ?? DateTime.now()
          : DateTime.now(),
      skillRatings: parsedRatings,
      observations: parsedObservations,
      generalNotes: map['generalNotes'],
      overallScore: (map['overallScore'] as num?)?.toDouble() ?? _calculateAverage(parsedRatings),
      assignedLevel: PlayerLevel.fromString(map['assignedLevel']),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
