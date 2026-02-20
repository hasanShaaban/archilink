import 'package:archilink/core/error/exception_to_faliure_mapper.dart';
import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Home/domain/data_source/home_remote_data_source.dart';
import 'package:archilink/features/Home/domain/entity/global_feed_entity.dart';
import 'package:archilink/features/Home/domain/repo/home_repo.dart';
import 'package:dartz/dartz.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepoImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, GlobalFeedEntity>> getGlobalFeed({
    required int page,
  }) async {
    try {
      final result = await remoteDataSource.getGlobalFeed(page: page);
      return right(result.toEntity());
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }
}
