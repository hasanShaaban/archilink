import 'package:archilink/core/error/exception_to_faliure_mapper.dart';
import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Edit_Profile/domain/data_source/edit_profile_remote_data_source.dart';
import 'package:archilink/features/Edit_Profile/domain/entity/edit_profile_request_body.dart';
import 'package:archilink/features/Edit_Profile/domain/entity/universities_response_entity.dart';
import 'package:archilink/features/Edit_Profile/domain/repo/edit_profile_repo.dart';
import 'package:dartz/dartz.dart';

class EditProfileRepoImpl extends EditProfileRepo {
  final EditProfileRemoteDataSource remoteDataSource;

  EditProfileRepoImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, UniversitiesResponseEntity>> getUniversities() async {
    try {
      final result = await remoteDataSource.getUniversities();
      return right(result);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateProfile(
    EditProfileRequestBody requestBody,
  ) async {
    try {
      final result = await remoteDataSource.updateProfile(requestBody);
      return right(result);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }
}
