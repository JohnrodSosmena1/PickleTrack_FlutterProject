class Court {
  final String id;
  final String name;
  final String city;
  final String address;
  final List<String> imageUrls;
  final int courtCount;
  final String openingTime;
  final String closingTime;
  final List<String> facilities;
  final double hourlyRate;
  final List<String> coachIds;

  const Court({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    this.imageUrls = const [],
    required this.courtCount,
    required this.openingTime,
    required this.closingTime,
    this.facilities = const [],
    required this.hourlyRate,
    this.coachIds = const [],
  });

  String get operatingHours => '$openingTime - $closingTime';

  factory Court.fromMap(Map<String, dynamic> map, {String? id}) {
    return Court(
      id: id ?? map['id'] ?? '',
      name: map['name'] ?? '',
      city: map['city'] ?? 'Manila',
      address: map['address'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? map['image_urls'] ?? []),
      courtCount: (map['courtCount'] ?? map['court_count'] ?? 1) as int,
      openingTime: map['openingTime'] ?? map['opening_time'] ?? '6:00 AM',
      closingTime: map['closingTime'] ?? map['closing_time'] ?? '10:00 PM',
      facilities: List<String>.from(map['facilities'] ?? []),
      hourlyRate: (map['hourlyRate'] ?? map['hourly_rate'] ?? 0.0).toDouble(),
      coachIds: List<String>.from(map['coachIds'] ?? map['coach_ids'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'address': address,
      'image_urls': imageUrls,
      'court_count': courtCount,
      'opening_time': openingTime,
      'closing_time': closingTime,
      'facilities': facilities,
      'hourly_rate': hourlyRate,
      'coach_ids': coachIds,
    };
  }

  Court copyWith({
    String? id,
    String? name,
    String? city,
    String? address,
    List<String>? imageUrls,
    int? courtCount,
    String? openingTime,
    String? closingTime,
    List<String>? facilities,
    double? hourlyRate,
    List<String>? coachIds,
  }) {
    return Court(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      address: address ?? this.address,
      imageUrls: imageUrls ?? this.imageUrls,
      courtCount: courtCount ?? this.courtCount,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      facilities: facilities ?? this.facilities,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      coachIds: coachIds ?? this.coachIds,
    );
  }
}
