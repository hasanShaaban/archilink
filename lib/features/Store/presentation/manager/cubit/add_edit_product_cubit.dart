import 'package:archilink/features/Store/domain/entity/product_category_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/domain/repo/store_repo.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/add_edit_product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditProductCubit extends Cubit<AddEditProductState> {
  final StoreRepo? _storeRepo;

  AddEditProductCubit({
    StoreRepo? storeRepo,
    ProductEntity? initialProduct,
    List<ProductCategoryEntity>? customAvailableCategories,
  }) : _storeRepo = storeRepo,
       super(
         AddEditProductState(
           initialProduct: initialProduct,
           isEditMode: initialProduct != null,
           name: initialProduct?.name ?? '',
           description: initialProduct?.description ?? '',
           price: initialProduct != null
               ? (initialProduct.price % 1 == 0
                   ? initialProduct.price.toInt().toString()
                   : initialProduct.price.toStringAsFixed(2))
               : '',
           quantity: initialProduct?.quantityInStock ?? 0,
           status: initialProduct?.status ?? '',
           images: initialProduct?.images ?? const [],
           selectedCategories: initialProduct?.categories ?? const [],
           availableCategories:
               customAvailableCategories ?? _defaultAvailableCategories,
         ),
       );

  static const List<ProductCategoryEntity> _defaultAvailableCategories = [
    ProductCategoryEntity(id: 1, name: 'Revit', slug: 'revit', productsCount: 12),
    ProductCategoryEntity(id: 2, name: 'AutoCAD', slug: 'autocad', productsCount: 8),
    ProductCategoryEntity(id: 3, name: '3ds Max', slug: '3ds-max', productsCount: 5),
    ProductCategoryEntity(id: 4, name: 'SketchUp', slug: 'sketchup', productsCount: 9),
    ProductCategoryEntity(id: 5, name: 'Rhino', slug: 'rhino', productsCount: 3),
    ProductCategoryEntity(id: 6, name: 'Stationery', slug: 'stationery', productsCount: 14),
    ProductCategoryEntity(id: 7, name: 'Rulers', slug: 'rulers', productsCount: 6),
    ProductCategoryEntity(id: 8, name: 'Model Making', slug: 'model-making', productsCount: 4),
    ProductCategoryEntity(id: 9, name: 'Drafting Tools', slug: 'drafting-tools', productsCount: 7),
    ProductCategoryEntity(id: 10, name: '3D Printing', slug: '3d-printing', productsCount: 2),
    ProductCategoryEntity(id: 11, name: 'Wood Tools', slug: 'wood-tools', productsCount: 3),
  ];

  Future<void> fetchCategories({bool refresh = false}) async {
    if (_storeRepo == null) return;
    if (state.isLoadingCategories || state.isLoadingMoreCategories) return;
    if (!refresh && !state.categoriesHasMore) return;

    final targetPage = refresh ? 1 : state.categoriesCurrentPage;
    final isFirstPage = targetPage == 1;

    emit(state.copyWith(
      isLoadingCategories: isFirstPage,
      isLoadingMoreCategories: !isFirstPage,
      categoriesErrorMessage: null,
    ));

    final result = await _storeRepo.getCategories(page: targetPage);
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoadingCategories: false,
          isLoadingMoreCategories: false,
          categoriesErrorMessage: failure.message,
        ));
      },
      (feed) {
        final updatedList = isFirstPage
            ? feed.categories
            : _mergeCategories(state.availableCategories, feed.categories);

        emit(state.copyWith(
          isLoadingCategories: false,
          isLoadingMoreCategories: false,
          availableCategories: updatedList,
          categoriesCurrentPage: feed.pagination.currentPage + 1,
          categoriesHasMore: feed.pagination.hasMore,
        ));
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

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void updatePrice(String price) {
    emit(state.copyWith(price: price));
  }

  void updateStatus(String status) {
    emit(state.copyWith(status: status));
  }

  void incrementQuantity() {
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void decrementQuantity() {
    if (state.quantity > 0) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }

  void setQuantity(int quantity) {
    emit(state.copyWith(quantity: quantity < 0 ? 0 : quantity));
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

  void setCategorySearchQuery(String query) {
    emit(state.copyWith(categorySearchQuery: query));
  }

  void addImages(List<String> newImages) {
    final updated = List<String>.from(state.images)..addAll(newImages);
    emit(state.copyWith(images: updated));
  }

  void removeImage(int index) {
    if (index >= 0 && index < state.images.length) {
      final updated = List<String>.from(state.images)..removeAt(index);
      emit(state.copyWith(images: updated));
    }
  }

  Future<void> submit() async {
    // Repository integration point (planned for next milestone)
    emit(state.copyWith(isSubmitting: true, errorMessage: null));
    await Future.delayed(const Duration(milliseconds: 300));
    emit(state.copyWith(isSubmitting: false, isSuccess: true));
  }

  Future<void> delete() async {
    // Repository integration point (planned for next milestone)
    emit(state.copyWith(isDeleting: true, errorMessage: null));
    await Future.delayed(const Duration(milliseconds: 300));
    emit(state.copyWith(isDeleting: false, isSuccess: true));
  }
}
