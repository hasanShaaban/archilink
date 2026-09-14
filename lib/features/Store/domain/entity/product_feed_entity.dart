import 'package:archilink/features/Post/domain/entity/pagination_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:equatable/equatable.dart';

class ProductFeedEntity extends Equatable {
  final List<ProductEntity> products;
  final PaginationEntity pagination;

  const ProductFeedEntity({
    required this.products,
    required this.pagination,
  });

  @override
  List<Object?> get props => [products, pagination];
}
