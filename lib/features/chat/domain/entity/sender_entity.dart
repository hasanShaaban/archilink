class SenderEntity {
  final int id;
  final String name;
  final String username;
  final String? userAvatar;
  final String? country;
  final String? city;

  const SenderEntity({
    required this.id,
    required this.name,
    required this.username,
    this.userAvatar,
    this.country,
    this.city,
  });
}