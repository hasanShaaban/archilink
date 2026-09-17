import 'package:archilink/features/Post/data/models/pagination_model.dart';
import 'package:archilink/features/Store/data/models/product_category_model.dart';
import 'package:archilink/features/Store/domain/entity/category_feed_entity.dart';

class CategoryFeedModel {
  final List<ProductCategoryModel> categories;
  final PaginationModel pagination;

  const CategoryFeedModel({
    required this.categories,
    required this.pagination,
  });

  factory CategoryFeedModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> source = json;
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      source = json['data'] as Map<String, dynamic>;
    }

    final rawList = source['data'] as List? ?? (source['categories'] as List? ?? []);
    final categories = rawList
        .whereType<Map<String, dynamic>>()
        .map(ProductCategoryModel.fromJson)
        .toList();

    final paginationMap = source['pagination'] as Map<String, dynamic>?;
    final PaginationModel pagination;
    if (paginationMap != null) {
      final currentPage = paginationMap['current_page'] as int? ?? 1;
      final lastPage = paginationMap['last_page'] as int? ?? 1;
      final hasMore = paginationMap['has_more'] as bool? ?? (currentPage < lastPage);

      pagination = PaginationModel(
        currentPage: currentPage,
        perPage: paginationMap['per_page'] as int? ?? categories.length,
        lastPage: lastPage,
        total: paginationMap['total'] as int? ?? categories.length,
        hasMore: hasMore,
        next: paginationMap['next'] as String?,
        prev: paginationMap['prev'] as String?,
      );
    } else {
      pagination = PaginationModel(
        currentPage: 1,
        perPage: categories.length,
        lastPage: 1,
        total: categories.length,
        hasMore: false,
      );
    }

    return CategoryFeedModel(
      categories: categories,
      pagination: pagination,
    );
  }

  CategoryFeedEntity toEntity() {
    return CategoryFeedEntity(
      categories: categories.map((c) => c.toEntity()).toList(),
      pagination: pagination.toEntity(),
    );
  }
}
