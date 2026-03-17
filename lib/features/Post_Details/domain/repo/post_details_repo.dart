import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post_Details/domain/entity/comment_entity.dart';
import 'package:archilink/features/Post_Details/domain/entity/post_comments_entity.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PostDetailsRepo {
  Future<Either<Failure, PostCommentsEntity>> getPostComments(
    int postId,
    int page,
  );
  Future<Either<Failure, PostCommentsEntity>> getCommentReplies(
    int commentId,
    int page,
  );

  Future<Either<Failure, ProfileEntity>> getCachedProfile();
  Future<Either<Failure, bool>> toggleCommentLike(int commentId);
  Future<Either<Failure, PostEntity>> refreshPostDetails(int postId);
  Future<Either<Failure, CommentEntity>> addComment({
    required int postId,
    required String body,
    int? parentId,
  });
}
