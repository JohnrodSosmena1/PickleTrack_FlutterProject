class TrainingProgram {
  final String id;
  final String roomId;
  final String name;
  final String description;
  final String mainGoal;
  final List<String> secondaryGoals;
  final DateTime startDate;
  final DateTime endDate;
  final String trainingFrequency;
  final String status; // 'active', 'completed', 'paused'
  final DateTime createdAt;
  final DateTime updatedAt;

  TrainingProgram({
    required this.id,
    required this.roomId,
    required this.name,
    required this.description,
    required this.mainGoal,
    this.secondaryGoals = const [],
    required this.startDate,
    required this.endDate,
    this.trainingFrequency = '2x per week',
    this.status = 'active',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomId': roomId,
      'name': name,
      'description': description,
      'mainGoal': mainGoal,
      'secondaryGoals': secondaryGoals,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'trainingFrequency': trainingFrequency,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TrainingProgram.fromMap(Map<String, dynamic> map, String docId) {
    return TrainingProgram(
      id: docId,
      roomId: map['roomId'] ?? '',
      name: map['name'] ?? 'Training Program',
      description: map['description'] ?? '',
      mainGoal: map['mainGoal'] ?? '',
      secondaryGoals: map['secondaryGoals'] != null
          ? List<String>.from(map['secondaryGoals'])
          : [],
      startDate: map['startDate'] != null
          ? DateTime.tryParse(map['startDate']) ?? DateTime.now()
          : DateTime.now(),
      endDate: map['endDate'] != null
          ? DateTime.tryParse(map['endDate']) ?? DateTime.now().add(const Duration(days: 90))
          : DateTime.now().add(const Duration(days: 90)),
      trainingFrequency: map['trainingFrequency'] ?? '2x per week',
      status: map['status'] ?? 'active',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
