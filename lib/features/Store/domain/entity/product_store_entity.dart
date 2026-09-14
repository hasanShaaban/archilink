import 'package:equatable/equatable.dart';

class ProductStoreEntity extends Equatable {
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

  const ProductStoreEntity({
    required this.id,
    required this.name,
    required this.handle,
    this.description,
    this.city,
    this.country,
    this.storeLogoUrl,
    this.storeBannerUrl,
    this.isActive = true,
    this.followersCount = 0,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    handle,
    description,
    city,
    country,
    storeLogoUrl,
    storeBannerUrl,
    isActive,
    followersCount,
  ];
}
