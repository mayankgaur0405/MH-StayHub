class User {
  final String id;
  final String phone;
  final String? name;
  final String? email;
  final String role;
  final bool isPhoneVerified;
  final List<String> savedAccommodations;

  User({
    required this.id,
    required this.phone,
    this.name,
    this.email,
    required this.role,
    required this.isPhoneVerified,
    required this.savedAccommodations,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'],
      email: json['email'],
      role: json['role'] ?? 'student',
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      savedAccommodations: List<String>.from(json['savedAccommodations'] ?? []),
    );
  }
}
