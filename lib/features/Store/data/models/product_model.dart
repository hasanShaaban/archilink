import 'package:archilink/features/Post/data/models/media_item_model.dart';
import 'package:archilink/features/Store/data/models/product_category_model.dart';
import 'package:archilink/features/Store/data/models/product_store_model.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';

class ProductModel {
  final int id;
  final ProductStoreModel store;
  final String name;
  final String description;
  final double price;
  final int quantityInStock;
  final String? imageUrl;
  final List<ProductCategoryModel> categories;
  final List<MediaItemModel> mediaItems;
  final String sku;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductModel({
    required this.id,
    required this.store,
    required this.name,
    required this.description,
    required this.price,
    required this.quantityInStock,
    this.imageUrl,
    required this.categories,
    required this.mediaItems,
    required this.sku,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int? ?? 0,
      store: ProductStoreModel.fromJson(
        json['store'] as Map<String, dynamic>? ?? {},
      ),
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantityInStock: json['quantity_in_stock'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
      categories: (json['categories'] as List?)
              ?.map((e) => ProductCategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      mediaItems: (json['media_items'] as List?)
              ?.map((e) => MediaItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      sku: json['sku'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store': store.toJson(),
      'name': name,
      'description': description,
      'price': price,
      'quantity_in_stock': quantityInStock,
      'image_url': imageUrl,
      'categories': categories.map((e) => e.toJson()).toList(),
      'media_items': mediaItems.map((e) => e.toJson()).toList(),
      'sku': sku,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      store: store.toEntity(),
      name: name,
      description: description,
      price: price,
      quantityInStock: quantityInStock,
      imageUrl: imageUrl,
      categories: categories.map((e) => e.toEntity()).toList(),
      mediaItems: mediaItems.map((e) => e.toEntity()).toList(),
      sku: sku,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
