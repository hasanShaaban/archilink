class ContactEntity {
  final int id;
  final String name;
  final String username;
  final String? avatar;
  final bool? isVerified;
  final String? role;
  final String? country;
  final String? city;

  const ContactEntity({
    required this.id,
    required this.name,
    required this.username,
    this.avatar,
    this.isVerified,
    this.role,
    this.country,
    this.city,
  });

  /// Backward-compatible alias for avatar
  String? get userAvatar => avatar;
}

