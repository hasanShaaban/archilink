import 'package:archilink/features/Store/domain/entity/product_category_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:equatable/equatable.dart';

class AddEditProductState extends Equatable {
  final ProductEntity? initialProduct;
  final bool isEditMode;
  final String name;
  final String description;
  final String price;
  final int quantity;
  final String status;
  final List<String> images;
  final List<ProductCategoryEntity> selectedCategories;
  final List<ProductCategoryEntity> availableCategories;
  final String categorySearchQuery;
  final bool isLoadingCategories;
  final bool isLoadingMoreCategories;
  final int categoriesCurrentPage;
  final bool categoriesHasMore;
  final String? categoriesErrorMessage;
  final bool isSubmitting;
  final bool isDeleting;
  final String? errorMessage;
  final bool isSuccess;

  const AddEditProductState({
    this.initialProduct,
    this.isEditMode = false,
    this.name = '',
    this.description = '',
    this.price = '',
    this.quantity = 0,
    this.status = '',
    this.images = const [],
    this.selectedCategories = const [],
    this.availableCategories = const [],
    this.categorySearchQuery = '',
    this.isLoadingCategories = false,
    this.isLoadingMoreCategories = false,
    this.categoriesCurrentPage = 1,
    this.categoriesHasMore = true,
    this.categoriesErrorMessage,
    this.isSubmitting = false,
    this.isDeleting = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  /// Filtered categories based on the current search query
  List<ProductCategoryEntity> get filteredCategories {
    if (categorySearchQuery.trim().isEmpty) {
      return availableCategories;
    }
    final query = categorySearchQuery.toLowerCase().trim();
    return availableCategories
        .where(
          (category) =>
              category.name.toLowerCase().contains(query) ||
              category.slug.toLowerCase().contains(query),
        )
        .toList();
  }

  AddEditProductState copyWith({
    ProductEntity? initialProduct,
    bool? isEditMode,
    String? name,
    String? description,
    String? price,
    int? quantity,
    String? status,
    List<String>? images,
    List<ProductCategoryEntity>? selectedCategories,
    List<ProductCategoryEntity>? availableCategories,
    String? categorySearchQuery,
    bool? isLoadingCategories,
    bool? isLoadingMoreCategories,
    int? categoriesCurrentPage,
    bool? categoriesHasMore,
    String? categoriesErrorMessage,
    bool? isSubmitting,
    bool? isDeleting,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return AddEditProductState(
      initialProduct: initialProduct ?? this.initialProduct,
      isEditMode: isEditMode ?? this.isEditMode,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      images: images ?? this.images,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      availableCategories: availableCategories ?? this.availableCategories,
      categorySearchQuery: categorySearchQuery ?? this.categorySearchQuery,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      isLoadingMoreCategories:
          isLoadingMoreCategories ?? this.isLoadingMoreCategories,
      categoriesCurrentPage:
          categoriesCurrentPage ?? this.categoriesCurrentPage,
      categoriesHasMore: categoriesHasMore ?? this.categoriesHasMore,
      categoriesErrorMessage: categoriesErrorMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isDeleting: isDeleting ?? this.isDeleting,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
    initialProduct,
    isEditMode,
    name,
    description,
    price,
    quantity,
    status,
    images,
    selectedCategories,
    availableCategories,
    categorySearchQuery,
    isLoadingCategories,
    isLoadingMoreCategories,
    categoriesCurrentPage,
    categoriesHasMore,
    categoriesErrorMessage,
    isSubmitting,
    isDeleting,
    errorMessage,
    isSuccess,
  ];
}
