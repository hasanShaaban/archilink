import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Store/domain/entity/add_product_params.dart';
import 'package:archilink/features/Store/domain/entity/category_feed_entity.dart';
import 'package:archilink/features/Store/domain/entity/edit_product_params.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_feed_entity.dart';
import 'package:dartz/dartz.dart';

abstract class StoreRepo {
  Future<Either<Failure, ProductFeedEntity>> getProducts(int page);
  Future<Either<Failure, CategoryFeedEntity>> getCategories({int page = 1});
  Future<Either<Failure, ProductEntity>> addProduct(AddProductParams params);
  Future<Either<Failure, ProductEntity>> editProduct(EditProductParams params);
  Future<Either<Failure, bool>> deleteProduct(int id);
  Future<Either<Failure, ProductFeedEntity>> searchProducts({
    String? query,
    String? status,
    String? minPrice,
    String? maxPrice,
    List<int>? categories,
    int page = 1,
  });
}

