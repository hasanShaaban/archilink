import 'package:archilink/core/error/exception_to_faliure_mapper.dart';
import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Auth/data/models/validation_error_response.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_local_data_source.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_remote_data_source.dart';
import 'package:archilink/features/Auth/domain/entity/auth_token.dart';
import 'package:archilink/features/Auth/domain/entity/register_etity.dart';
import 'package:archilink/features/Auth/domain/repo/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepoImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, AuthToken>> login({
    required String email,
    required String password,
  }) async {
    try {
      final model = await remoteDataSource.login(
        email: email,
        password: password,
      );
      await localDataSource.saveToken(model.accessToken);
      await localDataSource.saveUsername(model.username);
      return right(model.toEntity());
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, RegisterEntity>> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String username,
    required String role,
    String? phone,
  }) async {
    try {
      final model = await remoteDataSource.register(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        name: name,
        username: username,
        role: role,
        phone: phone,
      );
      await localDataSource.saveToken(model.token);
      await localDataSource.saveUsername(model.user.username);
      return right(model.toEntity());
    } on AppException catch (e) {
      if (e is ValidationException) {
        final data = e.response?.data;
        if (data != null && data['errors'] != null) {
          final error = ValidationErrorResponse.fromJson(data);
          return left(
            ValidationFailure(
              message: error.message,
              fieldErrors: error.errors,
            ),
          );
        }
      }
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkUsername({
    required String username,
  }) async {
    try {
      final available = await remoteDataSource.checkUsername(
        username: username,
      );
      return right(available);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }

  @override
  bool? getRemeberMe() {
    return localDataSource.getRemeberMe();
  }

  @override
  Future<void> setRememberMe(bool rememeberMe) async {
    await localDataSource.setRememberMe(rememeberMe);
  }
}
