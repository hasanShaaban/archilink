import 'package:archilink/features/Store/domain/entity/product_store_entity.dart';

class ProductStoreModel {
  final int id;
  final String name;
  final String handle;
  final String? description;
  final String? city;
  final String? country;
  final String? storeLogoUrl;
  final String? storeBannerUrl;
  final bool isActive;
  final int followersCount;

  const ProductStoreModel({
    required this.id,
    required this.name,
    required this.handle,
    this.description,
    this.city,
    this.country,
    this.storeLogoUrl,
    this.storeBannerUrl,
    required this.isActive,
    required this.followersCount,
  });

  factory ProductStoreModel.fromJson(Map<String, dynamic> json) {
    return ProductStoreModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      handle: json['handle'] as String? ?? '',
      description: json['description'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      storeLogoUrl: json['store_logo_url'] as String?,
      storeBannerUrl: json['store_banner_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      followersCount: json['followers_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'handle': handle,
      'description': description,
      'city': city,
      'country': country,
      'store_logo_url': storeLogoUrl,
      'store_banner_url': storeBannerUrl,
      'is_active': isActive,
      'followers_count': followersCount,
    };
  }

  ProductStoreEntity toEntity() {
    return ProductStoreEntity(
      id: id,
      name: name,
      handle: handle,
      description: description,
      city: city,
      country: country,
      storeLogoUrl: storeLogoUrl,
      storeBannerUrl: storeBannerUrl,
      isActive: isActive,
      followersCount: followersCount,
    );
  }
}
