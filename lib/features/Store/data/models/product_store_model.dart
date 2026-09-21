import 'package:archilink/features/Store/domain/entity/product_store_entity.dart';

class ProductStoreModel {
  final int id;
  final String name;
  final String username;
  final String? role;
  final bool? isVerified;
  final String? avatar;
  final String? country;
  final String? city;

  const ProductStoreModel({
    required this.id,
    required this.name,
    required this.username,
    this.role,
    this.isVerified,
    this.avatar,
    this.country,
    this.city,
  });

  factory ProductStoreModel.fromJson(Map<String, dynamic> json) {
    return ProductStoreModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      username: (json['username'] ?? json['handle'] ?? '') as String,
      role: json['role'] as String?,
      isVerified: json['is_verified'] as bool?,
      avatar: json['avatar'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      if (role != null) 'role': role,
      if (isVerified != null) 'is_verified': isVerified,
      if (avatar != null) 'avatar': avatar,
      if (country != null) 'country': country,
      if (city != null) 'city': city,
    };
  }

  ProductStoreEntity toEntity() {
    return ProductStoreEntity(
      id: id,
      name: name,
      username: username,
      role: role,
      isVerified: isVerified,
      avatar: avatar,
      country: country,
      city: city,
    );
  }
}
