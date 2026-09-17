import 'package:archilink/features/Store/domain/entity/product_category_entity.dart';

class ProductCategoryModel {
  final int id;
  final String name;
  final String slug;
  final int productsCount;
  final String? description;
  final bool isActive;

  const ProductCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.productsCount = 0,
    this.description,
    this.isActive = true,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      productsCount: json['products_count'] as int? ?? 0,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'products_count': productsCount,
      'description': description,
      'is_active': isActive,
    };
  }

  ProductCategoryEntity toEntity() {
    return ProductCategoryEntity(
      id: id,
      name: name,
      slug: slug,
      productsCount: productsCount,
      description: description,
      isActive: isActive,
    );
  }
}
