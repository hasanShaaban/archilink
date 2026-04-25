class UserEntity {
  final int id;
  final String name;
  final String username;
  final String? userAvatar;
  final bool isVerified;
  final bool isFollowing;
  final String? country;
  final String? city;

  const UserEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.isFollowing,
    this.userAvatar,
    required this.isVerified,
    this.country,
    this.city,
  });
}
