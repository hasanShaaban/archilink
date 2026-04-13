import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Edit_Profile/domain/entity/edit_profile_request_body.dart';
import 'package:archilink/features/Edit_Profile/domain/entity/universities_response_entity.dart';
import 'package:dartz/dartz.dart';

abstract class EditProfileRepo {
  Future<Either<Failure, UniversitiesResponseEntity>> getUniversities();
  Future<Either<Failure, bool>> updateProfile(
    EditProfileRequestBody requestBody,
  );
}