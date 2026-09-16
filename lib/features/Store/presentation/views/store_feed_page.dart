import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/store_feed_cubit.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/store_feed_state.dart';
import 'package:archilink/features/Store/presentation/views/product_details_view.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_card.dart';
import 'package:archilink/features/Store/presentation/views/widgets/store_search_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StoreFeedPage extends StatelessWidget {
  const StoreFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StoreFeedCubit>()..fetchProducts(),
      child: const _StoreFeedBody(),
    );
  }
}

class _StoreFeedBody extends StatefulWidget {
  const _StoreFeedBody();

  @override
  State<_StoreFeedBody> createState() => _StoreFeedBodyState();
}

class _StoreFeedBodyState extends State<_StoreFeedBody> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final cubit = context.read<StoreFeedCubit>();
    final state = cubit.state;

    if (!state.hasMore || state.isLoading || state.isLoadingMore) {
      return;
    }

    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= threshold) {
      cubit.fetchProducts();
    }
  }

  Future<void> _handleRefresh() async {
    await context.read<StoreFeedCubit>().fetchProducts(refresh: true);
  }

  void _navigateToProductDetails(ProductEntity product) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: ProductDetailsView(product: product),
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Replaced MainAppBar with StoreSearchAppBar and expandable filter options
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
              child: StoreSearchAppBar(
                onSearchChanged: (query) {
                  // Ready for search integration
                },
                onFilterChanged: ({category, status, minPrice, maxPrice}) {
                  // Ready for filter integration
                },
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: Theme.of(context).colorScheme.primary,
                onRefresh: _handleRefresh,
                child: BlocBuilder<StoreFeedCubit, StoreFeedState>(
                  builder: (context, state) {
                    if (state.errorMessage != null && !state.hasProducts) {
                      return _StoreFeedErrorView(
                        errorMessage: state.errorMessage!,
                        onRetry: _handleRefresh,
                      );
                    }

                    if (!state.isLoading && !state.hasProducts) {
                      return const _StoreFeedEmptyView();
                    }

                    final isSkeleton = state.isLoading && !state.hasProducts;
                    final products = isSkeleton
                        ? ProductEntity.dummyProducts
                        : state.products;

                    return _StoreProductsGrid(
                      scrollController: _scrollController,
                      products: products,
                      isSkeleton: isSkeleton,
                      isLoadingMore: state.isLoadingMore,
                      onProductTap: _navigateToProductDetails,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreProductsGrid extends StatelessWidget {
  const _StoreProductsGrid({
    required this.scrollController,
    required this.products,
    required this.isSkeleton,
    required this.isLoadingMore,
    required this.onProductTap,
  });

  final ScrollController scrollController;
  final List<ProductEntity> products;
  final bool isSkeleton;
  final bool isLoadingMore;
  final ValueChanged<ProductEntity> onProductTap;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isSkeleton,
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                childAspectRatio: 0.52,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = products[index];
                  return ProductCard(
                    product: product,
                    onTap: () => onProductTap(product),
                  );
                },
                childCount: products.length,
              ),
            ),
          ),
          if (isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }
}

class _StoreFeedErrorView extends StatelessWidget {
  const _StoreFeedErrorView({
    required this.errorMessage,
    required this.onRetry,
  });

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    errorMessage,
                    style: AppTextStyle.interMedium14.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: onRetry,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StoreFeedEmptyView extends StatelessWidget {
  const _StoreFeedEmptyView();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.storefront_outlined,
                  size: 56,
                  color: AppColorsFromTheme.grayForText(context),
                ),
                const SizedBox(height: 12),
                Text(
                  'No products available yet',
                  style: AppTextStyle.interMedium14.copyWith(
                    color: AppColorsFromTheme.grayForText(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
