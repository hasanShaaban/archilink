class AddCommentResponseEntity {
  final int id;
  final int postId;
  final int userId;
  final int? parentId;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AddCommentResponseEntity({
    required this.id,
    required this.postId,
    required this.userId,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    this.parentId,
  });
}