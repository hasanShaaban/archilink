import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepo {
  Future<Either<Failure, ProfileEntity>> getPersonalProfile();
  Future<Either<Failure, ProfileEntity>> getUserProfile({required String username});
}