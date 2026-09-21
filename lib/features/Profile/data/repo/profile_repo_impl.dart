import 'dart:developer';
import 'dart:io';

import 'package:archilink/core/error/exception_to_faliure_mapper.dart';
import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_local_data_source.dart';

import 'package:archilink/features/Post/domain/entity/posts_entity.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_local_data_source.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_remote_data_source.dart';
import 'package:archilink/features/Profile/domain/entity/follow_status.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:archilink/features/Store/domain/entity/product_feed_entity.dart';
import 'package:dartz/dartz.dart';


class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  final AuthLocalDataSource? authLocalDataSource;

  ProfileRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, ProfileEntity>> getPersonalProfile() async {
    final dataSource = authLocalDataSource ?? sl<AuthLocalDataSource>();
    final username = dataSource.getUsername();
    if (username == null || username.isEmpty) {
      return left(UnknownFailure());
    }
    return getUserProfile(username: username);
  }

  @override
  Future<Either<Failure, ProfileEntity>> getUserProfile({
    required String username,
  }) async {
    try {
      final remoteModel = await remoteDataSource.getProfile(username: username);

      // Cache the profile locally when fetching the personal profile.
      try {
        final localModel = localDataSource.getCachedProfile();
        if (localModel == null || localModel != remoteModel) {
          log('Profile data updated, saving to local storage');
          await localDataSource.saveProfileData(remoteModel.toJson());
        }
      } catch (_) {
        // Caching is best-effort; don't block on failure.
      }

      return right(remoteModel);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, ProductFeedEntity>> getStoreProducts({
    required int storeId,
    int page = 1,
  }) async {
    try {
      final model = await remoteDataSource.getStoreProducts(
        storeId: storeId,
        page: page,
      );
      return right(model.toEntity());
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

  @override
  Future<Either<Failure, FollowStatus>> follow(String username) async {
    try {
      final model = await remoteDataSource.follow(username);
      return right(model);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> unfollow(String username) async {
    try {
      final model = await remoteDataSource.unfollow(username);
      return right(model);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateProfilePicture(File imageFile) async {
    try {
      final success = await remoteDataSource.updateProfilePicture(imageFile);
      return right(success);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateStoreLogo(File imageFile) async {
    try {
      final success = await remoteDataSource.updateStoreLogo(imageFile);
      return right(success);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateStoreBanner(File imageFile) async {
    try {
      final success = await remoteDataSource.updateStoreBanner(imageFile);
      return right(success);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProduct(int productId) async {
    try {
      final success = await remoteDataSource.deleteProduct(productId);
      return right(success);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }
}
