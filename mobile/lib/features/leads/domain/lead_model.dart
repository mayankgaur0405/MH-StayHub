class Lead {
  final String id;
  final String user;
  final String accommodation;
  final String preferredDate;
  final String? notes;
  final String status;

  Lead({
    required this.id,
    required this.user,
    required this.accommodation,
    required this.preferredDate,
    this.notes,
    required this.status,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['_id'] ?? '',
      user: json['studentId'] ?? '',
      accommodation: (json['accommodation'] is Map) 
          ? (json['accommodation']['name'] ?? '') 
          : (json['accommodation'] ?? ''),
      preferredDate: json['preferredDate'] ?? '',
      notes: json['notes'],
      status: json['status'] ?? 'pending',
    );
  }
}
