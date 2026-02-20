class PostOwnerEntity {
  final int id;
  final String name;
  final String username;
  final String? profilePictureUrl;

  const PostOwnerEntity({
    required this.id,
    required this.name,
    required this.username,
    this.profilePictureUrl,
  });
}