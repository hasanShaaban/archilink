import 'package:archilink/features/Post/domain/entity/pagination_entity.dart';
import 'package:archilink/features/Store/data/models/category_feed_model.dart';
import 'package:archilink/features/Store/domain/entity/category_feed_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_category_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_store_entity.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/add_edit_product_cubit.dart';
import 'package:archilink/features/Store/presentation/views/add_edit_product_view.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_images_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Store/data/models/product_category_model.dart';
import 'package:archilink/features/Store/domain/entity/product_feed_entity.dart';
import 'package:archilink/features/Store/domain/repo/store_repo.dart';
import 'package:dartz/dartz.dart';

class MockStoreRepo implements StoreRepo {
  Either<Failure, ProductFeedEntity>? feedResponse;
  Either<Failure, CategoryFeedEntity>? categoriesResponse;
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
}

void main() {
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
  });
}
