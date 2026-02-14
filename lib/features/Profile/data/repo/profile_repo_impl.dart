import 'package:archilink/core/error/exception_to_faliure_mapper.dart';
import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Profile/domain/data_source/profile_remote_data_source.dart';
import 'package:archilink/features/Profile/domain/entity/user_profile_entity.dart';
import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:dartz/dartz.dart';

class ProfileRepoImpl implements ProfileRepo{
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserProfileEntity>> getProfile({required String username}) async{
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