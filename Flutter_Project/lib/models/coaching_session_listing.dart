class CoachingSessionListing {
  final String id;
  final String title;
  final String coachId;
  final String coachName;
  final String? coachAvatarUrl;
  final String venue;
  final String city;
  final DateTime dateTime;
  final String skillLevel;
  final int totalSlots;
  final int bookedSlots;
  final double price;
  final String description;

  const CoachingSessionListing({
    required this.id,
    required this.title,
    required this.coachId,
    required this.coachName,
    this.coachAvatarUrl,
    required this.venue,
    required this.city,
    required this.dateTime,
    required this.skillLevel,
    required this.totalSlots,
    this.bookedSlots = 0,
    required this.price,
    this.description = '',
  });

  int get slotsLeft => (totalSlots - bookedSlots).clamp(0, totalSlots);
  bool get isFull => slotsLeft <= 0;

  factory CoachingSessionListing.fromMap(Map<String, dynamic> map, {String? id}) {
    return CoachingSessionListing(
      id: id ?? map['id'] ?? '',
      title: map['title'] ?? '',
      coachId: map['coachId'] ?? map['coach_id'] ?? '',
      coachName: map['coachName'] ?? map['coach_name'] ?? 'Coach',
      coachAvatarUrl: map['coachAvatarUrl'] ?? map['coach_avatar_url'],
      venue: map['venue'] ?? '',
      city: map['city'] ?? 'Manila',
      dateTime: map['dateTime'] != null
          ? DateTime.tryParse(map['dateTime'].toString()) ?? DateTime.now()
          : map['date_time'] != null
              ? DateTime.tryParse(map['date_time'].toString()) ?? DateTime.now()
              : DateTime.now(),
      skillLevel: map['skillLevel'] ?? map['skill_level'] ?? 'All levels',
      totalSlots: (map['totalSlots'] ?? map['total_slots'] ?? 8) as int,
      bookedSlots: (map['bookedSlots'] ?? map['booked_slots'] ?? 0) as int,
      price: (map['price'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'coach_id': coachId,
      'coachId': coachId,
      'coach_name': coachName,
      'coachAvatarUrl': coachAvatarUrl,
      'coach_avatar_url': coachAvatarUrl,
      'venue': venue,
      'city': city,
      'date_time': dateTime.toIso8601String(),
      'skill_level': skillLevel,
      'total_slots': totalSlots,
      'booked_slots': bookedSlots,
      'price': price,
      'description': description,
    };
  }

  CoachingSessionListing copyWith({
    String? id,
    String? title,
    String? coachId,
    String? coachName,
    String? coachAvatarUrl,
    String? venue,
    String? city,
    DateTime? dateTime,
    String? skillLevel,
    int? totalSlots,
    int? bookedSlots,
    double? price,
    String? description,
  }) {
    return CoachingSessionListing(
      id: id ?? this.id,
      title: title ?? this.title,
      coachId: coachId ?? this.coachId,
      coachName: coachName ?? this.coachName,
      coachAvatarUrl: coachAvatarUrl ?? this.coachAvatarUrl,
      venue: venue ?? this.venue,
      city: city ?? this.city,
      dateTime: dateTime ?? this.dateTime,
      skillLevel: skillLevel ?? this.skillLevel,
      totalSlots: totalSlots ?? this.totalSlots,
      bookedSlots: bookedSlots ?? this.bookedSlots,
      price: price ?? this.price,
      description: description ?? this.description,
    );
  }
}
