import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/settings/domain/entity/followers_and_followings_entity.dart';
import 'package:archilink/features/settings/domain/entity/liked_posts_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SettingRepo {
  Future<Either<Failure, bool>> logOut();
  Future<Either<Failure, FollowersAndFollowingsEntity>> getFollowers({
    required String username,
    required int page,
  });
  Future<Either<Failure, FollowersAndFollowingsEntity>> getFollowing({
    required String username,
    required int page,
  });
  Future<Either<Failure, LikedPostsEntity>> getLikedPosts({required int page});
}
