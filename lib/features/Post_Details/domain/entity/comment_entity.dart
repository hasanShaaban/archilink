import 'package:archilink/features/Post_Details/domain/entity/comment_owner_entity.dart';

class CommentEntity {
  final int id;
  final String body;
  final String createdAt;
  final CommentOwnerEntity owner;

  const CommentEntity({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.owner,
  });
}
