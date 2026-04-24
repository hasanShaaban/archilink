class StoreEntity {
  final int id;
  final String name;
  final String handle;
  final String? description;
  final String? city;
  final String? country;
  final String storeLogoUrl;
  final bool isActive;

  const StoreEntity({
    required this.id,
    required this.name,
    required this.handle,
    this.description,
    this.city,
    this.country,
    required this.storeLogoUrl,
    required this.isActive,
  });
}