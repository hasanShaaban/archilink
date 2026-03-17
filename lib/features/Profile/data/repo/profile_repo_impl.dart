

import 'package:archilink/core/error/exception_to_faliure_mapper.dart';
import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_local_data_source.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_local_data_source.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_remote_data_source.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:dartz/dartz.dart';

class ProfileRepoImpl implements ProfileRepo{
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepoImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, ProfileEntity>> getPersonalProfile() async{
    AuthLocalDataSource dataSource = sl<AuthLocalDataSource>();
          String username = dataSource.getUsername()!;
    try{
      final model = await remoteDataSource.getProfile(username: username);
      return right(model);
    }on AppException catch(e){
      return left(mapExceptionToFailure(e));
    }catch(_){
      return left(UnknownFailure());
    }
  }
  
  @override
  Future<Either<Failure, ProfileEntity>> getUserProfile({required String username}) async{
    try{
      final model = await remoteDataSource.getProfile(username: username);
      return right(model);
    }on AppException catch(e){
      return left(mapExceptionToFailure(e));
    }catch(_){
      return left(UnknownFailure());
    }
  }


}