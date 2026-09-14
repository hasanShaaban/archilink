import 'package:archilink/features/Post/domain/entity/media_item_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_category_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_store_entity.dart';
import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int id;
  final ProductStoreEntity store;
  final String name;
  final String description;
  final double price;
  final int quantityInStock;
  final String? imageUrl;
  final List<ProductCategoryEntity> categories;
  final List<MediaItemEntity> mediaItems;
  final String sku;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String currency;

  const ProductEntity({
    required this.id,
    required this.store,
    required this.name,
    required this.description,
    required this.price,
    required this.quantityInStock,
    this.imageUrl,
    this.categories = const [],
    this.mediaItems = const [],
    required this.sku,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.currency = '\$',
  });

  /// UI convenience getters
  String get storeName => store.handle.isNotEmpty ? store.handle : store.name;

  String get formattedStatus {
    switch (status.toLowerCase()) {
      case 'coming_soon':
        return 'Coming Soon';
      case 'out_of_stock':
        return 'Out of Stock';
      case 'available':
        return 'Available';
      case 'pending':
        return 'Pending';
      default:
        return status
            .replaceAll('_', ' ')
            .split(' ')
            .map((word) => word.isNotEmpty
                ? '${word[0].toUpperCase()}${word.substring(1)}'
                : '')
            .join(' ');
    }
  }

  String get location {
    final city = store.city;
    final country = store.country;
    if (city != null && country != null && city.isNotEmpty && country.isNotEmpty) {
      return '$city,$country';
    } else if (city != null && city.isNotEmpty) {
      return city;
    } else if (country != null && country.isNotEmpty) {
      return country;
    }
    return 'Homs,Syria';
  }

  List<String> get images {
    final list = <String>[];
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      list.add(imageUrl!);
    }
    for (final media in mediaItems) {
      if (media.urls.original.isNotEmpty) {
        list.add(media.urls.original);
      } else if (media.urls.feed.isNotEmpty) {
        list.add(media.urls.feed);
      }
    }
    return list;
  }

  @override
  List<Object?> get props => [
    id,
    store,
    name,
    description,
    price,
    quantityInStock,
    imageUrl,
    categories,
    mediaItems,
    sku,
    status,
    createdAt,
    updatedAt,
    currency,
  ];

  static List<ProductEntity> get dummyProducts => const [
    ProductEntity(
      id: 92,
      store: ProductStoreEntity(
        id: 1,
        name: 'Test User',
        handle: 'testUser4',
        storeLogoUrl: 'https://example.com/logo.png',
        storeBannerUrl: 'https://example.com/banner.png',
        isActive: true,
        followersCount: 0,
      ),
      name: 'Item Name',
      description: 'Durable wood with single metal...',
      price: 10.00,
      quantityInStock: 51,
      sku: '2239187629300',
      status: 'coming_soon',
      currency: '\$',
    ),
    ProductEntity(
      id: 66,
      store: ProductStoreEntity(
        id: 1,
        name: 'Test User',
        handle: 'minimal_craft',
        city: 'Homs',
        country: 'Syria',
        isActive: true,
        followersCount: 12,
      ),
      name: 'cum et animi',
      description: 'Aut voluptate minus est et. Non quia hic ut repellat quam.',
      price: 949.07,
      quantityInStock: 56,
      sku: '4656719312147',
      status: 'out_of_stock',
      currency: '\$',
    ),
    ProductEntity(
      id: 67,
      store: ProductStoreEntity(
        id: 1,
        name: 'Test User',
        handle: 'studio_clay',
        city: 'Damascus',
        country: 'Syria',
        isActive: true,
        followersCount: 45,
      ),
      name: 'sit minima laboriosam',
      description: 'Dolore voluptatibus sed nulla rerum assumenda tempora.',
      price: 782.20,
      quantityInStock: 39,
      sku: '5559675393191',
      status: 'pending',
      currency: '\$',
    ),
    ProductEntity(
      id: 84,
      store: ProductStoreEntity(
        id: 1,
        name: 'Test User',
        handle: 'lumina_arch',
        city: 'Latakia',
        country: 'Syria',
        isActive: true,
        followersCount: 30,
      ),
      name: 'qui id et',
      description: 'Ipsam dicta quo voluptate est libero. Sunt et eveniet.',
      price: 285.72,
      quantityInStock: 61,
      sku: '5337767773287',
      status: 'available',
      currency: '\$',
    ),
    ProductEntity(
      id: 93,
      store: ProductStoreEntity(
        id: 1,
        name: 'Test User',
        handle: 'urban_craft',
        city: 'Homs',
        country: 'Syria',
        isActive: true,
        followersCount: 8,
      ),
      name: 'qui impedit officiis',
      description: 'Deleniti et nostrum sapiente quia eveniet doloremque ut.',
      price: 215.22,
      quantityInStock: 13,
      sku: '0270883880093',
      status: 'coming_soon',
      currency: '\$',
    ),
    ProductEntity(
      id: 83,
      store: ProductStoreEntity(
        id: 1,
        name: 'Test User',
        handle: 'archi_tools',
        city: 'Aleppo',
        country: 'Syria',
        isActive: true,
        followersCount: 95,
      ),
      name: 'iusto dolores beatae',
      description: 'Officiis vel eligendi vel nobis quibusdam. Dolor enim.',
      price: 944.52,
      quantityInStock: 11,
      sku: '1568460923639',
      status: 'available',
      currency: '\$',
    ),
  ];
}
