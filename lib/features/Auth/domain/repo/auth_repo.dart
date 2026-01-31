import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Auth/domain/entity/auth_token.dart';
import 'package:archilink/features/Auth/domain/entity/register_etity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  Future<Either<Failure, AuthToken>> login({required String email, required String password});
  Future<Either<Failure, RegisterEntity>> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String username,
    required String role,
    String? phone,
  });
  Future<Either<Failure, bool>> checkUsername({required String username});
}