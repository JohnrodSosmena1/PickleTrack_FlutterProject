import '../core/constants/app_constants.dart';

class Drill {
  final String id;
  final String name;
  final String category;
  final DrillDifficulty difficulty;
  final String objective;
  final String description;
  final List<String> instructions;
  final int recommendedRepetitions;
  final String equipment;
  final String? imageUrl;
  final String? creatorId;
  final bool isPublic;
  final DateTime createdAt;

  Drill({
    required this.id,
    required this.name,
    required this.category,
    required this.difficulty,
    required this.objective,
    required this.description,
    this.instructions = const [],
    this.recommendedRepetitions = 20,
    this.equipment = 'Paddle, 4+ Pickleballs, Court',
    this.imageUrl,
    this.creatorId,
    this.isPublic = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'difficulty': difficulty.name,
      'objective': objective,
      'description': description,
      'instructions': instructions,
      'recommendedRepetitions': recommendedRepetitions,
      'equipment': equipment,
      'imageUrl': imageUrl,
      'creatorId': creatorId,
      'isPublic': isPublic,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Drill.fromMap(Map<String, dynamic> map, String docId) {
    return Drill(
      id: docId,
      name: map['name'] ?? 'Drill',
      category: map['category'] ?? 'Dinking',
      difficulty: DrillDifficulty.fromString(map['difficulty']),
      objective: map['objective'] ?? '',
      description: map['description'] ?? '',
      instructions: map['instructions'] != null
          ? List<String>.from(map['instructions'])
          : [],
      recommendedRepetitions: map['recommendedRepetitions'] ?? 20,
      equipment: map['equipment'] ?? 'Paddle, 4+ Pickleballs, Court',
      imageUrl: map['imageUrl'],
      creatorId: map['creatorId'],
      isPublic: map['isPublic'] ?? true,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
