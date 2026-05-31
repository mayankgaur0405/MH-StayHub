class College {
  final String id;
  final String name;
  final String slug;
  final String city;
  final String state;
  final String? logo;
  final bool isActive;

  College({
    required this.id,
    required this.name,
    required this.slug,
    required this.city,
    required this.state,
    this.logo,
    required this.isActive,
  });

  factory College.fromJson(Map<String, dynamic> json) {
    return College(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      logo: json['logo'],
      isActive: json['isActive'] ?? true,
    );
  }
}
