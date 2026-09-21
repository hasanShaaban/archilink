import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Post/domain/entity/pagination_entity.dart';
import 'package:archilink/features/Store/domain/entity/add_product_params.dart';
import 'package:archilink/features/Store/domain/entity/edit_product_params.dart';
import 'package:archilink/features/Store/domain/entity/category_feed_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_category_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_feed_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_store_entity.dart';
import 'package:archilink/features/Store/domain/repo/store_repo.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/store_feed_cubit.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/store_feed_state.dart';
import 'package:archilink/features/Store/presentation/views/widgets/category_search_bottom_sheet.dart';
import 'package:archilink/features/Store/presentation/views/widgets/store_search_app_bar.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                  username: 'testStore',
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

  @override
  Future<Either<Failure, CategoryFeedEntity>> getCategories({int page = 1}) async {
    return right(const CategoryFeedEntity(
      categories: [
        ProductCategoryEntity(id: 1, name: 'Revit', slug: 'revit', productsCount: 5),
      ],
      pagination: PaginationEntity(
        currentPage: 1,
        perPage: 20,
        lastPage: 1,
        total: 1,
        hasMore: false,
      ),
    ));
  }

  @override
  Future<Either<Failure, ProductEntity>> addProduct(AddProductParams params) async {
    return left(UnknownFailure());
  }

  @override
  Future<Either<Failure, ProductEntity>> editProduct(EditProductParams params) async {
    return left(UnknownFailure());
  }

  @override
  Future<Either<Failure, bool>> deleteProduct(int id) async {
    return right(true);
  }

  String? lastSearchQuery;
  String? lastMinPrice;
  String? lastMaxPrice;
  int? lastSearchPage;
  Either<Failure, ProductFeedEntity>? searchResponse;

  @override
  Future<Either<Failure, ProductFeedEntity>> searchProducts({
    String? query,
    String? minPrice,
    String? maxPrice,
    int page = 1,
  }) async {
    lastSearchQuery = query;
    lastMinPrice = minPrice;
    lastMaxPrice = maxPrice;
    lastSearchPage = page;
    return searchResponse ?? response ?? right(
      ProductFeedEntity(
        products: [
          ProductEntity(
            id: 990 + page,
            store: const ProductStoreEntity(
              id: 1,
              name: 'Test Store',
              username: 'testStore',
            ),
            name: 'Search Result $page',
            description: 'Description $page',
            price: 50.0,
            quantityInStock: 10,
            sku: 'SEARCH-$page',
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

  test('StoreFeedCubit fetchCategories fetches categories and updates state', () async {
    final repo = MockStoreRepo();
    final cubit = StoreFeedCubit(repo);

    await cubit.fetchCategories();

    expect(cubit.state.isLoadingCategories, false);
    expect(cubit.state.availableCategories.length, 1);
    expect(cubit.state.availableCategories.first.name, 'Revit');
    expect(cubit.state.categoriesCurrentPage, 2);
    expect(cubit.state.categoriesHasMore, false);
  });

  test('StoreFeedCubit toggleCategory, removeCategory, and clearCategories work correctly', () {
    final repo = MockStoreRepo();
    final cubit = StoreFeedCubit(repo);
    const cat1 = ProductCategoryEntity(id: 1, name: 'Revit', slug: 'revit', productsCount: 5);
    const cat2 = ProductCategoryEntity(id: 2, name: 'AutoCAD', slug: 'autocad', productsCount: 3);

    // Toggle cat1 on
    cubit.toggleCategory(cat1);
    expect(cubit.state.selectedCategories, [cat1]);

    // Toggle cat2 on
    cubit.toggleCategory(cat2);
    expect(cubit.state.selectedCategories, [cat1, cat2]);

    // Toggle cat1 off
    cubit.toggleCategory(cat1);
    expect(cubit.state.selectedCategories, [cat2]);

    // Remove cat2
    cubit.removeCategory(cat2);
    expect(cubit.state.selectedCategories, isEmpty);

    // Add both and clear
    cubit.toggleCategory(cat1);
    cubit.toggleCategory(cat2);
    expect(cubit.state.selectedCategories.length, 2);
    cubit.clearCategories();
    expect(cubit.state.selectedCategories, isEmpty);
  });

  test('StoreFeedCubit search query filters availableCategories', () {
    final repo = MockStoreRepo();
    final cubit = StoreFeedCubit(repo);
    const cat1 = ProductCategoryEntity(id: 1, name: 'Architecture', slug: 'arch', productsCount: 5);
    const cat2 = ProductCategoryEntity(id: 2, name: 'Drawing Tools', slug: 'draw', productsCount: 3);

    cubit.emit(cubit.state.copyWith(availableCategories: [cat1, cat2]));
    expect(cubit.state.filteredCategories.length, 2);

    cubit.setCategorySearchQuery('arch');
    expect(cubit.state.filteredCategories, [cat1]);

    cubit.setCategorySearchQuery('tools');
    expect(cubit.state.filteredCategories, [cat2]);

    cubit.setCategorySearchQuery('');
    expect(cubit.state.filteredCategories.length, 2);
  });

  group('StoreSearchAppBar & Category Selection Widget Tests', () {
    const cat1 = ProductCategoryEntity(id: 1, name: 'Architecture', slug: 'arch', productsCount: 5);
    const cat2 = ProductCategoryEntity(id: 2, name: 'Drawing Tools', slug: 'draw', productsCount: 3);

    testWidgets('StoreSearchAppBar renders Category chip and chosen category chips', (tester) async {
      ProductCategoryEntity? removedCategory;
      bool categoryOptionTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StoreSearchAppBar(
              selectedCategories: const [cat1, cat2],
              onCategoryRemoved: (cat) => removedCategory = cat,
              onCategoryOptionTap: () => categoryOptionTapped = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open filters row by tapping filter icon
      await tester.tap(find.byIcon(Icons.tune_rounded).first);
      await tester.pumpAndSettle();

      // Filter chip shows count
      expect(find.text('Categories (2)'), findsOneWidget);

      // Selected category chips under filters row
      expect(find.text('Architecture'), findsOneWidget);
      expect(find.text('Drawing Tools'), findsOneWidget);

      // Tap Category option
      await tester.tap(find.text('Categories (2)'));
      await tester.pumpAndSettle();
      expect(categoryOptionTapped, isTrue);

      // Tap remove on Architecture chip
      final closeButtons = find.byIcon(Icons.close_rounded);
      expect(closeButtons, findsNWidgets(2));
      await tester.tap(closeButtons.first);
      expect(removedCategory, cat1);
    });

    testWidgets('CategorySearchBottomSheet.showForStoreFeed fetches categories and allows selection', (tester) async {
      final repo = MockStoreRepo();
      final cubit = StoreFeedCubit(repo);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => CategorySearchBottomSheet.showForStoreFeed(context),
                  child: const Text('Open Sheet'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open bottom sheet
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // Pre-fetched categories displayed
      expect(find.text('Select Categories'), findsOneWidget);
      expect(find.text('Revit'), findsOneWidget);

      // Toggle category
      await tester.tap(find.text('Revit'));
      await tester.pumpAndSettle();

      expect(cubit.state.selectedCategories.length, 1);
      expect(cubit.state.selectedCategories.first.name, 'Revit');

      // Tap Done
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Sheet dismissed
      expect(find.text('Select Categories'), findsNothing);
    });

    test('StoreFeedCubit setSearchQuery triggers debounced searchProducts', () async {
      final repo = MockStoreRepo();
      final cubit = StoreFeedCubit(repo, debounceDuration: const Duration(milliseconds: 50));

      cubit.setSearchQuery('Wireless');
      expect(cubit.state.searchQuery, 'Wireless');
      expect(cubit.state.isSearchActive, isTrue);

      // Not called immediately
      expect(repo.lastSearchQuery, isNull);

      // Wait for debounce
      await Future<void>.delayed(const Duration(milliseconds: 60));

      expect(repo.lastSearchQuery, 'Wireless');
      expect(cubit.state.products.length, 1);
      expect(cubit.state.products.first.name, 'Search Result 1');

      await cubit.close();
    });

    test('StoreFeedCubit setPriceFilters updates filters and re-fetches search when query active', () async {
      final repo = MockStoreRepo();
      final cubit = StoreFeedCubit(repo);

      // Search active
      cubit.setSearchQuery('laptop', immediate: true);
      await Future<void>.delayed(Duration.zero);

      cubit.setPriceFilters(minPrice: '20.00', maxPrice: '120');
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.minPrice, '20.00');
      expect(cubit.state.maxPrice, '120');
      expect(cubit.state.isSearchActive, isTrue);

      expect(repo.lastSearchQuery, 'laptop');
      expect(repo.lastMinPrice, '20.00');
      expect(repo.lastMaxPrice, '120');
      expect(cubit.state.products.length, 1);

      await cubit.close();
    });

    test('StoreFeedCubit clearing search query returns immediately to global product feed', () async {
      final repo = MockStoreRepo();
      final cubit = StoreFeedCubit(repo);

      // Start search
      cubit.setSearchQuery('keyboard', immediate: true);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.isSearchActive, isTrue);
      expect(cubit.state.products.first.name, 'Search Result 1');

      // Clear search query (user deleted everything)
      cubit.setSearchQuery('');
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.searchQuery, '');
      expect(cubit.state.isSearchActive, isFalse);
      // Returns to global product feed
      expect(cubit.state.products.first.name, 'Product 1');

      await cubit.close();
    });

    test('StoreFeedCubit paginates via searchProducts when search is active', () async {
      final repo = MockStoreRepo();
      final cubit = StoreFeedCubit(repo);

      cubit.setSearchQuery('keyboard', immediate: true);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.currentPage, 1);
      expect(cubit.state.hasMore, isTrue);

      await cubit.fetchProducts();

      expect(repo.lastSearchPage, 2);
      expect(cubit.state.currentPage, 2);
      expect(cubit.state.products.length, 2);

      await cubit.close();
    });

    test('StoreFeedCubit clearSearchAndFilters resets search state and re-fetches feed', () async {
      final repo = MockStoreRepo();
      final cubit = StoreFeedCubit(repo);

      cubit.setSearchQuery('test', immediate: true);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.isSearchActive, isTrue);

      cubit.clearSearchAndFilters();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.searchQuery, '');
      expect(cubit.state.minPrice, isNull);
      expect(cubit.state.maxPrice, isNull);
      expect(cubit.state.isSearchActive, isFalse);
      expect(cubit.state.products.first.name, 'Product 1');

      await cubit.close();
    });

    testWidgets('StoreSearchAppBar search input, clear button, and filter callbacks work as expected', (tester) async {
      String? changedQuery;
      String? changedMinPrice;
      String? changedMaxPrice;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StoreSearchAppBar(
              onSearchChanged: (q) => changedQuery = q,
              onFilterChanged: ({categories, category, maxPrice, minPrice, status}) {
                changedMinPrice = minPrice;
                changedMaxPrice = maxPrice;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextField), 'Keyboard');
      expect(changedQuery, 'Keyboard');
      await tester.pumpAndSettle();

      // Close icon appears
      final closeIcon = find.byIcon(Icons.close_rounded);
      expect(closeIcon, findsOneWidget);

      // Tap close icon to clear
      await tester.tap(closeIcon);
      await tester.pumpAndSettle();
      expect(changedQuery, '');
      expect(find.byIcon(Icons.close_rounded), findsNothing);

      // Expand filters
      await tester.tap(find.byIcon(Icons.tune_rounded).first);
      await tester.pumpAndSettle();

      // Tap Min Price filter chip
      await tester.tap(find.text('Min Price'));
      await tester.pumpAndSettle();

      // Select '50'
      await tester.tap(find.text('50').last);
      await tester.pumpAndSettle();
      expect(changedMinPrice, '50');

      // Tap Max Price filter chip
      await tester.tap(find.text('Max Price'));
      await tester.pumpAndSettle();

      // Select '200'
      await tester.tap(find.text('200').last);
      await tester.pumpAndSettle();
      expect(changedMaxPrice, '200');
    });
  });
}
