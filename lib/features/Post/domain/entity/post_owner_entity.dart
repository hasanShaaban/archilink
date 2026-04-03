class PostOwnerEntity {
  final int id;
  final String name;
  final String username;
  final String? profilePictureUrl;
  final String? city, country;

  const PostOwnerEntity({
    required this.id,
    required this.name,
    required this.username,
    this.profilePictureUrl, this.city, this.country,
  });
}