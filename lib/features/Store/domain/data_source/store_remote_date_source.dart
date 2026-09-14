import 'package:archilink/features/Store/domain/entity/product_feed_entity.dart';

abstract class StoreRemoteDateSource {
  Future<ProductFeedEntity> getProducts(int page);
}
