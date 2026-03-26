import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Post/domain/entity/posts_entity.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepo {
  Future<Either<Failure, ProfileEntity>> getPersonalProfile();
  Future<Either<Failure, ProfileEntity>> getUserProfile({
    required String username,
  });
  Future<Either<Failure, PostsEntity>> getMyPosts(int page);
  Future<Either<Failure, PostsEntity>> getProfilePosts({
    required String username,
    required int page,
  });
  Future<Either<Failure, bool>> follow(String username);
}
