import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Post_Details/domain/entity/post_comments_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PostDetailsRepo {
  Future<Either<Failure, PostCommentsEntity>> getPostComments(
    int postId,
    int page,
  );
}
