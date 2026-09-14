import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/widgets/main_appbar.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/store_feed_cubit.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/store_feed_state.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          onRefresh: _handleRefresh,
          child: BlocBuilder<StoreFeedCubit, StoreFeedState>(
            builder: (context, state) {
              final isSkeleton = state.isLoading && !state.hasProducts;
              final products = isSkeleton
                  ? ProductEntity.dummyProducts
                  : state.products;

              if (state.errorMessage != null && !state.hasProducts) {
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    const MainAppBar(withTabbar: false),
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
                                state.errorMessage!,
                                style: AppTextStyle.interMedium14.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => context
                                    .read<StoreFeedCubit>()
                                    .fetchProducts(refresh: true),
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

              if (!state.isLoading && !state.hasProducts) {
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    const MainAppBar(withTabbar: false),
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

              return Skeletonizer(
                enabled: isSkeleton,
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    const MainAppBar(withTabbar: false),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                              onTap: () {
                                // Handle product tap
                              },
                            );
                          },
                          childCount: products.length,
                        ),
                      ),
                    ),
                    if (state.isLoadingMore)
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
            },
          ),
        ),
      ),
    );
  }
}
