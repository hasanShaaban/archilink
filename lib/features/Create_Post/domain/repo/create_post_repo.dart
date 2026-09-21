import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Create_Post/domain/entity/create_post_parms.dart';
import 'package:archilink/features/Create_Post/domain/entity/create_post_response_entity.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:dartz/dartz.dart';

abstract class CreatePostRepo {
  ProfileEntity? getPosterProfileData();
  Future<Either<Failure, CreatePostResponseEntity>> createPost(CreatePostParms parms);
  Future<Either<Failure, bool>> updatePost({
    required int postId,
    required String body,
    required String privacy,
  });
}
