import 'package:archilink/core/error/exception_to_faliure_mapper.dart';
import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/core/services/notification/data_source/fcm_data_source.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_local_data_source.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_remote_data_source.dart';
import 'package:archilink/features/Auth/domain/repo/notification_repo.dart';
import 'package:dartz/dartz.dart';

class NotificationRepoImpl extends NotificationRepo {
  final FCMDataSource fcmDataSource;
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  NotificationRepoImpl(
    this.fcmDataSource,
    this.authRemoteDataSource,
    this.authLocalDataSource,
  );

  @override
  Future<Either<Failure, bool>> registerFCM() async {
    try {
      await fcmDataSource.requestPremision();
      final token = await fcmDataSource.getToken();
      if(token == null){
        await authLocalDataSource.setTokenRegistered(false);
        return left(UnknownFailure());
      }

      final isSuccess = await authRemoteDataSource.registerFCM(token);
      await authLocalDataSource.setTokenRegistered(isSuccess);
      return right(isSuccess);
    }on AppException catch(e){
      await authLocalDataSource.setTokenRegistered(false);
      return left(mapExceptionToFailure(e));
    }catch(_){
      await authLocalDataSource.setTokenRegistered(false);
      return left(UnknownFailure());
    }
  }

  @override
  bool get isTokenRegistered => authLocalDataSource.isTokenRegistered();
}
