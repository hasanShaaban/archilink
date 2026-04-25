import 'package:archilink/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class SettingRepo {
  Future<Either<Failure, bool>> logOut();
}
