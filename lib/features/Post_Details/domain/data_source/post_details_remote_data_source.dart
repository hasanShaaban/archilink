import 'package:archilink/features/Post_Details/domain/entity/post_comments_entity.dart';

abstract class PostDetailsRemoteDataSource {
  Future<PostCommentsEntity> getPostComments(int postId, int page);
  Future<bool> toggleCommentLike(int commentId);
}
