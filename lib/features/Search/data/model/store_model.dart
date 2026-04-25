import 'package:archilink/features/Search/domain/entity/store_entity.dart';

class StoreModel extends StoreEntity {
  const StoreModel({
    required super.id,
    required super.name,
    required super.handle,
    super.description,
    super.city,
    super.country,
    super.storeLogoUrl,
    required super.isActive,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] as int,
      name: json['name'] as String,
      handle: json['handle'] as String,
      description: json['description'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      storeLogoUrl: json['store_logo_url'] as String? ,
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'handle': handle,
        'description': description,
        'city': city,
        'country': country,
        'store_logo_url': storeLogoUrl,
        'is_active': isActive,
      };
}