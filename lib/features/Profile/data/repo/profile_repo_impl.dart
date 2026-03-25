import 'dart:developer';

import 'package:archilink/core/error/exception_to_faliure_mapper.dart';
import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_local_data_source.dart';

import 'package:archilink/features/Post/domain/entity/posts_entity.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_local_data_source.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_remote_data_source.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:dartz/dartz.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, ProfileEntity>> getPersonalProfile() async {
    AuthLocalDataSource dataSource = sl<AuthLocalDataSource>();
    String username = dataSource.getUsername()!;
    try {
      final remoteModel = await remoteDataSource.getProfile(username: username);
      final localModel = localDataSource.getCachedProfile();

      if (localModel == null || localModel != remoteModel) {
        log('Profile data updated, saving to local storage');
        await localDataSource.saveProfileData(remoteModel.toJson());
      }

      return right(remoteModel);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> getUserProfile({
    required String username,
  }) async {
    try {
      final model = await remoteDataSource.getProfile(username: username);
      return right(model);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, PostsEntity>> getMyPosts(int page) async {
    try {
      final model = await remoteDataSource.getMyPosts(page);
      return right(model.toEntity());
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, PostsEntity>> getProfilePosts({
    required String username,
    required int page,
  }) async {
    try {
      final model = await remoteDataSource.getProfilePosts(
        username: username,
        page: page,
      );
      return right(model.toEntity());
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }
}
