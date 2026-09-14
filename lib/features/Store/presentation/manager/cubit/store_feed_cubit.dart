import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/domain/repo/store_repo.dart';
import 'package:bloc/bloc.dart';
import 'store_feed_state.dart';

class StoreFeedCubit extends Cubit<StoreFeedState> {
  StoreFeedCubit(this._storeRepo) : super(const StoreFeedInitial());

  final StoreRepo _storeRepo;

  Future<void> fetchProducts({bool refresh = false}) async {
    if (state.isLoading || state.isLoadingMore) return;

    if (!refresh && state.currentPage > 0 && !state.hasMore) return;

    final nextPage = refresh ? 1 : (state.currentPage + 1);
    final isFirstPage = nextPage == 1;

    emit(
      state.copyWith(
        isLoading: isFirstPage,
        isLoadingMore: !isFirstPage,
        errorMessage: null,
      ),
    );

    final result = await _storeRepo.getProducts(nextPage);
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            isLoadingMore: false,
            errorMessage: failure.message,
          ),
        );
      },
      (productFeed) {
        final products = isFirstPage
            ? productFeed.products
            : _mergeProducts(state.products, productFeed.products);

        emit(
          state.copyWith(
            isLoading: false,
            isLoadingMore: false,
            errorMessage: null,
            products: products,
            currentPage: productFeed.pagination.currentPage,
            hasMore: productFeed.pagination.hasMore,
          ),
        );
      },
    );
  }

  List<ProductEntity> _mergeProducts(
    List<ProductEntity> currentProducts,
    List<ProductEntity> incomingProducts,
  ) {
    final merged = <ProductEntity>[...currentProducts];
    final ids = currentProducts.map((e) => e.id).toSet();

    for (final product in incomingProducts) {
      if (ids.add(product.id)) {
        merged.add(product);
      }
    }

    return merged;
  }
}
