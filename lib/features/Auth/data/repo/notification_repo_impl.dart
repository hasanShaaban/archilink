import 'dart:developer';

import 'package:archilink/core/error/exception_to_faliure_mapper.dart';
import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/core/services/notification/data_source/fcm_data_source.dart';
import 'package:archilink/core/services/notification/display/notificatio_display_service.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_local_data_source.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_remote_data_source.dart';
import 'package:archilink/features/Auth/domain/repo/notification_repo.dart';
import 'package:dartz/dartz.dart';

class NotificationRepoImpl extends NotificationRepo {
  final FCMDataSource fcmDataSource;
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  final NotificationDisplayService displayService;

  NotificationRepoImpl(
    this.fcmDataSource,
    this.authRemoteDataSource,
    this.authLocalDataSource,
    this.displayService,
  );

  @override
  Future<Either<Failure, bool>> registerFCM() async {
    try {
      await fcmDataSource.requestPremision();
      final token = await fcmDataSource.getToken();
      if (token == null) {
        await authLocalDataSource.setTokenRegistered(false);
        return left(UnknownFailure());
      }

      final isSuccess = await authRemoteDataSource.registerFCM(token);
      await authLocalDataSource.setTokenRegistered(isSuccess);
      return right(isSuccess);
    } on AppException catch (e) {
      await authLocalDataSource.setTokenRegistered(false);
      return left(mapExceptionToFailure(e));
    } catch (_) {
      await authLocalDataSource.setTokenRegistered(false);
      return left(UnknownFailure());
    }
  }

  @override
  bool get isTokenRegistered => authLocalDataSource.isTokenRegistered();

  @override
  void listenToTokenRefresh() {
    fcmDataSource.tokenRefresh.listen((newToken) async {
      try {
        final isSuccess = await authRemoteDataSource.registerFCM(newToken);
        await authLocalDataSource.setTokenRegistered(isSuccess);
      } catch (_) {
        await authLocalDataSource.setTokenRegistered(false);
      }
    });
  }

  @override
  Future<void> handleInitialMessage() async {
    final message = await fcmDataSource.getInitialMessage();
    if (message != null) {
      log(message.toString());
    }
  }

  @override
  Future<void> initDisplay() async {
    await displayService.init();
  }

  @override
  void listenToForgroundMessage() {
    fcmDataSource.onForegroundMessage.listen((message) {
      displayService.show(message);
    });
  }
}
