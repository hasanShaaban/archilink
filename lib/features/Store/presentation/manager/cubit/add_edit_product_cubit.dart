import 'package:archilink/features/Store/domain/entity/add_product_params.dart';
import 'package:archilink/features/Store/domain/entity/edit_product_params.dart';
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
           quantity: (initialProduct?.status.trim().toLowerCase().replaceAll(' ', '_') == 'out_of_stock')
               ? 0
               : (initialProduct?.quantityInStock ?? 0),
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
    final isOutOfStock =
        status.trim().toLowerCase().replaceAll(' ', '_') == 'out_of_stock';
    if (isOutOfStock) {
      emit(state.copyWith(status: status, quantity: 0));
    } else {
      emit(state.copyWith(status: status));
    }
  }

  void incrementQuantity() {
    if (!state.isQuantityVisible) return;
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void decrementQuantity() {
    if (!state.isQuantityVisible) return;
    if (state.quantity > 0) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }

  void setQuantity(int quantity) {
    if (!state.isQuantityVisible) {
      emit(state.copyWith(quantity: 0));
      return;
    }
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
    if (state.isEditMode) return;
    var updated = List<String>.from(state.images)..addAll(newImages);
    if (updated.length > 5) {
      updated = updated.sublist(0, 5);
    }
    emit(state.copyWith(images: updated));
  }

  void removeImage(int index) {
    if (state.isEditMode) return;
    if (index >= 0 && index < state.images.length) {
      final updated = List<String>.from(state.images)..removeAt(index);
      emit(state.copyWith(images: updated));
    }
  }

  Future<void> submit() async {
    if (state.isEditMode) {
      await _submitEdit();
    } else {
      await _submitAdd();
    }
  }

  Future<void> _submitEdit() async {
    if (state.images.length > 5) {
      emit(state.copyWith(errorMessage: 'Cannot upload more than 5 images'));
      return;
    }

    if (state.isQuantityVisible && state.quantity < 0) {
      emit(state.copyWith(errorMessage: 'Quantity cannot be negative'));
      return;
    }

    final name = state.name.trim();
    final String? nameParam = name.isEmpty ? null : name;

    final priceCleaned = state.price.replaceAll('\$', '').trim();
    final parsedPrice = double.tryParse(priceCleaned);

    final isOutOfStock =
        state.status.trim().toLowerCase().replaceAll(' ', '_') == 'out_of_stock';
    final int? quantity = isOutOfStock
        ? 0
        : (state.isQuantityVisible ? state.quantity : null);

    final String? status =
        state.status.trim().isEmpty ? null : state.status.trim();
    final String? description =
        state.description.trim().isEmpty ? null : state.description.trim();
    final categoryIds = state.selectedCategories.isNotEmpty
        ? state.selectedCategories.map((c) => c.id).toList()
        : null;

    if (_storeRepo == null) {
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
      return;
    }

    final productId = state.initialProduct?.id;
    if (productId == null) {
      emit(state.copyWith(errorMessage: 'Cannot edit a product without an ID'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    final params = EditProductParams(
      id: productId,
      name: nameParam,
      description: description,
      price: parsedPrice,
      categoryIds: categoryIds,
      quantityInStock: quantity,
      status: status,
      imagePaths: null, // Note: backend does not support editing media items for now
    );

    final result = await _storeRepo.editProduct(params);
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        ));
      },
      (product) {
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: true,
        ));
      },
    );
  }

  Future<void> _submitAdd() async {
    final name = state.name.trim();
    if (name.isEmpty) {
      emit(state.copyWith(errorMessage: 'Please enter a product name'));
      return;
    }

    final priceCleaned = state.price.replaceAll('\$', '').trim();
    final parsedPrice = double.tryParse(priceCleaned);
    if (parsedPrice == null || parsedPrice < 0.01) {
      emit(state.copyWith(errorMessage: 'Price must be at least 0.01'));
      return;
    }

    if (state.images.length > 5) {
      emit(state.copyWith(errorMessage: 'Cannot upload more than 5 images'));
      return;
    }

    if (state.isQuantityVisible && state.quantity < 0) {
      emit(state.copyWith(errorMessage: 'Quantity cannot be negative'));
      return;
    }

    final isOutOfStock =
        state.status.trim().toLowerCase().replaceAll(' ', '_') == 'out_of_stock';
    final int quantity = isOutOfStock
        ? 0
        : (state.isQuantityVisible ? state.quantity : 0);

    final String? status =
        state.status.trim().isEmpty ? null : state.status.trim();
    final String? description =
        state.description.trim().isEmpty ? null : state.description.trim();
    final categoryIds = state.selectedCategories.map((c) => c.id).toList();

    if (_storeRepo == null) {
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    final params = AddProductParams(
      name: name,
      description: description,
      price: parsedPrice,
      categoryIds: categoryIds,
      quantityInStock: quantity,
      status: status,
      imagePaths: state.images,
    );

    final result = await _storeRepo.addProduct(params);
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        ));
      },
      (product) {
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: true,
        ));
      },
    );
  }

  Future<void> delete() async {
    final productId = state.initialProduct?.id;
    if (productId == null) {
      emit(state.copyWith(errorMessage: 'Cannot delete a product without an ID'));
      return;
    }

    if (_storeRepo == null) {
      emit(state.copyWith(isDeleting: false, isSuccess: true));
      return;
    }

    emit(state.copyWith(isDeleting: true, errorMessage: null));

    final result = await _storeRepo.deleteProduct(productId);
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(state.copyWith(
          isDeleting: false,
          errorMessage: failure.message,
        ));
      },
      (_) {
        emit(state.copyWith(
          isDeleting: false,
          isSuccess: true,
        ));
      },
    );
  }
}
