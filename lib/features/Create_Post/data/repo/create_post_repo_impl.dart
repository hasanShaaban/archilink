import 'package:archilink/core/error/exception_to_faliure_mapper.dart';
import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Create_Post/domain/data_source/create_post_remote_data_source.dart';
import 'package:archilink/features/Create_Post/domain/entity/create_post_parms.dart';
import 'package:archilink/features/Create_Post/domain/entity/create_post_response_entity.dart';
import 'package:archilink/features/Create_Post/domain/repo/create_post_repo.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_local_data_source.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:dartz/dartz.dart';

class CreatePostRepoImpl extends CreatePostRepo {
  final ProfileLocalDataSource profileLocalDataSource;
  final CreatePostRemoteDataSource remoteDataSource;

  CreatePostRepoImpl(
    this.profileLocalDataSource, {
    required this.remoteDataSource,
  });
  @override
  ProfileEntity? getPosterProfileData() {
    return profileLocalDataSource.getCachedProfile();
  }

  @override
  Future<Either<Failure, CreatePostResponseEntity>> createPost(
    CreatePostParms parms,
  ) async {
    try {
      final response = await remoteDataSource.createPost(parms);
      return right(response);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }
}
