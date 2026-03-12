import 'package:archilink/features/Post_Details/domain/entity/comment_entity.dart';
import 'package:archilink/features/Post_Details/domain/entity/comment_pagination_entity.dart';

class PostCommentsEntity {
  final List<CommentEntity> comments;
  final CommentsPaginationEntity pagination;

  const PostCommentsEntity({
    required this.comments,
    required this.pagination,
  });
}