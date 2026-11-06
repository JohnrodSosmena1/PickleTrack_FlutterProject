class CoachProfile {
  final String userId;
  final String displayName;
  final String? photoUrl;
  final String city;
  final int yearsExperience;
  final List<String> specialties;
  final List<String> skillLevels;
  final double hourlyRate;
  final String bio;
  final String availableSchedule;
  final bool isActive;

  const CoachProfile({
    required this.userId,
    required this.displayName,
    this.photoUrl,
    required this.city,
    required this.yearsExperience,
    this.specialties = const [],
    this.skillLevels = const [],
    required this.hourlyRate,
    required this.bio,
    required this.availableSchedule,
    this.isActive = true,
  });

  factory CoachProfile.fromMap(Map<String, dynamic> map, {String? id}) {
    return CoachProfile(
      userId: id ?? map['userId'] ?? map['user_id'] ?? '',
      displayName: map['displayName'] ?? map['display_name'] ?? 'Coach',
      photoUrl: map['photoUrl'] ?? map['photo_url'],
      city: map['city'] ?? 'Manila',
      yearsExperience: (map['yearsExperience'] ?? map['years_experience'] ?? 0) as int,
      specialties: List<String>.from(map['specialties'] ?? []),
      skillLevels: List<String>.from(map['skillLevels'] ?? map['skill_levels'] ?? []),
      hourlyRate: (map['hourlyRate'] ?? map['hourly_rate'] ?? 0.0).toDouble(),
      bio: map['bio'] ?? '',
      availableSchedule: map['availableSchedule'] ?? map['available_schedule'] ?? 'Weekdays & Weekends',
      isActive: map['isActive'] ?? map['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'userId': userId,
      'display_name': displayName,
      'displayName': displayName,
      'photo_url': photoUrl,
      'photoUrl': photoUrl,
      'city': city,
      'years_experience': yearsExperience,
      'yearsExperience': yearsExperience,
      'specialties': specialties,
      'skill_levels': skillLevels,
      'skillLevels': skillLevels,
      'hourly_rate': hourlyRate,
      'hourlyRate': hourlyRate,
      'bio': bio,
      'available_schedule': availableSchedule,
      'availableSchedule': availableSchedule,
      'is_active': isActive,
      'isActive': isActive,
    };
  }

  CoachProfile copyWith({
    String? userId,
    String? displayName,
    String? photoUrl,
    String? city,
    int? yearsExperience,
    List<String>? specialties,
    List<String>? skillLevels,
    double? hourlyRate,
    String? bio,
    String? availableSchedule,
    bool? isActive,
  }) {
    return CoachProfile(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      city: city ?? this.city,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      specialties: specialties ?? this.specialties,
      skillLevels: skillLevels ?? this.skillLevels,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      bio: bio ?? this.bio,
      availableSchedule: availableSchedule ?? this.availableSchedule,
      isActive: isActive ?? this.isActive,
    );
  }
}
