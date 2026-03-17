import 'package:archilink/core/error/exception_to_faliure_mapper.dart';
import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/features/Post/domain/entity/post_entity.dart';
import 'package:archilink/features/Post_Details/domain/data_source/post_details_remote_data_source.dart';
import 'package:archilink/features/Post_Details/domain/entity/comment_entity.dart';
import 'package:archilink/features/Post_Details/domain/entity/post_comments_entity.dart';
import 'package:archilink/features/Post_Details/domain/repo/post_details_repo.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_local_data_source.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:dartz/dartz.dart';

class PostDetailsRepoImpl implements PostDetailsRepo {
  final PostDetailsRemoteDataSource remoteDataSource;

  PostDetailsRepoImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, PostCommentsEntity>> getPostComments(
    int postId,
    int page,
  ) async {
    try {
      final result = await remoteDataSource.getPostComments(postId, page);
      return right(result);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, PostCommentsEntity>> getCommentReplies(
    int commentId,
    int page,
  ) async {
    try {
      final result = await remoteDataSource.getCommentReplies(commentId, page);
      return right(result);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> toggleCommentLike(int commentId) async {
    try {
      final reseponse = await remoteDataSource.toggleCommentLike(commentId);
      return right(reseponse);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, PostEntity>> refreshPostDetails(int postId) async {
    try {
      final result = await remoteDataSource.refreshPostDetails(postId);
      return right(result.toEntity());
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, CommentEntity>> addComment({
    required int postId,
    required String body,
    int? parentId,
  }) async {
    try {
      final result = await remoteDataSource.addComment(
        postId: postId,
        body: body,
        parentId: parentId,
      );
      return right(result);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> getCachedProfile() async{
    ProfileLocalDataSource localDataSource = sl<ProfileLocalDataSource>();
    try {
      final profile = localDataSource.getCachedProfile();
      if (profile == null) return left(CacheFailure());
      return right(profile);
    } catch (_) {
      return left(CacheFailure());
    }
  }
}
