import 'package:archilink/features/Store/domain/entity/add_product_params.dart';
import 'package:archilink/features/Store/domain/entity/category_feed_entity.dart';
import 'package:archilink/features/Store/domain/entity/edit_product_params.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_feed_entity.dart';

abstract class StoreRemoteDateSource {
  Future<ProductFeedEntity> getProducts(int page);
  Future<CategoryFeedEntity> getCategories({int page = 1});
  Future<ProductEntity> addProduct(AddProductParams params);
  Future<ProductEntity> editProduct(EditProductParams params);
  Future<bool> deleteProduct(int id);
  Future<ProductFeedEntity> searchProducts({
    String? query,
    String? status,
    String? minPrice,
    String? maxPrice,
    List<int>? categories,
    int page = 1,
  });
}
