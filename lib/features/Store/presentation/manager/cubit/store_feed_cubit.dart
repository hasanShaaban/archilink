import 'dart:async';

import 'package:archilink/features/Store/domain/entity/product_category_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/domain/repo/store_repo.dart';
import 'package:bloc/bloc.dart';
import 'store_feed_state.dart';

class StoreFeedCubit extends Cubit<StoreFeedState> {
  StoreFeedCubit(
    this._storeRepo, {
    this.debounceDuration = const Duration(milliseconds: 350),
  }) : super(const StoreFeedInitial());

  final StoreRepo _storeRepo;
  final Duration debounceDuration;
  Timer? _debounceTimer;
  int _fetchRequestId = 0;

  Future<void> fetchProducts({bool refresh = false}) async {
    if (!refresh && (state.isLoading || state.isLoadingMore)) return;

    if (!refresh && state.currentPage > 0 && !state.hasMore) return;

    final requestId = ++_fetchRequestId;
    final nextPage = refresh ? 1 : (state.currentPage + 1);
    final isFirstPage = nextPage == 1;

    emit(
      state.copyWith(
        isLoading: isFirstPage,
        isLoadingMore: !isFirstPage,
        errorMessage: null,
      ),
    );

    final result = state.isSearchActive
        ? await _storeRepo.searchProducts(
            query: state.searchQuery,
            status: state.status,
            minPrice: state.minPrice,
            maxPrice: state.maxPrice,
            page: nextPage,
          )
        : await _storeRepo.getProducts(nextPage);
    if (isClosed || requestId != _fetchRequestId) return;

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

  Future<void> fetchCategories({bool refresh = false}) async {
    if (state.isLoadingCategories || state.isLoadingMoreCategories) return;
    if (!refresh && !state.categoriesHasMore) return;

    final targetPage = refresh ? 1 : state.categoriesCurrentPage;
    final isFirstPage = targetPage == 1;

    emit(
      state.copyWith(
        isLoadingCategories: isFirstPage,
        isLoadingMoreCategories: !isFirstPage,
        categoriesErrorMessage: null,
      ),
    );

    final result = await _storeRepo.getCategories(page: targetPage);
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingCategories: false,
            isLoadingMoreCategories: false,
            categoriesErrorMessage: failure.message,
          ),
        );
      },
      (feed) {
        final updatedList = isFirstPage
            ? feed.categories
            : _mergeCategories(state.availableCategories, feed.categories);

        emit(
          state.copyWith(
            isLoadingCategories: false,
            isLoadingMoreCategories: false,
            availableCategories: updatedList,
            categoriesCurrentPage: feed.pagination.currentPage + 1,
            categoriesHasMore: feed.pagination.hasMore,
          ),
        );
      },
    );
  }

  List<ProductCategoryEntity> _mergeCategories(
    List<ProductCategoryEntity> current,
    List<ProductCategoryEntity> incoming,
  ) {
    final merged = List<ProductCategoryEntity>.from(current);
    final ids = current.map((c) => c.id).toSet();
    for (final item in incoming) {
      if (ids.add(item.id)) {
        merged.add(item);
      }
    }
    return merged;
  }

  void toggleCategory(ProductCategoryEntity category) {
    final current = List<ProductCategoryEntity>.from(state.selectedCategories);
    final exists = current.any((c) => c.id == category.id);
    if (exists) {
      current.removeWhere((c) => c.id == category.id);
    } else {
      current.add(category);
    }
    emit(state.copyWith(selectedCategories: current));
  }

  void removeCategory(ProductCategoryEntity category) {
    final current = List<ProductCategoryEntity>.from(state.selectedCategories);
    current.removeWhere((c) => c.id == category.id);
    emit(state.copyWith(selectedCategories: current));
  }

  void clearCategories() {
    emit(state.copyWith(selectedCategories: const []));
  }

  void setCategorySearchQuery(String query) {
    emit(state.copyWith(categorySearchQuery: query));
  }

  void setSearchQuery(String query, {bool immediate = false}) {
    if (state.searchQuery == query) return;
    _debounceTimer?.cancel();

    final isClearing = query.trim().isEmpty;
    emit(state.copyWith(searchQuery: query));

    if (immediate || isClearing || debounceDuration == Duration.zero) {
      fetchProducts(refresh: true);
    } else {
      _debounceTimer = Timer(debounceDuration, () {
        if (!isClosed) {
          fetchProducts(refresh: true);
        }
      });
    }
  }

  void setFilters({
    String? status,
    String? minPrice,
    String? maxPrice,
  }) {
    if (state.status == status &&
        state.minPrice == minPrice &&
        state.maxPrice == maxPrice) {
      return;
    }
    _debounceTimer?.cancel();

    emit(state.copyWith(
      status: status,
      minPrice: minPrice,
      maxPrice: maxPrice,
    ));

    fetchProducts(refresh: true);
  }

  void setPriceFilters({String? minPrice, String? maxPrice}) {
    setFilters(
      status: state.status,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
  }

  void setStatusFilter(String? status) {
    setFilters(
      status: status,
      minPrice: state.minPrice,
      maxPrice: state.maxPrice,
    );
  }

  void clearSearchAndFilters() {
    _debounceTimer?.cancel();
    emit(state.copyWith(
      searchQuery: '',
      status: null,
      minPrice: null,
      maxPrice: null,
    ));
    fetchProducts(refresh: true);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
