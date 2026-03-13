import 'package:archilink/features/Post_Details/domain/entity/comment_owner_entity.dart';

class CommentEntity {
  final int id;
  final String body;
  final String createdAt;
  final int? parentId;
  final int likesCount;
  final int repliesCount;
  final bool likedByMe;
  final CommentOwnerEntity owner;

  const CommentEntity({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.owner,
    this.parentId,
    required this.likesCount,
    required this.repliesCount,
    required this.likedByMe,
  });
}
