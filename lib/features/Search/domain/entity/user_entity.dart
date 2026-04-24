class UserEntity {
  final int id;
  final String name;
  final String username;
  final String? userAvatar;
  final bool isVerified;
  final String? country;
  final String? city;

  const UserEntity({
    required this.id,
    required this.name,
    required this.username,
    this.userAvatar,
    required this.isVerified,
    this.country,
    this.city,
  });
}