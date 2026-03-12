class CommentOwnerEntity {
  final int id;
  final String name;
  final String username;
  final String? profilePictureUrl;

  const CommentOwnerEntity({
    required this.id,
    required this.name,
    required this.username,
    this.profilePictureUrl,
  });
}