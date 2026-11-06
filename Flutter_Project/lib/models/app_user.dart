import '../core/constants/app_constants.dart';

class AppUser {
  final String uid;
  final String fullName;
  final String email;
  final UserRole role;
  final String? profilePictureUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Profile details
  final PlayerLevel playerLevel;
  final String? specialization;
  final String? bio;

  AppUser({
    required this.uid,
    required this.fullName,
    required this.email,
    this.role = UserRole.player,
    this.profilePictureUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.playerLevel = PlayerLevel.notEvaluated,
    this.specialization,
    this.bio,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  AppUser copyWith({
    String? fullName,
    String? email,
    UserRole? role,
    String? profilePictureUrl,
    PlayerLevel? playerLevel,
    String? specialization,
    String? bio,
    DateTime? updatedAt,
  }) {
    return AppUser(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      playerLevel: playerLevel ?? this.playerLevel,
      specialization: specialization ?? this.specialization,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'role': role.name,
      'profilePictureUrl': profilePictureUrl,
      'playerLevel': playerLevel.name,
      'specialization': specialization,
      'bio': bio,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      uid: id,
      fullName: map['fullName'] ?? 'User',
      email: map['email'] ?? '',
      role: UserRole.fromString(map['role']),
      profilePictureUrl: map['profilePictureUrl'],
      playerLevel: PlayerLevel.fromString(map['playerLevel']),
      specialization: map['specialization'],
      bio: map['bio'],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
