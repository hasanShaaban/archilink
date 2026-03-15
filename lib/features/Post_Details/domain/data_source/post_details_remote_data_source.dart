import 'package:archilink/features/Post/data/models/post_model.dart';
import 'package:archilink/features/Post_Details/domain/entity/add_comment_response_entity.dart';
import 'package:archilink/features/Post_Details/domain/entity/post_comments_entity.dart';

abstract class PostDetailsRemoteDataSource {
  Future<PostCommentsEntity> getPostComments(int postId, int page);
  Future<PostCommentsEntity> getCommentReplies(int commentId, int page);
  Future<bool> toggleCommentLike(int commentId);
  Future<PostModel> refreshPostDetails(int postId);
  Future<AddCommentResponseEntity> addComment({
    required int postId,
    required String body,
    int? parentId,
  });
}
