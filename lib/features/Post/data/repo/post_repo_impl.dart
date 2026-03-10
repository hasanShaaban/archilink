import 'package:archilink/core/error/exception_to_faliure_mapper.dart';
import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Post/domain/data_soource/post_remote_data_source.dart';
import 'package:archilink/features/Post/domain/repo/post_repo.dart';
import 'package:dartz/dartz.dart';

class PostRepoImpl implements PostRepo {
  final PostRemoteDataSource remoteDataSource;

  PostRepoImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, bool>> togglePostLike({required int postId}) async {
    try {
      final result = await remoteDataSource.togglePostLike(postId: postId);
      return right(result);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }
}