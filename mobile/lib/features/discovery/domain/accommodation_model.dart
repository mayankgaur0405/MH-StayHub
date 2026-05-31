class Accommodation {
  final String id;
  final String name;
  final String slug;
  final String type; // hostel, pg, coliving
  final String gender; // boys, girls, coed
  final String address;
  final List<String> images;
  final List<String> amenities;
  final double startingPrice;
  final double? deposit;
  final String verificationStatus;
  final String? description;
  final Map<String, dynamic>? ownerContact;
  final List<dynamic>? nearbyColleges;

  Accommodation({
    required this.id,
    required this.name,
    required this.slug,
    required this.type,
    required this.gender,
    required this.address,
    required this.images,
    required this.amenities,
    required this.startingPrice,
    this.deposit,
    required this.verificationStatus,
    this.description,
    this.ownerContact,
    this.nearbyColleges,
  });

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    final pricing = json['pricing'] ?? {};
    final verification = json['verification'] ?? {};
    
    return Accommodation(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      type: json['type'] ?? 'hostel',
      gender: json['gender'] ?? 'coed',
      address: json['address'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      startingPrice: (pricing['startingPrice'] ?? 0).toDouble(),
      deposit: pricing['deposit'] != null ? (pricing['deposit']).toDouble() : null,
      verificationStatus: verification['status'] ?? 'unverified',
      description: json['description'],
      ownerContact: json['ownerContact'],
      nearbyColleges: json['nearbyColleges'],
    );
  }
}
