class CreatePostEntity {
  final int id;
  final String body;
  final String privacy;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CreatePostEntity({
    required this.id,
    required this.body,
    required this.privacy,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });
}
