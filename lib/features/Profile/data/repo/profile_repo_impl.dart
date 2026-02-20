import 'dart:developer';

import 'package:archilink/core/error/exception_to_faliure_mapper.dart';
import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_local_data_source.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_local_data_source.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_remote_data_source.dart';
import 'package:archilink/features/Profile/domain/entity/user_profile_entity.dart';
import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:dartz/dartz.dart';

class ProfileRepoImpl implements ProfileRepo{
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepoImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, UserProfileEntity>> getPersonalProfile() async{
    AuthLocalDataSource dataSource = sl<AuthLocalDataSource>();
          String username = dataSource.getUsername()!;
    try{
      UserProfileEntity? profileData = localDataSource.getProfileData();
      if(profileData != null){//TODO: Check if the profile data has been updated
        return right(profileData);
      }
      final model = await remoteDataSource.getProfile(username: username);
      await localDataSource.saveProfileData(
        name: model.profile.name,
        username: model.profile.username,
        email: model.profile.email,
        bio: model.profile.bio,
        location: model.profile.location,
        profilePictureUrl: model.profile.profilePictureUrl,
        followers: model.followStats.followerCount,
        following: model.followStats.followedCount
      );
      return right(model.toEntity());
    }on AppException catch(e){
      return left(mapExceptionToFailure(e));
    }catch(_){
      return left(UnknownFailure());
    }
  }
  
  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile({required String username}) async{
    try{
      final model = await remoteDataSource.getProfile(username: username);
      return right(model.toEntity());
    }on AppException catch(e){
      return left(mapExceptionToFailure(e));
    }catch(_){
      return left(UnknownFailure());
    }
  }


}