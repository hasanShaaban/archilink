import 'package:archilink/features/Post/domain/entity/pagination_entity.dart';
import 'package:archilink/features/Store/data/models/category_feed_model.dart';
import 'package:archilink/features/Store/domain/entity/add_product_params.dart';
import 'package:archilink/features/Store/domain/entity/category_feed_entity.dart';
import 'package:archilink/features/Store/domain/entity/edit_product_params.dart';
import 'package:archilink/features/Store/domain/entity/product_category_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_store_entity.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/add_edit_product_cubit.dart';
import 'package:archilink/features/Store/presentation/views/add_edit_product_view.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_images_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:archilink/core/error/failure.dart';
import 'package:archilink/core/functions/product_form_data_builder.dart';
import 'package:archilink/features/Store/data/models/product_category_model.dart';
import 'package:archilink/features/Store/data/models/product_model.dart';
import 'package:archilink/features/Store/domain/entity/product_feed_entity.dart';
import 'package:archilink/features/Store/domain/repo/store_repo.dart';
import 'package:dartz/dartz.dart';

const dummyStore = ProductStoreEntity(
  id: 1,
  name: 'Architect Tools',
  handle: 'architect_tools',
  isActive: true,
  city: 'Damascus',
  country: 'Syria',
);

const sampleProduct = ProductEntity(
  id: 10,
  store: dummyStore,
  name: 'Ruler',
  description: '1. Durable wood with single metal edge.',
  price: 10.0,
  quantityInStock: 50,
  sku: 'RUL-001',
  status: 'available',
  categories: [
    ProductCategoryEntity(id: 1, name: 'Revit', slug: 'revit', productsCount: 12),
    ProductCategoryEntity(id: 2, name: 'AutoCAD', slug: 'autocad', productsCount: 8),
  ],
);

class MockStoreRepo implements StoreRepo {
  Either<Failure, ProductFeedEntity>? feedResponse;
  Either<Failure, CategoryFeedEntity>? categoriesResponse;
  Either<Failure, ProductEntity>? addProductResponse;
  AddProductParams? lastAddedParams;
  final List<int> requestedPages = [];

  @override
  Future<Either<Failure, ProductFeedEntity>> getProducts(int page) async {
    return feedResponse ?? left(UnknownFailure());
  }

  @override
  Future<Either<Failure, CategoryFeedEntity>> getCategories({int page = 1}) async {
    requestedPages.add(page);
    return categoriesResponse ??
        right(CategoryFeedEntity(
          categories: [
            ProductCategoryEntity(
              id: page * 10 + 1,
              name: 'Category $page-1',
              slug: 'category-$page-1',
              productsCount: page * 2,
            ),
            ProductCategoryEntity(
              id: page * 10 + 2,
              name: 'Category $page-2',
              slug: 'category-$page-2',
              productsCount: page * 3,
            ),
          ],
          pagination: PaginationEntity(
            currentPage: page,
            perPage: 2,
            total: 4,
            lastPage: 2,
            hasMore: page < 2,
          ),
        ));
  }

  Either<Failure, ProductEntity>? editProductResponse;
  EditProductParams? lastEditedParams;
  Either<Failure, bool>? deleteProductResponse;
  int? lastDeletedProductId;

  @override
  Future<Either<Failure, ProductEntity>> addProduct(AddProductParams params) async {
    lastAddedParams = params;
    return addProductResponse ?? right(sampleProduct);
  }

  @override
  Future<Either<Failure, ProductEntity>> editProduct(EditProductParams params) async {
    lastEditedParams = params;
    return editProductResponse ?? right(sampleProduct);
  }

  @override
  Future<Either<Failure, bool>> deleteProduct(int id) async {
    lastDeletedProductId = id;
    return deleteProductResponse ?? right(true);
  }

  @override
  Future<Either<Failure, ProductFeedEntity>> searchProducts({
    String? query,
    String? minPrice,
    String? maxPrice,
    int page = 1,
  }) async {
    return feedResponse ?? left(UnknownFailure());
  }
}

void main() {

  Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: child,
    );
  }

  group('ProductCategoryModel JSON Parsing', () {
    test('parses json from endpoint with products_count', () {
      final json = {
        "id": 2,
        "name": "Distinctio",
        "slug": "distinctio",
        "description": "Aut et vel consequatur aut ea minima consequuntur earum.",
        "image_url": "https://via.placeholder.com/640x480.png/0099ee?text=nostrum",
        "is_active": true,
        "products_count": 2,
        "created_at": "2026-09-13",
        "updated_at": "2026-09-13"
      };

      final model = ProductCategoryModel.fromJson(json);
      expect(model.id, 2);
      expect(model.name, 'Distinctio');
      expect(model.slug, 'distinctio');
      expect(model.productsCount, 2);
      expect(model.isActive, isTrue);

      final entity = model.toEntity();
      expect(entity.id, 2);
      expect(entity.name, 'Distinctio');
      expect(entity.productsCount, 2);
    });
  });

  group('CategoryFeedModel JSON Parsing', () {
    test('parses full category response with pagination', () {
      final json = {
        "status": "success",
        "message": "Categories retrieved successfully",
        "data": {
          "data": [
            {
              "id": 2,
              "name": "Distinctio",
              "slug": "distinctio",
              "description": "Aut et vel consequatur aut ea minima consequuntur earum.",
              "image_url": "https://via.placeholder.com/640x480.png/0099ee?text=nostrum",
              "is_active": true,
              "products_count": 2,
              "created_at": "2026-09-13",
              "updated_at": "2026-09-13"
            },
            {
              "id": 3,
              "name": "Tempore",
              "slug": "tempore",
              "description": "Non non itaque est omnis aut.",
              "image_url": "https://via.placeholder.com/640x480.png/007722?text=minima",
              "is_active": true,
              "products_count": 1,
              "created_at": "2026-09-13",
              "updated_at": "2026-09-13"
            }
          ],
          "pagination": {
            "current_page": 3,
            "per_page": 20,
            "total": 100,
            "last_page": 5,
            "from": 41,
            "to": 60
          }
        }
      };

      final feedModel = CategoryFeedModel.fromJson(json);
      expect(feedModel.categories.length, 2);
      expect(feedModel.categories[0].name, 'Distinctio');
      expect(feedModel.categories[0].productsCount, 2);
      expect(feedModel.pagination.currentPage, 3);
      expect(feedModel.pagination.perPage, 20);
      expect(feedModel.pagination.total, 100);
      expect(feedModel.pagination.lastPage, 5);
      expect(feedModel.pagination.hasMore, isTrue);

      final entity = feedModel.toEntity();
      expect(entity.categories.length, 2);
      expect(entity.pagination.currentPage, 3);
      expect(entity.pagination.hasMore, isTrue);
    });
  });

  group('Add Product Response Parsing & FormData Builder', () {
    test('ProductModel parses add product response data correctly', () {
      final json = {
        "status": "success",
        "message": "Product created successfully",
        "data": {
          "id": 108,
          "store": {
            "id": 1,
            "name": "Test User",
            "handle": "testUser4",
            "description": "You have no idea how high i can fly.",
            "city": null,
            "country": null,
            "store_logo_url": "https://res.cloudinary.com/dnsnbfbad/image/upload/v1789614679/wrxjd9hk6snkhehtwizy.jpg",
            "store_banner_url": "https://res.cloudinary.com/dnsnbfbad/image/upload/v1789612858/rmvmqm35btsgemv4rb2l.jpg",
            "is_active": true,
            "followers_count": 0
          },
          "name": "Wireless Mouse",
          "description": null,
          "price": 22,
          "quantity_in_stock": 0,
          "image_url": null,
          "categories": [],
          "media_items": [],
          "sku": "SKU-714D71ED-F9F5-4F18-AA27-8EFDE3FA2864",
          "status": "available",
          "created_at": "2026-09-17",
          "updated_at": "2026-09-17"
        }
      };

      final model = ProductModel.fromJson(json['data'] as Map<String, dynamic>);
      expect(model.id, 108);
      expect(model.name, 'Wireless Mouse');
      expect(model.price, 22.0);
      expect(model.quantityInStock, 0);
      expect(model.status, 'available');
      expect(model.store.name, 'Test User');

      final entity = model.toEntity();
      expect(entity.id, 108);
      expect(entity.name, 'Wireless Mouse');
      expect(entity.price, 22.0);
    });

    test('buildProductFormData creates FormData with all expected fields', () async {
      const params = AddProductParams(
        name: 'Drafting Pen',
        description: '0.5mm technical pen',
        price: 15.50,
        categoryIds: [2, 5],
        quantityInStock: 10,
        status: 'available',
      );

      final formData = await buildProductFormData(params);
      expect(formData.fields.any((f) => f.key == 'name' && f.value == 'Drafting Pen'), isTrue);
      expect(formData.fields.any((f) => f.key == 'description' && f.value == '0.5mm technical pen'), isTrue);
      expect(formData.fields.any((f) => f.key == 'price' && f.value == '15.5'), isTrue);
      expect(formData.fields.any((f) => f.key == 'quantity_in_stock' && f.value == '10'), isTrue);
      expect(formData.fields.any((f) => f.key == 'status' && f.value == 'available'), isTrue);
    });
  });

  group('AddEditProductCubit', () {
    test('fetchCategories handles pagination and appends data on scroll/subsequent calls', () async {
      final repo = MockStoreRepo();
      final cubit = AddEditProductCubit(storeRepo: repo);

      // Initial page 1
      await cubit.fetchCategories();
      expect(cubit.state.isLoadingCategories, isFalse);
      expect(cubit.state.availableCategories.length, 2);
      expect(cubit.state.availableCategories.first.name, 'Category 1-1');
      expect(cubit.state.categoriesCurrentPage, 2);
      expect(cubit.state.categoriesHasMore, isTrue);
      expect(repo.requestedPages, [1]);

      // Page 2 (simulating scroll to bottom triggering fetchCategories)
      await cubit.fetchCategories();
      expect(cubit.state.isLoadingMoreCategories, isFalse);
      expect(cubit.state.availableCategories.length, 4);
      expect(cubit.state.categoriesCurrentPage, 3);
      expect(cubit.state.categoriesHasMore, isFalse);
      expect(repo.requestedPages, [1, 2]);

      // When hasMore is false, further calls without refresh do nothing
      await cubit.fetchCategories();
      expect(repo.requestedPages, [1, 2]);

      // Refresh resets to page 1
      await cubit.fetchCategories(refresh: true);
      expect(repo.requestedPages, [1, 2, 1]);
      expect(cubit.state.availableCategories.length, 2);
    });
    test('initial state for Add mode has default empty fields', () {
      final cubit = AddEditProductCubit();
      expect(cubit.state.isEditMode, isFalse);
      expect(cubit.state.name, isEmpty);
      expect(cubit.state.description, isEmpty);
      expect(cubit.state.price, isEmpty);
      expect(cubit.state.quantity, 0);
      expect(cubit.state.status, isEmpty);
      expect(cubit.state.selectedCategories, isEmpty);
      expect(cubit.state.availableCategories, isNotEmpty);
    });

    test('initial state for Edit mode populates product data', () {
      final cubit = AddEditProductCubit(initialProduct: sampleProduct);
      expect(cubit.state.isEditMode, isTrue);
      expect(cubit.state.name, 'Ruler');
      expect(cubit.state.description, contains('Durable wood'));
      expect(cubit.state.price, '10');
      expect(cubit.state.quantity, 50);
      expect(cubit.state.status, 'available');
      expect(cubit.state.selectedCategories.length, 2);
    });

    test('quantity increments and decrements properly without dropping below 0', () {
      final cubit = AddEditProductCubit();
      expect(cubit.state.quantity, 0);

      cubit.decrementQuantity();
      expect(cubit.state.quantity, 0);

      cubit.incrementQuantity();
      cubit.incrementQuantity();
      expect(cubit.state.quantity, 2);

      cubit.decrementQuantity();
      expect(cubit.state.quantity, 1);
    });

    test('updates name, description, price, and status', () {
      final cubit = AddEditProductCubit();
      cubit.updateName('T-Square');
      cubit.updateDescription('Heavy duty drafting tool');
      cubit.updatePrice('25.5');
      cubit.updateStatus('out_of_stock');

      expect(cubit.state.name, 'T-Square');
      expect(cubit.state.description, 'Heavy duty drafting tool');
      expect(cubit.state.price, '25.5');
      expect(cubit.state.status, 'out_of_stock');
    });

    test('toggleCategory adds and removes categories, search query filters', () {
      final cubit = AddEditProductCubit();
      const cat = ProductCategoryEntity(id: 1, name: 'Revit', slug: 'revit');

      expect(cubit.state.selectedCategories, isEmpty);
      cubit.toggleCategory(cat);
      expect(cubit.state.selectedCategories, contains(cat));

      cubit.toggleCategory(cat);
      expect(cubit.state.selectedCategories, isEmpty);

      cubit.toggleCategory(cat);
      cubit.removeCategory(cat);
      expect(cubit.state.selectedCategories, isEmpty);

      cubit.setCategorySearchQuery('rev');
      expect(cubit.state.filteredCategories.any((c) => c.slug == 'revit'), isTrue);
      expect(cubit.state.filteredCategories.any((c) => c.slug == 'wood-tools'), isFalse);
    });

    test('status out_of_stock forces quantity to 0 and hides quantity field', () {
      final cubit = AddEditProductCubit();
      cubit.setQuantity(25);
      expect(cubit.state.quantity, 25);
      expect(cubit.state.isQuantityVisible, isTrue);

      // Change status to out_of_stock
      cubit.updateStatus('out_of_stock');
      expect(cubit.state.status, 'out_of_stock');
      expect(cubit.state.quantity, 0);
      expect(cubit.state.isQuantityVisible, isFalse);

      // Attempting to increment or set quantity while out_of_stock keeps it 0
      cubit.incrementQuantity();
      expect(cubit.state.quantity, 0);

      cubit.setQuantity(50);
      expect(cubit.state.quantity, 0);

      // Changing to coming_soon makes quantity visible again
      cubit.updateStatus('coming_soon');
      expect(cubit.state.isQuantityVisible, isTrue);
      cubit.setQuantity(10);
      expect(cubit.state.quantity, 10);

      // Changing to pending keeps quantity visible
      cubit.updateStatus('pending');
      expect(cubit.state.isQuantityVisible, isTrue);
      expect(cubit.state.quantity, 10);

      // Changing to available keeps quantity visible
      cubit.updateStatus('available');
      expect(cubit.state.isQuantityVisible, isTrue);
      expect(cubit.state.quantity, 10);
    });

    test('initial product with out_of_stock sets quantity to 0 and isQuantityVisible to false', () {
      const outOfStockProduct = ProductEntity(
        id: 11,
        store: dummyStore,
        name: 'Drafting Board',
        description: 'Large drawing board',
        price: 99.0,
        quantityInStock: 20,
        sku: 'DFT-001',
        status: 'out_of_stock',
        categories: [],
      );
      final cubit = AddEditProductCubit(initialProduct: outOfStockProduct);
      expect(cubit.state.status, 'out_of_stock');
      expect(cubit.state.quantity, 0);
      expect(cubit.state.isQuantityVisible, isFalse);
    });

    test('submit validates required fields: name, price >= 0.01', () async {
      final repo = MockStoreRepo();
      final cubit = AddEditProductCubit(storeRepo: repo);

      // Name empty
      await cubit.submit();
      expect(cubit.state.errorMessage, 'Please enter a product name');
      expect(repo.lastAddedParams, isNull);

      // Price empty or invalid
      cubit.updateName('Valid Name');
      await cubit.submit();
      expect(cubit.state.errorMessage, 'Price must be at least 0.01');
      expect(repo.lastAddedParams, isNull);

      cubit.updatePrice('0.00');
      await cubit.submit();
      expect(cubit.state.errorMessage, 'Price must be at least 0.01');
      expect(repo.lastAddedParams, isNull);
    });

    test('submit successfully calls addProduct with correct parameters and formats', () async {
      final repo = MockStoreRepo();
      final cubit = AddEditProductCubit(storeRepo: repo);
      const cat = ProductCategoryEntity(id: 7, name: 'Rulers', slug: 'rulers');

      cubit.updateName('Architectural Scale Ruler');
      cubit.updateDescription('High precision triangular ruler');
      cubit.updatePrice('19.99');
      cubit.updateStatus('available');
      cubit.setQuantity(42);
      cubit.toggleCategory(cat);

      await cubit.submit();

      expect(cubit.state.errorMessage, isNull);
      expect(cubit.state.isSuccess, isTrue);
      expect(repo.lastAddedParams, isNotNull);
      expect(repo.lastAddedParams!.name, 'Architectural Scale Ruler');
      expect(repo.lastAddedParams!.description, 'High precision triangular ruler');
      expect(repo.lastAddedParams!.price, 19.99);
      expect(repo.lastAddedParams!.quantityInStock, 42);
      expect(repo.lastAddedParams!.status, 'available');
      expect(repo.lastAddedParams!.categoryIds, [7]);
    });

    test('submit sends quantity 0 when status is out_of_stock and null when status is empty', () async {
      final repo = MockStoreRepo();
      final cubit = AddEditProductCubit(storeRepo: repo);

      cubit.updateName('Out of Stock Item');
      cubit.updatePrice('5.0');
      // Status empty -> sends status null
      await cubit.submit();
      expect(repo.lastAddedParams!.status, isNull);

      // Status out_of_stock -> sends quantity 0
      cubit.updateStatus('out_of_stock');
      await cubit.submit();
      expect(repo.lastAddedParams!.status, 'out_of_stock');
      expect(repo.lastAddedParams!.quantityInStock, 0);
    });

    test('submit handles failure response gracefully', () async {
      final repo = MockStoreRepo();
      repo.addProductResponse = left(const ServerFailure(message: 'Server error while creating product'));
      final cubit = AddEditProductCubit(storeRepo: repo);

      cubit.updateName('Item');
      cubit.updatePrice('10');
      await cubit.submit();

      expect(cubit.state.isSuccess, isFalse);
      expect(cubit.state.errorMessage, 'Server error while creating product');
    });

    test('delete successfully calls deleteProduct on repo when initialProduct has id', () async {
      final repo = MockStoreRepo();
      final cubit = AddEditProductCubit(
        storeRepo: repo,
        initialProduct: sampleProduct,
      );

      await cubit.delete();

      expect(repo.lastDeletedProductId, sampleProduct.id);
      expect(cubit.state.isDeleting, isFalse);
      expect(cubit.state.isSuccess, isTrue);
      expect(cubit.state.errorMessage, isNull);
    });

    test('delete handles failure from repo', () async {
      final repo = MockStoreRepo();
      repo.deleteProductResponse = left(const ServerFailure(message: 'Cannot delete product'));
      final cubit = AddEditProductCubit(
        storeRepo: repo,
        initialProduct: sampleProduct,
      );

      await cubit.delete();

      expect(cubit.state.isDeleting, isFalse);
      expect(cubit.state.isSuccess, isFalse);
      expect(cubit.state.errorMessage, 'Cannot delete product');
    });

    test('delete without initialProduct sets error message', () async {
      final repo = MockStoreRepo();
      final cubit = AddEditProductCubit(storeRepo: repo);

      await cubit.delete();

      expect(cubit.state.errorMessage, 'Cannot delete a product without an ID');
      expect(repo.lastDeletedProductId, isNull);
    });

    test('submit in edit mode calls editProduct with EditProductParams and nullable fields', () async {
      final repo = MockStoreRepo();
      final cubit = AddEditProductCubit(
        storeRepo: repo,
        initialProduct: sampleProduct,
      );

      cubit.updateName('Updated Ruler');
      cubit.updatePrice('15.5');
      cubit.updateDescription('Updated description');
      cubit.updateStatus('available');
      cubit.setQuantity(10);

      await cubit.submit();

      expect(cubit.state.errorMessage, isNull);
      expect(cubit.state.isSuccess, isTrue);
      expect(repo.lastEditedParams, isNotNull);
      expect(repo.lastEditedParams!.id, sampleProduct.id);
      expect(repo.lastEditedParams!.name, 'Updated Ruler');
      expect(repo.lastEditedParams!.price, 15.5);
      expect(repo.lastEditedParams!.description, 'Updated description');
      expect(repo.lastEditedParams!.quantityInStock, 10);
      expect(repo.lastEditedParams!.status, 'available');
      expect(repo.lastEditedParams!.imagePaths, isNull);
    });

    test('addImages and removeImage are no-ops in edit mode', () {
      const productWithMedia = ProductEntity(
        id: 10,
        store: dummyStore,
        name: 'Ruler',
        description: 'Durable',
        price: 10.0,
        quantityInStock: 50,
        sku: 'RUL-001',
        status: 'available',
        imageUrl: 'https://example.com/photo.jpg',
      );
      final cubit = AddEditProductCubit(initialProduct: productWithMedia);
      expect(cubit.state.images.length, 1);
      cubit.addImages(['/some/path/image.jpg']);
      expect(cubit.state.images.length, 1);
      cubit.removeImage(0);
      expect(cubit.state.images.length, 1);
    });

    test('submit in edit mode handles failure gracefully', () async {
      final repo = MockStoreRepo();
      repo.editProductResponse = left(const ServerFailure(message: 'Failed to update product'));
      final cubit = AddEditProductCubit(
        storeRepo: repo,
        initialProduct: sampleProduct,
      );

      await cubit.submit();

      expect(cubit.state.isSuccess, isFalse);
      expect(cubit.state.errorMessage, 'Failed to update product');
    });
  });

  group('AddEditProductView Widget Tests', () {
    testWidgets('renders New Product mode correctly', (tester) async {
      await tester.pumpWidget(createTestWidget(const AddEditProductView()));
      await tester.pumpAndSettle();

      // Title
      expect(find.text('New Product'), findsOneWidget);

      // Section widgets
      expect(find.byType(ProductImagesSection), findsOneWidget);
      expect(find.text('Add Photos'), findsOneWidget);
      expect(find.text('Product Name'), findsOneWidget);
      expect(find.text('Describe your product'), findsOneWidget);
      expect(find.text('--- \$'), findsOneWidget);
      expect(find.text('Select status'), findsOneWidget);
      expect(find.text('Quantity'), findsOneWidget);
      expect(find.text('Search for Category'), findsOneWidget);

      // Action button: Only "Add Product" visible
      expect(find.widgetWithText(ElevatedButton, 'Add Product'), findsOneWidget);
      expect(find.text('Delete Product'), findsNothing);
      expect(find.text('Save Updates'), findsNothing);
    });

    testWidgets('renders Edit Product mode with initial product data and buttons', (tester) async {
      await tester.pumpWidget(
        createTestWidget(const AddEditProductView(product: sampleProduct)),
      );
      await tester.pumpAndSettle();

      // Title
      expect(find.text("Ruler's Details"), findsOneWidget);

      // Populated data
      expect(find.text('Ruler'), findsOneWidget);
      expect(find.text('10 \$'), findsOneWidget);
      expect(find.text('50'), findsOneWidget);

      // Category chips
      expect(find.text('Revit'), findsOneWidget);
      expect(find.text('AutoCAD'), findsOneWidget);

      // Buttons
      expect(find.widgetWithText(ElevatedButton, 'Delete Product'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Save Updates'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Add Product'), findsNothing);

      // Media editing hidden in edit mode
      expect(find.text('Add Photos'), findsNothing);
      expect(
        find.descendant(
          of: find.byType(ProductImagesSection),
          matching: find.byIcon(Icons.close),
        ),
        findsNothing,
      );
    });

    testWidgets('stepper increments and decrements quantity on screen', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createTestWidget(const AddEditProductView(product: sampleProduct)),
      );
      await tester.pumpAndSettle();

      expect(find.text('50'), findsOneWidget);

      // Tap + button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('51'), findsOneWidget);

      // Tap - button
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();
      expect(find.text('50'), findsOneWidget);
    });

    testWidgets('tapping Category opens CategorySearchBottomSheet and allows toggling', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget(const AddEditProductView()));
      await tester.pumpAndSettle();

      // Tap category field
      await tester.tap(find.text('Search for Category'));
      await tester.pumpAndSettle();

      // Bottom sheet is visible
      expect(find.text('Select Categories'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Revit'), findsOneWidget);
      expect(find.text('12 products'), findsOneWidget);

      // Select 'Revit'
      await tester.tap(find.text('Revit'));
      await tester.pumpAndSettle();

      // Tap Done
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // 'Revit' chip is now displayed on the main form
      expect(find.text('Revit'), findsOneWidget);

      // Tap the close icon on the chip to remove it
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Chip is removed, only search placeholder remains
      expect(find.text('Search for Category'), findsOneWidget);
    });

    testWidgets('quantity can be edited via keyboard beside buttons', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createTestWidget(const AddEditProductView(product: sampleProduct)),
      );
      await tester.pumpAndSettle();

      // Find the quantity text field (initialized to 50 for sampleProduct)
      final quantityField = find.widgetWithText(TextField, '50');
      expect(quantityField, findsOneWidget);

      // Type 75 using keyboard
      await tester.enterText(quantityField, '75');
      await tester.pumpAndSettle();
      expect(find.text('75'), findsOneWidget);

      // Tap + button after keyboard edit
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('76'), findsOneWidget);

      // Tap - button
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();
      expect(find.text('75'), findsOneWidget);
    });

    testWidgets('quantity field hides when status is out_of_stock and reappears for other statuses', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createTestWidget(const AddEditProductView(product: sampleProduct)),
      );
      await tester.pumpAndSettle();

      // Initially sampleProduct has status 'available' -> Quantity is visible
      expect(find.text('Quantity'), findsOneWidget);

      // Open status picker and select Out of Stock
      await tester.tap(find.text('Available'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Out of Stock'));
      await tester.pumpAndSettle();

      // Quantity field is hidden
      expect(find.text('Quantity'), findsNothing);

      // Open status picker and select Coming Soon
      await tester.tap(find.text('Out of Stock'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Coming Soon'));
      await tester.pumpAndSettle();

      // Quantity field is visible again
      expect(find.text('Quantity'), findsOneWidget);
    });
  });
}
