import 'package:archilink/core/error/exception_to_faliure_mapper.dart';
import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Store/domain/data_source/store_remote_date_source.dart';
import 'package:archilink/features/Store/domain/entity/product_feed_entity.dart';
import 'package:archilink/features/Store/domain/repo/store_repo.dart';
import 'package:dartz/dartz.dart';

class StoreRepoImpl implements StoreRepo {
  final StoreRemoteDateSource _storeRemoteDataSource;

  StoreRepoImpl({required StoreRemoteDateSource storeRemoteDataSource})
    : _storeRemoteDataSource = storeRemoteDataSource;
  @override
  Future<Either<Failure, ProductFeedEntity>> getProducts(int page) async {
    try {
      final result = await _storeRemoteDataSource.getProducts(page);
      return right(result);
    } on AppException catch (e) {
      return left(mapExceptionToFailure(e));
    } catch (_) {
      return left(UnknownFailure());
    }
  }
}
