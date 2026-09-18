import 'package:archilink/core/error/exceptions.dart';
import 'package:archilink/core/error/failure.dart';
import 'package:archilink/core/network/api_service.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_like_cubit.dart';
import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:archilink/features/Store/data/data_source/store_remote_date_cource_impl.dart';
import 'package:archilink/features/Store/data/repo/store_repo_impl.dart';
import 'package:archilink/features/Store/domain/data_source/store_remote_date_source.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_store_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockApiService implements ApiService {
  String? lastDeletedPath;
  Response<dynamic>? deleteResponse;
  DioException? deleteException;

  @override
  Dio get dio => throw UnimplementedError();

  @override
  Future<Response<T>> delete<T>(String path) async {
    lastDeletedPath = path;
    if (deleteException != null) {
      throw deleteException!;
    }
    return deleteResponse as Response<T>;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeStoreRemoteDataSource implements StoreRemoteDateSource {
  int? lastDeletedId;
  bool shouldThrow = false;

  @override
  Future<bool> deleteProduct(int id) async {
    lastDeletedId = id;
    if (shouldThrow) {
      throw ServerException(message: 'Server error');
    }
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockProfileRepoForDelete implements ProfileRepo {
  int? lastDeletedProductId;
  Either<Failure, bool>? deleteResponse;

  @override
  Future<Either<Failure, bool>> deleteProduct(int productId) async {
    lastDeletedProductId = productId;
    return deleteResponse ?? right(true);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakePostLikeCubitForDelete extends Cubit<PostLikeState?>
    implements PostLikeCubit {
  FakePostLikeCubitForDelete() : super(null);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('StoreRemoteDataSourceImpl.deleteProduct', () {
    late MockApiService mockApiService;
    late StoreRemoteDataSourceImpl dataSource;

    setUp(() {
      mockApiService = MockApiService();
      dataSource = StoreRemoteDataSourceImpl(apiService: mockApiService);
    });

    test('successfully sends DELETE to store/products/{id}', () async {
      mockApiService.deleteResponse = Response(
        requestOptions: RequestOptions(path: 'store/products/1'),
        statusCode: 200,
        data: {
          'status': 'success',
          'message': 'Product deleted successfully',
        },
      );

      final result = await dataSource.deleteProduct(1);

      expect(result, isTrue);
      expect(mockApiService.lastDeletedPath, 'store/products/1');
    });

    test('throws ServerException when status is not success', () async {
      mockApiService.deleteResponse = Response(
        requestOptions: RequestOptions(path: 'store/products/1'),
        statusCode: 400,
        data: {
          'status': 'error',
          'message': 'Product not found',
        },
      );

      expect(
        () => dataSource.deleteProduct(1),
        throwsA(isA<ServerException>().having(
          (e) => e.message,
          'message',
          'Product not found',
        )),
      );
    });

    test('throws AppException on DioException', () async {
      mockApiService.deleteException = DioException(
        requestOptions: RequestOptions(path: 'store/products/1'),
        type: DioExceptionType.connectionTimeout,
      );

      expect(
        () => dataSource.deleteProduct(1),
        throwsA(isA<AppException>()),
      );
    });
  });

  group('StoreRepoImpl.deleteProduct', () {
    late FakeStoreRemoteDataSource fakeDataSource;
    late StoreRepoImpl repo;

    setUp(() {
      fakeDataSource = FakeStoreRemoteDataSource();
      repo = StoreRepoImpl(storeRemoteDataSource: fakeDataSource);
    });

    test('returns right(true) on success', () async {
      final result = await repo.deleteProduct(42);

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => false), isTrue);
      expect(fakeDataSource.lastDeletedId, 42);
    });

    test('returns left(Failure) on AppException', () async {
      fakeDataSource.shouldThrow = true;

      final result = await repo.deleteProduct(42);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, 'Server error'),
        (_) => fail('Expected failure'),
      );
    });
  });

  group('ProfileBloc._onDeleteProduct', () {
    late MockProfileRepoForDelete mockProfileRepo;
    late FakePostLikeCubitForDelete fakePostLikeCubit;
    late ProfileBloc profileBloc;

    const dummyProduct = ProductEntity(
      id: 5,
      store: ProductStoreEntity(
        id: 1,
        name: 'Store',
        handle: 'store',
        isActive: true,
        followersCount: 0,
      ),
      name: 'Item to delete',
      description: 'Desc',
      price: 15.0,
      quantityInStock: 2,
      sku: 'SKU-01',
      status: 'available',
      categories: [],
    );

    setUp(() {
      mockProfileRepo = MockProfileRepoForDelete();
      fakePostLikeCubit = FakePostLikeCubitForDelete();
      profileBloc = ProfileBloc(mockProfileRepo, fakePostLikeCubit);
    });

    tearDown(() async {
      await profileBloc.close();
      await fakePostLikeCubit.close();
    });

    test('deletes product from state and calls repo.deleteProduct', () async {
      profileBloc.emit(
        ProfileState(profileProducts: const [dummyProduct]),
      );

      profileBloc.add(const DeleteProfileProduct(productId: 5));

      await expectLater(
        profileBloc.stream,
        emits(predicate<ProfileState>((state) =>
            state.profileProducts.isEmpty && state.failure == null)),
      );

      expect(mockProfileRepo.lastDeletedProductId, 5);
    });

    test('rolls back state on failure', () async {
      mockProfileRepo.deleteResponse = left(const ServerFailure(message: 'Failed'));

      profileBloc.emit(
        ProfileState(profileProducts: const [dummyProduct]),
      );

      profileBloc.add(const DeleteProfileProduct(productId: 5));

      await expectLater(
        profileBloc.stream,
        emitsInOrder([
          predicate<ProfileState>((s) => s.profileProducts.isEmpty),
          predicate<ProfileState>((s) =>
              s.profileProducts.length == 1 && s.failure != null),
        ]),
      );
    });
  });
}
