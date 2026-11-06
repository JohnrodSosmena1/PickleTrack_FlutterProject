import '../core/constants/app_constants.dart';

class ActivityItem {
  final String id;
  final String actorId;
  final String actorName;
  final String? roomId;
  final String? recipientId;
  final ActivityType type;
  final String description;
  final DateTime createdAt;

  ActivityItem({
    required this.id,
    required this.actorId,
    required this.actorName,
    this.roomId,
    this.recipientId,
    required this.type,
    required this.description,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'actorId': actorId,
      'actorName': actorName,
      'roomId': roomId,
      'recipientId': recipientId,
      'type': type.name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ActivityItem.fromMap(Map<String, dynamic> map, String docId) {
    return ActivityItem(
      id: docId,
      actorId: map['actorId'] ?? '',
      actorName: map['actorName'] ?? 'User',
      roomId: map['roomId'],
      recipientId: map['recipientId'],
      type: ActivityType.fromString(map['type']),
      description: map['description'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
