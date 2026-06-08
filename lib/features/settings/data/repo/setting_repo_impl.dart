import 'package:archilink/core/error/exception_to_faliure_mapper.dart';
import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/settings/domain/data_source/setting_remote_data_source.dart';
import 'package:archilink/features/settings/domain/entity/comments_history_entity.dart';
import 'package:archilink/features/settings/domain/entity/customer_support_chat_entity.dart';
import 'package:archilink/features/settings/domain/entity/followers_and_followings_entity.dart';
import 'package:archilink/features/settings/domain/entity/liked_posts_entity.dart';
import 'package:archilink/features/settings/domain/entity/user_collection_entity.dart';
import 'package:archilink/features/settings/domain/repo/setting_repo.dart';
import 'package:dartz/dartz.dart';

class SettingRepoImpl extends SettingRepo {
  final SettingRemoteDataSource remoteDataSource;

  SettingRepoImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, bool>> logOut() async {
    try {
      final result = await remoteDataSource.logOut();
      return right(result);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, FollowersAndFollowingsEntity>> getFollowers({
    required String username,
    required int page,
  }) async {
    try {
      final result = await remoteDataSource.getFollowers(
        username: username,
        page: page,
      );
      return right(result);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, FollowersAndFollowingsEntity>> getFollowing({
    required String username,
    required int page,
  }) async {
    try {
      final result = await remoteDataSource.getFollowing(
        username: username,
        page: page,
      );
      return right(result);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, LikedPostsEntity>> getLikedPosts({
    required int page,
  }) async {
    try {
      final result = await remoteDataSource.getLikedPosts(page: page);
      return right(result);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, CommentsHistoryEntity>> getCommentsHistory({
    required int page,
  }) async {
    try {
      final result = await remoteDataSource.getCommentsHistory(page: page);
      return right(result);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserCollectionEntity>>> getCollections() async {
    try {
      final result = await remoteDataSource.getCollections();
      return right(result);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, CustomerSupportChatEntity>>
  getCustomerSupportChatDetails() async {
    try {
      final result = await remoteDataSource.getCustomerSupportChatDetails();
      return right(result);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }
}
