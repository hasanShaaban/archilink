import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Store/domain/entity/category_feed_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_feed_entity.dart';
import 'package:dartz/dartz.dart';

abstract class StoreRepo {
  Future<Either<Failure, ProductFeedEntity>> getProducts(int page);
  Future<Either<Failure, CategoryFeedEntity>> getCategories({int page = 1});
}
