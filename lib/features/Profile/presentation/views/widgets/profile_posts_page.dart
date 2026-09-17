import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Home/presentation/views/widgets/post_list_view.dart';
import 'package:archilink/features/Profile/domain/entity/profile_type.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/presentation/views/product_details_view.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_card.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfilePostsPage extends StatelessWidget {
  const ProfilePostsPage({
    super.key,
    required this.width,
    required this.height,
    this.postsVisible = true,
    this.type,
  });

  final double width;
  final double height;
  final bool postsVisible;
  final ProfileType? type;

  bool get _isStore =>
      type == ProfileType.storeProfile ||
      type == ProfileType.personalStoreProfile;

  @override
  Widget build(BuildContext context) {
    if (!postsVisible) {
      return const _PrivateAccountMessage();
    }

    if (_isStore) {
      return _StoreProductsGrid(
        type: type,
      );
    }

    var lang = S.of(context);
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return PostListView(
          lang: lang,
          width: width,
          height: height,
          posts: state.profilePosts,
          isInitialLoading: state.isInitialLoading,
          isLoadingMore: state.isLoadingMore,
          failureMessage: state.failure?.message,
          onLoadMore: () =>
              context.read<ProfileBloc>().add(LoadMoreProfilePosts()),
        );
      },
    );
  }
}

class _StoreProductsGrid extends StatefulWidget {
  const _StoreProductsGrid({required this.type});

  final ProfileType? type;

  @override
  State<_StoreProductsGrid> createState() => _StoreProductsGridState();
}

class _StoreProductsGridState extends State<_StoreProductsGrid> {
  ScrollController? _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _controller = PrimaryScrollController.maybeOf(context);
      _controller?.addListener(_onScroll);
    });
  }

  void _onScroll() {
    if (_controller == null || !_controller!.hasClients) return;
    if (_controller!.position.pixels >=
        _controller!.position.maxScrollExtent - 150) {
      context.read<ProfileBloc>().add(const LoadMoreProfileProducts());
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onScroll);
    super.dispose();
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    ProductEntity product,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to remove "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<ProfileBloc>().add(
            DeleteProfileProduct(productId: product.id),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product "${product.name}" removed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMyStore = widget.type == ProfileType.personalStoreProfile;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.failure != null && state.profileProducts.isEmpty) {
          return Center(child: Text(state.failure!.message));
        }

        final isSkeleton =
            state.isInitialLoading && state.profileProducts.isEmpty;
        final products =
            isSkeleton ? ProductEntity.dummyProducts : state.profileProducts;

        if (!isSkeleton && state.profileProducts.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'No products available yet',
                style: AppTextStyle.interMedium16.copyWith(
                  color: AppColorsFromTheme.grayForText(context),
                ),
              ),
            ),
          );
        }

        return Skeletonizer(
          enabled: isSkeleton,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 150) {
                context.read<ProfileBloc>().add(
                      const LoadMoreProfileProducts(),
                    );
              }
              return false;
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
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
                      childAspectRatio: 0.50,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = products[index];
                        return ProductCard(
                          product: product,
                          showMenu: isMyStore && !isSkeleton,
                          onTap: isSkeleton
                              ? null
                              : () {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pushNamed(
                                    ProductDetailsView.name,
                                    arguments: product,
                                  );
                                },
                          onEdit: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Edit ${product.name}')),
                            );
                          },
                          onDelete: () => _showDeleteDialog(context, product),
                        );
                      },
                      childCount: products.length,
                    ),
                  ),
                ),
                if (state.isLoadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PrivateAccountMessage extends StatelessWidget {
  const _PrivateAccountMessage();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 56,
            color: colorScheme.onSurface.withOpacity(0.35),
          ),
          const SizedBox(height: 16),
          Text(
            'This account is private',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Follow this account to see their posts.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.55),
            ),
          ),
        ],
      ),
    );
  }
}
