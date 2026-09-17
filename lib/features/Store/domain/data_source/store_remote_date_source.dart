import 'package:archilink/features/Store/domain/entity/category_feed_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_feed_entity.dart';

abstract class StoreRemoteDateSource {
  Future<ProductFeedEntity> getProducts(int page);
  Future<CategoryFeedEntity> getCategories({int page = 1});
}

