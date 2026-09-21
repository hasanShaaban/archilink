import 'package:archilink/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class PostRepo {
  Future<Either<Failure, bool>> togglePostLike({required int postId});
  Future<Either<Failure, bool>> interestPost({required int postId});
  Future<Either<Failure, bool>> hidePost({required int postId});
  Future<Either<Failure, bool>> savePost({
    required int postId,
    required int collectionId,
  });
  Future<Either<Failure, bool>> deletePost({required int postId});
}
