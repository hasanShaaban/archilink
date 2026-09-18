import 'package:archilink/features/Store/domain/entity/product_category_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:equatable/equatable.dart';

class StoreFeedState extends Equatable {
  static const Object _noChange = Object();

  const StoreFeedState({
    this.products = const <ProductEntity>[],
    this.currentPage = 0,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.availableCategories = const <ProductCategoryEntity>[],
    this.selectedCategories = const <ProductCategoryEntity>[],
    this.isLoadingCategories = false,
    this.isLoadingMoreCategories = false,
    this.categoriesHasMore = true,
    this.categoriesCurrentPage = 1,
    this.categorySearchQuery = '',
    this.categoriesErrorMessage,
    this.searchQuery = '',
    this.minPrice,
    this.maxPrice,
  });

  final List<ProductEntity> products;
  final int currentPage;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;

  // Category filter state
  final List<ProductCategoryEntity> availableCategories;
  final List<ProductCategoryEntity> selectedCategories;
  final bool isLoadingCategories;
  final bool isLoadingMoreCategories;
  final bool categoriesHasMore;
  final int categoriesCurrentPage;
  final String categorySearchQuery;
  final String? categoriesErrorMessage;

  // Search & Filter state
  final String searchQuery;
  final String? minPrice;
  final String? maxPrice;

  bool get hasProducts => products.isNotEmpty;

  bool get isSearchActive => searchQuery.trim().isNotEmpty;

  List<ProductCategoryEntity> get filteredCategories {
    if (categorySearchQuery.trim().isEmpty) {
      return availableCategories;
    }
    final q = categorySearchQuery.toLowerCase().trim();
    return availableCategories.where((c) {
      return c.name.toLowerCase().contains(q) ||
          c.slug.toLowerCase().contains(q);
    }).toList();
  }

  StoreFeedState copyWith({
    List<ProductEntity>? products,
    int? currentPage,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    Object? errorMessage = _noChange,
    List<ProductCategoryEntity>? availableCategories,
    List<ProductCategoryEntity>? selectedCategories,
    bool? isLoadingCategories,
    bool? isLoadingMoreCategories,
    bool? categoriesHasMore,
    int? categoriesCurrentPage,
    String? categorySearchQuery,
    Object? categoriesErrorMessage = _noChange,
    Object? searchQuery = _noChange,
    Object? minPrice = _noChange,
    Object? maxPrice = _noChange,
  }) {
    return StoreFeedState(
      products: products ?? this.products,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage == _noChange
          ? this.errorMessage
          : errorMessage as String?,
      availableCategories: availableCategories ?? this.availableCategories,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      isLoadingMoreCategories:
          isLoadingMoreCategories ?? this.isLoadingMoreCategories,
      categoriesHasMore: categoriesHasMore ?? this.categoriesHasMore,
      categoriesCurrentPage:
          categoriesCurrentPage ?? this.categoriesCurrentPage,
      categorySearchQuery: categorySearchQuery ?? this.categorySearchQuery,
      categoriesErrorMessage: categoriesErrorMessage == _noChange
          ? this.categoriesErrorMessage
          : categoriesErrorMessage as String?,
      searchQuery: searchQuery == _noChange
          ? this.searchQuery
          : (searchQuery as String? ?? ''),
      minPrice: minPrice == _noChange ? this.minPrice : minPrice as String?,
      maxPrice: maxPrice == _noChange ? this.maxPrice : maxPrice as String?,
    );
  }

  @override
  List<Object?> get props => [
    products,
    currentPage,
    hasMore,
    isLoading,
    isLoadingMore,
    errorMessage,
    availableCategories,
    selectedCategories,
    isLoadingCategories,
    isLoadingMoreCategories,
    categoriesHasMore,
    categoriesCurrentPage,
    categorySearchQuery,
    categoriesErrorMessage,
    searchQuery,
    minPrice,
    maxPrice,
  ];
}

final class StoreFeedInitial extends StoreFeedState {
  const StoreFeedInitial();
}
