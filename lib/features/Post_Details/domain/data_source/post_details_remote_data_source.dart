import 'package:archilink/features/Post/data/models/post_model.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post_Details/domain/entity/post_comments_entity.dart';

abstract class PostDetailsRemoteDataSource {
  Future<PostCommentsEntity> getPostComments(int postId, int page);
  Future<bool> toggleCommentLike(int commentId);
  Future<PostModel> refreshPostDetails(int postId);
}
