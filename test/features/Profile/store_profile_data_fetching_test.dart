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
      final raw = responses[path];
      final dynamic body =
          (raw is Map<String, dynamic> && (raw.containsKey('data') || raw.containsKey('status')))
              ? raw
              : {'status': 'success', 'data': raw};
      return Response<T>(
        data: body as T,
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

  group('ProfileRemoteDataSourceImpl store profile fetching via unified endpoint', () {
    late FakeApiService fakeApi;
    late ProfileRemoteDataSourceImpl dataSource;

    setUp(() {
      fakeApi = FakeApiService();
      dataSource = ProfileRemoteDataSourceImpl(fakeApi);
    });

    test('getProfile parses store profile response correctly', () async {
      fakeApi.responses['user/testUser4'] = {
        'name': 'Test User',
        'username': 'testUser4',
        'role': 'store',
        'is_verified': false,
        'is_following': false,
        'details': {
          'profile_picture_url': 'https://example.com/logo.png',
          'store_banner_url': 'https://example.com/banner.png',
          'public_email': 'testUser4@example.com',
          'public_phone_number': '123-456-7890',
          'products_count': 101,
          'followers_count': 0,
          'bio': null,
          'country': null,
          'city': null,
          'website_url': 'https://example.com',
        },
      };

      final profile = await dataSource.getProfile(username: 'testUser4');

      expect(profile.username, 'testUser4');
      expect(profile.role, 'store');
      expect(profile.productsCount, 101);
      expect(profile.bannerImageUrl, 'https://example.com/banner.png');
      expect(profile.publicEmail, 'testUser4@example.com');
    });

    test('getProfile parses non-store (mentor) profile response correctly', () async {
      fakeApi.responses['user/testUser1'] = {
        'name': 'akikon',
        'username': 'testUser1',
        'role': 'mentor',
        'is_verified': false,
        'is_following': false,
        'details': {
          'profile_picture_url': null,
          'followers_count': 0,
          'following_count': 0,
          'bio': 'This is a test user.',
          'privacy_setting': 'public',
          'posts_count': 100,
          'project_count': 0,
          'about_me': 'I am a test user.',
          'academic_experiences': [],
          'contact_info': [],
          'skills': [],
          'country': 'Testland',
          'city': 'Testville',
          'joined_at': '2026-09-20',
        },
      };

      final profile = await dataSource.getProfile(username: 'testUser1');

      expect(profile.username, 'testUser1');
      expect(profile.role, 'mentor');
      expect(profile.followersCount, 0);
      expect(profile.postsCount, 100);
      expect(profile.bio, 'This is a test user.');
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

    test('getPersonalProfile uses stored username to call getUserProfile', () async {
      await authLocalDataSource.saveUsername('myStoreUser');

      fakeApi.responses['user/myStoreUser'] = {
        'name': 'My Store',
        'username': 'myStoreUser',
        'role': 'store',
        'is_verified': false,
        'is_following': false,
        'details': {
          'profile_picture_url': null,
          'store_banner_url': null,
          'public_email': null,
          'public_phone_number': null,
          'products_count': 20,
          'followers_count': 0,
          'bio': null,
          'country': null,
          'city': null,
          'website_url': null,
        },
      };

      final result = await repo.getPersonalProfile();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('should succeed'),
        (profile) {
          expect(profile.username, 'myStoreUser');
          expect(profile.role, 'store');
          expect(profile.productsCount, 20);
        },
      );
    });

    test('getUserProfile retrieves store profile via user/{username} endpoint', () async {
      fakeApi.responses['user/vendor_hub'] = {
        'name': 'Vendor Hub',
        'username': 'vendor_hub',
        'role': 'store',
        'is_verified': false,
        'is_following': false,
        'details': {
          'profile_picture_url': null,
          'store_banner_url': null,
          'public_email': null,
          'public_phone_number': null,
          'products_count': 15,
          'followers_count': 3,
          'bio': null,
          'country': null,
          'city': null,
          'website_url': null,
        },
      };

      final result = await repo.getUserProfile(username: 'vendor_hub');

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('should succeed'),
        (profile) {
          expect(profile.username, 'vendor_hub');
          expect(profile.role, 'store');
          expect(profile.productsCount, 15);
          expect(profile.followersCount, 3);
        },
      );
    });
  });
}
