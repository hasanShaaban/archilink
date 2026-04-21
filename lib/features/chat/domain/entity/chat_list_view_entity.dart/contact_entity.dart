class ContactEntity {
  final int id;
  final String name;
  final String username;
  final String? userAvatar;
  final bool isVerified;
  final String country;
  final String city;

  const ContactEntity({
    required this.id,
    required this.name,
    required this.username,
    this.userAvatar,
    required this.isVerified,
    required this.country,
    required this.city,
  });
}
