import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Auth/domain/entity/auth_token.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  Future<Either<Failure, AuthToken>> login({required String email, required String password});
}