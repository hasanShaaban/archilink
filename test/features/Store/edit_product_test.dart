import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Store/data/data_source/store_remote_date_cource_impl.dart';
import 'package:archilink/features/Store/data/repo/store_repo_impl.dart';
import 'package:archilink/features/Store/domain/data_source/store_remote_date_source.dart';
import 'package:archilink/features/Store/domain/entity/edit_product_params.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_store_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class MockApiServiceForEdit implements ApiService {
  String? lastPatchedPath;
  dynamic lastPatchedBody;
  Response<dynamic>? patchResponse;
  DioException? patchException;

  @override
  Dio get dio => throw UnimplementedError();

  @override
  Future<Response<T>> patch<T>(String path, {dynamic body}) async {
    lastPatchedPath = path;
    lastPatchedBody = body;
    if (patchException != null) {
      throw patchException!;
    }
    return patchResponse as Response<T>;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeStoreRemoteDataSourceForEdit implements StoreRemoteDateSource {
  EditProductParams? lastEditedParams;
  bool shouldThrow = false;

  static const dummyProduct = ProductEntity(
    id: 106,
    store: ProductStoreEntity(
      id: 1,
      name: 'Store',
      username: 'store',
    ),
    name: 'Edited Name',
    description: 'Edited Desc',
    price: 30.0,
    quantityInStock: 5,
    sku: 'SKU-106',
    status: 'available',
    categories: [],
  );

  @override
  Future<ProductEntity> editProduct(EditProductParams params) async {
    lastEditedParams = params;
    if (shouldThrow) {
      throw ServerException(message: 'Failed to update product');
    }
    return dummyProduct;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('StoreRemoteDataSourceImpl.editProduct', () {
    late MockApiServiceForEdit mockApiService;
    late StoreRemoteDataSourceImpl dataSource;

    setUp(() {
      mockApiService = MockApiServiceForEdit();
      dataSource = StoreRemoteDataSourceImpl(apiService: mockApiService);
    });

    test('successfully sends PATCH to store/products/{id} with nullable fields', () async {
      mockApiService.patchResponse = Response(
        requestOptions: RequestOptions(path: 'store/products/106'),
        statusCode: 200,
        data: {
          'status': 'success',
          'message': 'Product updated successfully',
          'data': {
            'id': 106,
            'name': 'Wireless Mouse V2',
            'description': 'Updated mouse description',
            'price': 29.99,
            'quantity_in_stock': 15,
            'image_url': null,
            'categories': [],
            'media_items': [],
            'sku': 'SKU-WM-002',
            'status': 'available',
            'store': {
              'id': 1,
              'name': 'Test Store',
              'handle': 'test_store',
              'is_active': true,
              'followers_count': 0,
            },
          },
        },
      );

      const params = EditProductParams(
        id: 106,
        name: 'Wireless Mouse V2',
        price: 29.99,
        description: 'Updated mouse description',
        quantityInStock: 15,
        status: 'available',
      );

      final result = await dataSource.editProduct(params);

      expect(mockApiService.lastPatchedPath, 'store/products/106');
      expect(result.id, 106);
      expect(result.name, 'Wireless Mouse V2');
      expect(result.price, 29.99);
      expect(result.quantityInStock, 15);
      expect(result.status, 'available');
    });

    test('handles status success with null data', () async {
      mockApiService.patchResponse = Response(
        requestOptions: RequestOptions(path: 'store/products/106'),
        statusCode: 200,
        data: {
          'status': 'success',
          'message': 'Product updated successfully',
        },
      );

      const params = EditProductParams(
        id: 106,
        name: 'Updated Name',
        price: 45.0,
      );

      final result = await dataSource.editProduct(params);

      expect(result.id, 106);
      expect(result.name, 'Updated Name');
      expect(result.price, 45.0);
    });

    test('throws ServerException when status is not success', () async {
      mockApiService.patchResponse = Response(
        requestOptions: RequestOptions(path: 'store/products/106'),
        statusCode: 422,
        data: {
          'status': 'error',
          'message': 'Invalid product data',
        },
      );

      const params = EditProductParams(id: 106, name: 'Invalid');

      expect(
        () => dataSource.editProduct(params),
        throwsA(isA<ServerException>().having(
          (e) => e.message,
          'message',
          'Invalid product data',
        )),
      );
    });

    test('throws AppException on DioException', () async {
      mockApiService.patchException = DioException(
        requestOptions: RequestOptions(path: 'store/products/106'),
        type: DioExceptionType.badResponse,
      );

      const params = EditProductParams(id: 106);

      expect(
        () => dataSource.editProduct(params),
        throwsA(isA<AppException>()),
      );
    });
  });

  group('StoreRepoImpl.editProduct', () {
    late FakeStoreRemoteDataSourceForEdit fakeDataSource;
    late StoreRepoImpl repo;

    setUp(() {
      fakeDataSource = FakeStoreRemoteDataSourceForEdit();
      repo = StoreRepoImpl(storeRemoteDataSource: fakeDataSource);
    });

    test('returns right(ProductEntity) on success', () async {
      const params = EditProductParams(
        id: 106,
        name: 'New Name',
      );

      final result = await repo.editProduct(params);

      expect(result.isRight(), isTrue);
      expect(fakeDataSource.lastEditedParams, params);
      result.fold(
        (_) => fail('Expected success'),
        (product) => expect(product.id, 106),
      );
    });

    test('returns left(Failure) on exception', () async {
      fakeDataSource.shouldThrow = true;

      const params = EditProductParams(id: 106);

      final result = await repo.editProduct(params);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, 'Failed to update product'),
        (_) => fail('Expected failure'),
      );
    });
  });
}
