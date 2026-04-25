import 'package:archilink/core/error/exception_to_faliure_mapper.dart';
import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/settings/domain/data_source/setting_remote_data_source.dart';
import 'package:archilink/features/settings/domain/repo/setting_repo.dart';
import 'package:dartz/dartz.dart';

class SettingRepoImpl extends SettingRepo {
  final SettingRemoteDataSource remoteDataSource;

  SettingRepoImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, bool>> logOut() async {
    try {
      final result = await remoteDataSource.logOut();
      return right(result);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }
}
