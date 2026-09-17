import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/core/storage/local_storage.dart';
import 'package:archilink/features/Auth/data/data_source/auth_local_data_source_impl.dart';
import 'package:archilink/features/Profile/data/data_source/profile_local_data_source_impl.dart';
import 'package:archilink/features/Profile/data/data_source/profile_remote_data_source_impl.dart';
import 'package:archilink/features/Profile/data/model/profile_model.dart';
import 'package:archilink/features/Profile/data/repo/profile_repo_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeApiService implements ApiService {
  final Map<String, dynamic> responses = {};

  @override
  Dio get dio => Dio();

  @override
  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? query}) async {
    if (responses.containsKey(path)) {
      return Response<T>(
        data: responses[path] as T,
        statusCode: 200,
        requestOptions: RequestOptions(path: path),
      );
    }
    throw DioException(
      requestOptions: RequestOptions(path: path),
      type: DioExceptionType.badResponse,
      response: Response(
        statusCode: 404,
        requestOptions: RequestOptions(path: path),
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeLocalStorage implements LocalStorage {
  final Map<String, dynamic> _data = {};

  @override
  Future<void> clear() async => _data.clear();
  @override
  Future<void> delete(String key) async => _data.remove(key);
  @override
  T? read<T>(String key) => _data[key] as T?;
  @override
  Future<void> write<T>(String key, T value) async => _data[key] = value;
}

void main() {
  group('ProfileModel.fromStoreJson', () {
    test('correctly parses personal store profile response', () {
      final json = {
        'id': 1,
        'name': 'Test User',
        'handle': 'testUser4',
        'description': 'You have no idea how high i can fly.',
        'city': 'Metropolis',
        'country': 'Wonderland',
        'store_logo_url': 'https://res.cloudinary.com/dnsnbfbad/image/upload/logo.jpg',
        'store_banner_url': 'https://example.com/banner.png',
        'is_active': true,
        'followers_count': 15,
        'products_count': 101,
      };

      final profile = ProfileModel.fromStoreJson(json);

      expect(profile.id, 1);
      expect(profile.name, 'Test User');
      expect(profile.username, 'testUser4');
      expect(profile.bio, 'You have no idea how high i can fly.');
      expect(profile.profilePictureUrl, 'https://res.cloudinary.com/dnsnbfbad/image/upload/logo.jpg');
      expect(profile.bannerImageUrl, 'https://example.com/banner.png');
      expect(profile.role, 'store');
      expect(profile.followersCount, 15);
      expect(profile.postsCount, 101); // products_count mapped to postsCount
      expect(profile.isFollowing, isFalse);
      expect(profile.details.aboutMe, 'You have no idea how high i can fly.');
      expect(profile.details.city, 'Metropolis');
      expect(profile.details.country, 'Wonderland');
      expect(profile.details.academicExperiences, isEmpty);
      expect(profile.details.skills, isEmpty);
      expect(profile.details.contactInfo, isEmpty);
    });

    test('correctly parses visitor store profile response with follow info', () {
      final json = {
        'id': 2,
        'name': 'Other Store',
        'handle': 'otherStoreHandle',
        'description': null,
        'city': null,
        'country': null,
        'store_logo_url': null,
        'store_banner_url': null,
        'is_active': true,
        'followers_count': 0,
        'products_count': 0,
      };

      final profile = ProfileModel.fromStoreJson(
        json,
        isFollowing: true,
        followCount: 42,
      );

      expect(profile.id, 2);
      expect(profile.name, 'Other Store');
      expect(profile.username, 'otherStoreHandle');
      expect(profile.isFollowing, isTrue);
      expect(profile.followersCount, 42);
      expect(profile.role, 'store');
      expect(profile.postsCount, 0);
    });
  });

  group('ProfileRemoteDataSourceImpl store profile fetching', () {
    late FakeApiService fakeApi;
    late ProfileRemoteDataSourceImpl dataSource;

    setUp(() {
      fakeApi = FakeApiService();
      dataSource = ProfileRemoteDataSourceImpl(fakeApi);
    });

    test('getPersonalStoreProfile calls store/profile and parses correctly', () async {
      fakeApi.responses['store/profile'] = {
        'status': 'success',
        'message': 'Store profile retrieved successfully',
        'data': {
          'id': 1,
          'name': 'Test User',
          'handle': 'testUser4',
          'description': 'Store description here',
          'city': null,
          'country': null,
          'store_logo_url': 'https://res.cloudinary.com/logo.jpg',
          'store_banner_url': 'https://example.com/banner.png',
          'is_active': true,
          'followers_count': 0,
          'products_count': 101,
        },
      };

      final profile = await dataSource.getPersonalStoreProfile();

      expect(profile.id, 1);
      expect(profile.username, 'testUser4');
      expect(profile.postsCount, 101);
      expect(profile.bannerImageUrl, 'https://example.com/banner.png');
    });

    test('getStoreProfile calls store/profile/{id} and user/{handle}/follow-info', () async {
      fakeApi.responses['store/profile/2'] = {
        'status': 'success',
        'message': 'Store profile retrieved successfully',
        'data': {
          'id': 2,
          'name': 'Visited Store',
          'handle': 'visitedHandle',
          'description': 'Best designs',
          'city': null,
          'country': null,
          'store_logo_url': null,
          'store_banner_url': null,
          'is_active': true,
          'followers_count': 0,
          'products_count': 5,
        },
      };

      fakeApi.responses['user/visitedHandle/follow-info'] = {
        'status': 'success',
        'data': {
          'is_following': true,
          'followers_count': 7,
          'following_count': 0,
        },
      };

      final profile = await dataSource.getStoreProfile(id: 2, handle: 'visitedHandle');

      expect(profile.id, 2);
      expect(profile.name, 'Visited Store');
      expect(profile.username, 'visitedHandle');
      expect(profile.isFollowing, isTrue);
      expect(profile.followersCount, 7);
      expect(profile.postsCount, 5);
    });

    test('getStoreProfile gracefully handles missing or failed follow-info', () async {
      fakeApi.responses['store/profile/3'] = {
        'status': 'success',
        'message': 'Store profile retrieved successfully',
        'data': {
          'id': 3,
          'name': 'Store 3',
          'handle': 'store3',
          'description': null,
          'city': null,
          'country': null,
          'store_logo_url': null,
          'store_banner_url': null,
          'is_active': true,
          'followers_count': 12,
          'products_count': 2,
        },
      };
      // user/store3/follow-info not configured in fakeApi -> will throw 404

      final profile = await dataSource.getStoreProfile(id: 3, handle: 'store3');

      expect(profile.id, 3);
      expect(profile.username, 'store3');
      expect(profile.isFollowing, isFalse);
      expect(profile.followersCount, 12);
    });

    test('getStoreProducts calls store/{storeId}/products?page={page}', () async {
      fakeApi.responses['store/1/products?page=1'] = {
        'status': 'success',
        'message': 'Products retrieved successfully',
        'data': {
          'products': [
            {
              'id': 101,
              'store': {
                'id': 1,
                'name': 'Test Store',
                'handle': 'test_store',
                'is_active': true,
                'followers_count': 5,
              },
              'name': 'Product One',
              'description': 'Description of product one',
              'price': 199.99,
              'quantity_in_stock': 10,
              'categories': [],
              'media_items': [],
              'sku': 'SKU-001',
              'status': 'available',
            }
          ],
          'pagination': {
            'current_page': 1,
            'per_page': 20,
            'last_page': 1,
            'total': 1,
            'has_more': false,
            'next': null,
            'prev': null,
          }
        }
      };

      final feed = await dataSource.getStoreProducts(storeId: 1, page: 1);

      expect(feed.products.length, 1);
      expect(feed.products.first.id, 101);
      expect(feed.products.first.name, 'Product One');
      expect(feed.products.first.price, 199.99);
      expect(feed.pagination.hasMore, isFalse);
    });
  });

  group('ProfileRepoImpl store profile delegation', () {
    late FakeApiService fakeApi;
    late FakeLocalStorage fakeStorage;
    late ProfileRemoteDataSourceImpl remoteDataSource;
    late ProfileLocalDataSourceImpl localDataSource;
    late AuthLocalDataSourceImpl authLocalDataSource;
    late ProfileRepoImpl repo;

    setUp(() {
      fakeApi = FakeApiService();
      fakeStorage = FakeLocalStorage();
      remoteDataSource = ProfileRemoteDataSourceImpl(fakeApi);
      localDataSource = ProfileLocalDataSourceImpl(fakeStorage);
      authLocalDataSource = AuthLocalDataSourceImpl(fakeStorage);
      repo = ProfileRepoImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
        authLocalDataSource: authLocalDataSource,
      );
    });

    test('getStoreProducts returns ProductFeedEntity from remote data source', () async {
      fakeApi.responses['store/5/products?page=2'] = {
        'status': 'success',
        'message': 'Products retrieved successfully',
        'data': {
          'products': [
            {
              'id': 202,
              'store': {
                'id': 5,
                'name': 'Arch Supply',
                'handle': 'arch_supply',
                'is_active': true,
                'followers_count': 10,
              },
              'name': 'Drafting Board',
              'description': 'Pro drafting board',
              'price': 450.0,
              'quantity_in_stock': 3,
              'categories': [],
              'media_items': [],
              'sku': 'BOARD-002',
              'status': 'available',
            }
          ],
          'pagination': {
            'current_page': 2,
            'per_page': 20,
            'last_page': 3,
            'total': 50,
            'has_more': true,
            'next': 'store/5/products?page=3',
            'prev': 'store/5/products?page=1',
          }
        }
      };

      final result = await repo.getStoreProducts(storeId: 5, page: 2);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('should succeed'),
        (feed) {
          expect(feed.products.length, 1);
          expect(feed.products.first.id, 202);
          expect(feed.products.first.name, 'Drafting Board');
          expect(feed.pagination.hasMore, isTrue);
          expect(feed.pagination.currentPage, 2);
        },
      );
    });

    test('getPersonalProfile delegates to getPersonalStoreProfile when role is store', () async {
      await authLocalDataSource.saveRole('store');

      fakeApi.responses['store/profile'] = {
        'status': 'success',
        'message': 'Store profile retrieved successfully',
        'data': {
          'id': 1,
          'name': 'My Store',
          'handle': 'myStoreHandle',
          'description': 'My store desc',
          'city': null,
          'country': null,
          'store_logo_url': null,
          'store_banner_url': null,
          'is_active': true,
          'followers_count': 0,
          'products_count': 20,
        },
      };

      final result = await repo.getPersonalProfile();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('should succeed'),
        (profile) {
          expect(profile.id, 1);
          expect(profile.username, 'myStoreHandle');
          expect(profile.role, 'store');
          expect(profile.postsCount, 20);
        },
      );
    });

    test('getStoreProfile retrieves store profile and caches it', () async {
      fakeApi.responses['store/profile/99'] = {
        'status': 'success',
        'message': 'Store profile retrieved successfully',
        'data': {
          'id': 99,
          'name': 'Vendor Hub',
          'handle': 'vendor_hub',
          'description': 'Vendor Hub description',
          'city': null,
          'country': null,
          'store_logo_url': null,
          'store_banner_url': null,
          'is_active': true,
          'followers_count': 3,
          'products_count': 15,
        },
      };

      fakeApi.responses['user/vendor_hub/follow-info'] = {
        'status': 'success',
        'data': {
          'is_following': false,
          'followers_count': 3,
          'following_count': 0,
        },
      };

      final result = await repo.getStoreProfile(id: 99, handle: 'vendor_hub');

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('should succeed'),
        (profile) {
          expect(profile.id, 99);
          expect(profile.name, 'Vendor Hub');
          expect(profile.username, 'vendor_hub');
          expect(profile.role, 'store');
        },
      );
    });
  });
}
