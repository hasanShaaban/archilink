import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Post/domain/entity/pagination_entity.dart';
import 'package:archilink/features/Post/domain/entity/posts_entity.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_like_cubit.dart';
import 'package:archilink/features/Profile/domain/entity/follow_status.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_feed_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_store_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class FakePostLikeCubit extends Cubit<PostLikeState?> implements PostLikeCubit {
  FakePostLikeCubit() : super(null);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockProfileRepo implements ProfileRepo {
  List<ProductEntity> returnProducts = [];
  bool hasMore = false;
  int? requestedStoreId;
  int? requestedPage;

  @override
  Future<Either<Failure, ProductFeedEntity>> getStoreProducts({
    required int storeId,
    int page = 1,
  }) async {
    requestedStoreId = storeId;
    requestedPage = page;
    return right(
      ProductFeedEntity(
        products: returnProducts,
        pagination: PaginationEntity(
          currentPage: page,
          perPage: 20,
          lastPage: hasMore ? page + 1 : page,
          total: returnProducts.length,
          hasMore: hasMore,
          next: hasMore ? 'next' : null,
          prev: null,
        ),
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  const dummyStore = ProductStoreEntity(
    id: 1,
    name: 'Test Store',
    handle: 'test_store',
    isActive: true,
    followersCount: 0,
  );

  const product1 = ProductEntity(
    id: 1,
    store: dummyStore,
    name: 'Product 1',
    description: 'Desc 1',
    price: 10.0,
    quantityInStock: 5,
    categories: [],
    mediaItems: [],
    sku: 'SKU1',
    status: 'available',
  );

  const product2 = ProductEntity(
    id: 2,
    store: dummyStore,
    name: 'Product 2',
    description: 'Desc 2',
    price: 20.0,
    quantityInStock: 3,
    categories: [],
    mediaItems: [],
    sku: 'SKU2',
    status: 'available',
  );

  late MockProfileRepo mockRepo;
  late PostLikeCubit postLikeCubit;
  late ProfileBloc bloc;

  setUp(() {
    mockRepo = MockProfileRepo();
    postLikeCubit = FakePostLikeCubit();
    bloc = ProfileBloc(mockRepo, postLikeCubit);
  });

  tearDown(() {
    bloc.close();
    postLikeCubit.close();
  });

  group('ProfileBloc store products handling', () {
    test('LoadInitialProfileProducts fetches products and updates state', () async {
      mockRepo.returnProducts = [product1, product2];
      mockRepo.hasMore = true;

      bloc.add(const LoadInitialProfileProducts(storeId: 1));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ProfileState>()
              .having((s) => s.isInitialLoading, 'isInitialLoading', isTrue)
              .having((s) => s.activeStoreId, 'activeStoreId', 1),
          isA<ProfileState>()
              .having((s) => s.isInitialLoading, 'isInitialLoading', isFalse)
              .having((s) => s.profileProducts.length, 'profileProducts.length', 2)
              .having((s) => s.hasReachedMax, 'hasReachedMax', isFalse),
        ]),
      );

      expect(mockRepo.requestedStoreId, 1);
      expect(mockRepo.requestedPage, 1);
    });

    test('LoadMoreProfileProducts appends next page products', () async {
      mockRepo.returnProducts = [product1];
      mockRepo.hasMore = true;

      bloc.add(const LoadInitialProfileProducts(storeId: 1));
      await bloc.stream.firstWhere((s) => !s.isInitialLoading);

      const product3 = ProductEntity(
        id: 3,
        store: dummyStore,
        name: 'Product 3',
        description: 'Desc 3',
        price: 30.0,
        quantityInStock: 1,
        categories: [],
        mediaItems: [],
        sku: 'SKU3',
        status: 'available',
      );
      mockRepo.returnProducts = [product3];
      mockRepo.hasMore = false;

      bloc.add(const LoadMoreProfileProducts());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ProfileState>().having((s) => s.isLoadingMore, 'isLoadingMore', isTrue),
          isA<ProfileState>()
              .having((s) => s.isLoadingMore, 'isLoadingMore', isFalse)
              .having((s) => s.profileProducts.length, 'profileProducts.length', 2)
              .having((s) => s.hasReachedMax, 'hasReachedMax', isTrue),
        ]),
      );

      expect(mockRepo.requestedPage, 2);
    });

    test('DeleteProfileProduct removes specified product from state', () async {
      mockRepo.returnProducts = [product1, product2];
      mockRepo.hasMore = false;

      bloc.add(const LoadInitialProfileProducts(storeId: 1));
      await bloc.stream.firstWhere((s) => !s.isInitialLoading);

      expect(bloc.state.profileProducts.length, 2);

      bloc.add(const DeleteProfileProduct(productId: 1));

      await expectLater(
        bloc.stream,
        emits(
          isA<ProfileState>()
              .having((s) => s.profileProducts.length, 'profileProducts.length', 1)
              .having((s) => s.profileProducts.first.id, 'remaining product id', 2),
        ),
      );
    });
  });
}
