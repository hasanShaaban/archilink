import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Profile/domain/entity/user_profile_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepo {
  Future<Either<Failure, UserProfileEntity>> getPersonalProfile();
  Future<Either<Failure, UserProfileEntity>> getUserProfile({required String username});
}