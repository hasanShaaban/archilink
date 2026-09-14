import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Post/domain/entity/pagination_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_feed_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_store_entity.dart';
import 'package:archilink/features/Store/domain/repo/store_repo.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/store_feed_cubit.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/store_feed_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class MockStoreRepo implements StoreRepo {
  Either<Failure, ProductFeedEntity>? response;

  @override
  Future<Either<Failure, ProductFeedEntity>> getProducts(int page) async {
    return response ??
        right(
          ProductFeedEntity(
            products: [
              ProductEntity(
                id: page,
                store: const ProductStoreEntity(
                  id: 1,
                  name: 'Test Store',
                  handle: 'testStore',
                  isActive: true,
                  followersCount: 0,
                ),
                name: 'Product $page',
                description: 'Description $page',
                price: 10.0 * page,
                quantityInStock: 10,
                sku: 'SKU$page',
                status: 'available',
              ),
            ],
            pagination: PaginationEntity(
              currentPage: page,
              perPage: 20,
              lastPage: 2,
              total: 2,
              hasMore: page < 2,
            ),
          ),
        );
  }
}

void main() {
  test('StoreFeedCubit initial state is StoreFeedInitial', () {
    final repo = MockStoreRepo();
    final cubit = StoreFeedCubit(repo);
    expect(cubit.state, const StoreFeedInitial());
  });

  test('StoreFeedCubit fetches products successfully and paginates', () async {
    final repo = MockStoreRepo();
    final cubit = StoreFeedCubit(repo);

    await cubit.fetchProducts();

    expect(cubit.state.isLoading, false);
    expect(cubit.state.products.length, 1);
    expect(cubit.state.currentPage, 1);
    expect(cubit.state.hasMore, true);

    // Fetch next page
    await cubit.fetchProducts();

    expect(cubit.state.products.length, 2);
    expect(cubit.state.currentPage, 2);
    expect(cubit.state.hasMore, false);
  });
}
