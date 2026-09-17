import 'package:archilink/features/Post/domain/entity/pagination_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_category_entity.dart';
import 'package:equatable/equatable.dart';

class CategoryFeedEntity extends Equatable {
  final List<ProductCategoryEntity> categories;
  final PaginationEntity pagination;

  const CategoryFeedEntity({
    required this.categories,
    required this.pagination,
  });

  @override
  List<Object?> get props => [categories, pagination];
}
