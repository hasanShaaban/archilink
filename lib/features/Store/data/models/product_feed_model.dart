import 'package:archilink/features/Post/data/models/pagination_model.dart';
import 'package:archilink/features/Store/data/models/product_model.dart';
import 'package:archilink/features/Store/domain/entity/product_feed_entity.dart';

class ProductFeedModel {
  final String status;
  final String message;
  final List<ProductModel> products;
  final PaginationModel pagination;

  const ProductFeedModel({
    this.status = 'success',
    this.message = '',
    required this.products,
    required this.pagination,
  });

  factory ProductFeedModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data;
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      data = json['data'] as Map<String, dynamic>;
    } else {
      data = json;
    }

    final productsList = (data['products'] as List?)
            ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final paginationData = data['pagination'] as Map<String, dynamic>? ?? {};

    return ProductFeedModel(
      status: json['status'] as String? ?? 'success',
      message: json['message'] as String? ?? '',
      products: productsList,
      pagination: PaginationModel.fromJson(paginationData),
    );
  }

  ProductFeedEntity toEntity() {
    return ProductFeedEntity(
      products: products.map((e) => e.toEntity()).toList(),
      pagination: pagination.toEntity(),
    );
  }
}
