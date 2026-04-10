import 'package:archilink/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class NotificationRepo {
  Future<Either<Failure, bool>> registerFCM();
  void listenToTokenRefresh();
  bool get isTokenRegistered;
  Future<void> initDisplay();
  void listenToForgroundMessage();
  Future<void> handleInitialMessage();
}