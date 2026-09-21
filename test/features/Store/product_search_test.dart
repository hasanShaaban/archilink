import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Post/domain/entity/pagination_entity.dart';
import 'package:archilink/features/Store/data/data_source/store_remote_date_cource_impl.dart';
import 'package:archilink/features/Store/data/repo/store_repo_impl.dart';
import 'package:archilink/features/Store/domain/data_source/store_remote_date_source.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_feed_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_store_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class MockApiServiceForSearch implements ApiService {
  String? lastPath;
  dynamic lastBody;
  Response<dynamic>? postResponse;
  DioException? postException;

  @override
  Dio get dio => throw UnimplementedError();

  @override
  Future<Response<T>> post<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    lastPath = path;
    lastBody = body;
    if (postException != null) {
      throw postException!;
    }
    return postResponse as Response<T>;
  }

  String? lastGetPath;
  Response<dynamic>? getResponse;

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    lastGetPath = path;
    return getResponse as Response<T>;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeStoreRemoteDataSourceForSearch implements StoreRemoteDateSource {
  String? lastQuery;
  String? lastMinPrice;
  String? lastMaxPrice;
  int? lastPage;
  bool shouldThrow = false;

  static const dummyProduct = ProductEntity(
    id: 53,
    store: ProductStoreEntity(
      id: 1,
      name: 'Test User',
      username: 'testUser4',
    ),
    name: 'Wireless Keyboard',
    description: 'Ergonomic wireless Keyboard with USB receiver',
    price: 49.99,
    quantityInStock: 150,
    sku: '3380260490856',
    status: 'out_of_stock',
  );

  @override
  Future<ProductFeedEntity> searchProducts({
    String? query,
    String? minPrice,
    String? maxPrice,
    int page = 1,
  }) async {
    lastQuery = query;
    lastMinPrice = minPrice;
    lastMaxPrice = maxPrice;
    lastPage = page;

    if (shouldThrow) {
      throw ServerException(message: 'Search failed');
    }

    return const ProductFeedEntity(
      products: [dummyProduct],
      pagination: PaginationEntity(
        currentPage: 1,
        perPage: 20,
        lastPage: 1,
        total: 1,
        hasMore: false,
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final sampleSearchResponseData = {
    'status': 'success',
    'message': 'Success',
    'data': {
      'products': [
        {
          'id': 53,
          'store': {
            'id': 1,
            'name': 'Test User',
            'handle': 'testUser4',
            'description': "it's not for nothing, feeling something, \nyou know everybody cry, cry, cry, cry",
            'city': 'homs',
            'country': 'syria',
            'store_logo_url': 'https://res.cloudinary.com/dnsnbfbad/image/upload/v1789614679/wrxjd9hk6snkhehtwizy.jpg',
            'store_banner_url': 'https://res.cloudinary.com/dnsnbfbad/image/upload/v1789612858/rmvmqm35btsgemv4rb2l.jpg',
            'is_active': true,
            'followers_count': 0,
          },
          'name': 'Wireless Keyboard',
          'description': 'Ergonomic wireless Keyboard with USB receiver',
          'price': 49.99,
          'quantity_in_stock': 150,
          'image_url': null,
          'categories': [
            {'id': 1, 'name': 'Fugiat', 'slug': 'fugiat'},
            {'id': 3, 'name': 'Tempore', 'slug': 'tempore'},
          ],
          'media_items': [],
          'sku': '3380260490856',
          'status': 'out_of_stock',
          'created_at': '2026-09-13',
          'updated_at': '2026-09-18',
        },
        {
          'id': 57,
          'store': {
            'id': 1,
            'name': 'Test User',
            'handle': 'testUser4',
            'description': "it's not for nothing, feeling something, \nyou know everybody cry, cry, cry, cry",
            'city': 'homs',
            'country': 'syria',
            'store_logo_url': 'https://res.cloudinary.com/dnsnbfbad/image/upload/v1789614679/wrxjd9hk6snkhehtwizy.jpg',
            'store_banner_url': 'https://res.cloudinary.com/dnsnbfbad/image/upload/v1789612858/rmvmqm35btsgemv4rb2l.jpg',
            'is_active': true,
            'followers_count': 0,
          },
          'name': 'nostrum fugiat itaque',
          'description': 'Possimus in et laboriosam praesentium impedit at quis. Dolorem excepturi quod nihil ipsam inventore.',
          'price': 170.11,
          'quantity_in_stock': 61,
          'image_url': null,
          'categories': [
            {'id': 6, 'name': 'Esse', 'slug': 'esse'},
            {'id': 58, 'name': 'Minus', 'slug': 'minus'},
            {'id': 84, 'name': 'Sunt', 'slug': 'sunt'},
          ],
          'media_items': [],
          'sku': '2959171218838',
          'status': 'out_of_stock',
          'created_at': '2026-09-13',
          'updated_at': '2026-09-13',
        }
      ],
      'pagination': {
        'current_page': 1,
        'per_page': 20,
        'last_page': 1,
        'total': 10,
        'has_more': false,
        'next': null,
        'prev': null,
      },
    },
  };

  group('StoreRemoteDataSourceImpl.searchProducts', () {
    late MockApiServiceForSearch mockApiService;
    late StoreRemoteDataSourceImpl dataSource;

    setUp(() {
      mockApiService = MockApiServiceForSearch();
      dataSource = StoreRemoteDataSourceImpl(apiService: mockApiService);
    });

    test('sends POST to home/search/products with q, min_price, max_price and omits categories', () async {
      mockApiService.postResponse = Response(
        requestOptions: RequestOptions(path: 'home/search/products?page=1'),
        statusCode: 200,
        data: sampleSearchResponseData,
      );

      final result = await dataSource.searchProducts(
        query: 'occaecati ipsa in',
        minPrice: '20.00',
        maxPrice: '120',
        page: 1,
      );

      expect(mockApiService.lastPath, 'home/search/products?page=1');
      expect(mockApiService.lastBody, isA<Map<String, dynamic>>());
      final body = mockApiService.lastBody as Map<String, dynamic>;
      expect(body['q'], 'occaecati ipsa in');
      expect(body['min_price'], '20.00');
      expect(body['max_price'], '120');
      // categories field must be ignored for now due to backend bug
      expect(body.containsKey('categories'), false);

      expect(result.products.length, 2);
      expect(result.products[0].id, 53);
      expect(result.products[0].name, 'Wireless Keyboard');
      expect(result.products[0].price, 49.99);
      expect(result.products[1].id, 57);
      expect(result.pagination.currentPage, 1);
      expect(result.pagination.total, 10);
      expect(result.pagination.hasMore, false);
    });

    test('throws ServerException on null or invalid response data', () async {
      mockApiService.postResponse = Response(
        requestOptions: RequestOptions(path: 'home/search/products?page=1'),
        statusCode: 200,
        data: null,
      );

      expect(
        () => dataSource.searchProducts(query: 'test'),
        throwsA(isA<ServerException>()),
      );
    });

    test('throws AppException on DioException', () async {
      mockApiService.postException = DioException(
        requestOptions: RequestOptions(path: 'home/search/products?page=1'),
        type: DioExceptionType.connectionTimeout,
      );

      expect(
        () => dataSource.searchProducts(query: 'test'),
        throwsA(isA<AppException>()),
      );
    });

    test('falls back to getProducts when query is empty or null and never calls search endpoint', () async {
      mockApiService.getResponse = Response(
        requestOptions: RequestOptions(path: 'home/product-feed?page=1'),
        statusCode: 200,
        data: {
          'data': sampleSearchResponseData['data'],
        },
      );

      final result = await dataSource.searchProducts(
        query: '   ',
        page: 1,
      );

      expect(mockApiService.lastGetPath, 'home/product-feed?page=1');
      expect(mockApiService.lastPath, isNull);
      expect(result.products.length, 2);
    });
  });

  group('StoreRepoImpl.searchProducts', () {
    late FakeStoreRemoteDataSourceForSearch fakeDataSource;
    late StoreRepoImpl repo;

    setUp(() {
      fakeDataSource = FakeStoreRemoteDataSourceForSearch();
      repo = StoreRepoImpl(storeRemoteDataSource: fakeDataSource);
    });

    test('returns right(ProductFeedEntity) on success', () async {
      final result = await repo.searchProducts(
        query: 'Wireless',
        minPrice: '20.00',
        maxPrice: '120',
        page: 1,
      );

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should succeed'),
        (feed) {
          expect(feed.products.length, 1);
          expect(feed.products.first.name, 'Wireless Keyboard');
        },
      );
      expect(fakeDataSource.lastQuery, 'Wireless');
      expect(fakeDataSource.lastMinPrice, '20.00');
      expect(fakeDataSource.lastMaxPrice, '120');
      expect(fakeDataSource.lastPage, 1);
    });

    test('returns left(Failure) on exception', () async {
      fakeDataSource.shouldThrow = true;

      final result = await repo.searchProducts(query: 'fail');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Search failed'),
        (feed) => fail('Should fail'),
      );
    });
  });
}
