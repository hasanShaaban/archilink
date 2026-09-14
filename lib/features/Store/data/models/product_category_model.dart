import 'package:archilink/features/Store/domain/entity/product_category_entity.dart';

class ProductCategoryModel {
  final int id;
  final String name;
  final String slug;

  const ProductCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }

  ProductCategoryEntity toEntity() {
    return ProductCategoryEntity(
      id: id,
      name: name,
      slug: slug,
    );
  }
}
