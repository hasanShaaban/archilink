import 'package:archilink/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class NotificationRepo {
  Future<Either<Failure, bool>> registerFCM();
  bool get isTokenRegistered;
}