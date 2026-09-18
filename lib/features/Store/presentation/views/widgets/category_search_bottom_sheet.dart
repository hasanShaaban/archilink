import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Store/domain/entity/product_category_entity.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/add_edit_product_cubit.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/add_edit_product_state.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/store_feed_cubit.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/store_feed_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategorySearchBottomSheet extends StatefulWidget {
  const CategorySearchBottomSheet({
    super.key,
    this.useStoreFeed = false,
  });

  final bool useStoreFeed;

  static Future<void> show(BuildContext context) {
    final cubit = context.read<AddEditProductCubit>();
    if (cubit.state.availableCategories.isEmpty && !cubit.state.isLoadingCategories) {
      cubit.fetchCategories();
    }
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: cubit,
        child: const CategorySearchBottomSheet(),
      ),
    );
  }

  static Future<void> showForStoreFeed(BuildContext context) {
    final cubit = context.read<StoreFeedCubit>();
    if (cubit.state.availableCategories.isEmpty && !cubit.state.isLoadingCategories) {
      cubit.fetchCategories();
    }
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: cubit,
        child: const CategorySearchBottomSheet(useStoreFeed: true),
      ),
    );
  }

  @override
  State<CategorySearchBottomSheet> createState() =>
      _CategorySearchBottomSheetState();
}

class _CategorySearchBottomSheetState extends State<CategorySearchBottomSheet> {
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final String searchQuery;
    final bool hasMore;
    final bool isLoading;
    final bool isLoadingMore;
    final VoidCallback fetchCallback;

    if (widget.useStoreFeed) {
      final cubit = context.read<StoreFeedCubit>();
      final state = cubit.state;
      searchQuery = state.categorySearchQuery;
      hasMore = state.categoriesHasMore;
      isLoading = state.isLoadingCategories;
      isLoadingMore = state.isLoadingMoreCategories;
      fetchCallback = cubit.fetchCategories;
    } else {
      final cubit = context.read<AddEditProductCubit>();
      final state = cubit.state;
      searchQuery = state.categorySearchQuery;
      hasMore = state.categoriesHasMore;
      isLoading = state.isLoadingCategories;
      isLoadingMore = state.isLoadingMoreCategories;
      fetchCallback = cubit.fetchCategories;
    }

    if (searchQuery.trim().isNotEmpty) return;
    if (!hasMore || isLoading || isLoadingMore) return;

    final threshold = _scrollController.position.maxScrollExtent - 150;
    if (_scrollController.position.pixels >= threshold) {
      fetchCallback();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useStoreFeed) {
      return BlocBuilder<StoreFeedCubit, StoreFeedState>(
        builder: (context, state) {
          final cubit = context.read<StoreFeedCubit>();
          return _buildContent(
            context,
            isLoadingCategories: state.isLoadingCategories,
            isLoadingMoreCategories: state.isLoadingMoreCategories,
            categoriesErrorMessage: state.categoriesErrorMessage,
            availableCategories: state.availableCategories,
            filteredCategories: state.filteredCategories,
            selectedCategories: state.selectedCategories,
            categorySearchQuery: state.categorySearchQuery,
            onSearchChanged: cubit.setCategorySearchQuery,
            onSearchClear: () => cubit.setCategorySearchQuery(''),
            onRetry: cubit.fetchCategories,
            onToggleCategory: cubit.toggleCategory,
          );
        },
      );
    }

    return BlocBuilder<AddEditProductCubit, AddEditProductState>(
      builder: (context, state) {
        final cubit = context.read<AddEditProductCubit>();
        return _buildContent(
          context,
          isLoadingCategories: state.isLoadingCategories,
          isLoadingMoreCategories: state.isLoadingMoreCategories,
          categoriesErrorMessage: state.categoriesErrorMessage,
          availableCategories: state.availableCategories,
          filteredCategories: state.filteredCategories,
          selectedCategories: state.selectedCategories,
          categorySearchQuery: state.categorySearchQuery,
          onSearchChanged: cubit.setCategorySearchQuery,
          onSearchClear: () => cubit.setCategorySearchQuery(''),
          onRetry: cubit.fetchCategories,
          onToggleCategory: cubit.toggleCategory,
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context, {
    required bool isLoadingCategories,
    required bool isLoadingMoreCategories,
    required String? categoriesErrorMessage,
    required List<ProductCategoryEntity> availableCategories,
    required List<ProductCategoryEntity> filteredCategories,
    required List<ProductCategoryEntity> selectedCategories,
    required String categorySearchQuery,
    required ValueChanged<String> onSearchChanged,
    required VoidCallback onSearchClear,
    required VoidCallback onRetry,
    required ValueChanged<ProductCategoryEntity> onToggleCategory,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final sheetHeight = mediaQuery.size.height * 0.72;

    return Container(
      height: sheetHeight,
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 44,
              height: 4.5,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF4A4A4A) : const Color(0xFFCCCCCC),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header with Title & Done button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Categories',
                  style: AppTextStyle.interSemiBold16.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6BBBAE).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Done',
                      style: AppTextStyle.interSemiBold14.copyWith(
                        color: const Color(0xFF008080),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              onChanged: onSearchChanged,
              style: AppTextStyle.interRegular14.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Search for category...',
                hintStyle: AppTextStyle.interRegular14.copyWith(
                  color: isDark ? const Color(0xFF8E8E93) : const Color(0xFFA0A0A0),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: isDark ? const Color(0xFF8E8E93) : const Color(0xFFA0A0A0),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          onSearchClear();
                        },
                      )
                    : null,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                filled: true,
                fillColor: isDark
                    ? const Color(0xFF242527)
                    : const Color(0xFFF2F2F2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColorsFromTheme.borderColor(context).withValues(alpha: 0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColorsFromTheme.borderColor(context).withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF6BBBAE),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Categories List
          Expanded(
            child: Builder(
              builder: (context) {
                if (isLoadingCategories) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6BBBAE)),
                    ),
                  );
                }

                if (categoriesErrorMessage != null && availableCategories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, size: 36, color: Colors.red),
                        const SizedBox(height: 8),
                        Text(
                          categoriesErrorMessage,
                          style: AppTextStyle.interRegular14.copyWith(
                            color: isDark ? const Color(0xFF8E8E93) : const Color(0xFFA0A0A0),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: onRetry,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (filteredCategories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 40,
                          color: isDark
                              ? const Color(0xFF636363)
                              : const Color(0xFFB5B6B8),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No categories found',
                          style: AppTextStyle.interRegular14.copyWith(
                            color: isDark
                                ? const Color(0xFF8E8E93)
                                : const Color(0xFFA0A0A0),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final showLoadingMore = isLoadingMoreCategories &&
                    categorySearchQuery.trim().isEmpty;

                return ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: filteredCategories.length + (showLoadingMore ? 1 : 0),
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: AppColorsFromTheme.borderColor(context).withValues(alpha: 0.4),
                  ),
                  itemBuilder: (context, index) {
                    if (index == filteredCategories.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF6BBBAE),
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    final category = filteredCategories[index];
                    final isSelected = selectedCategories
                        .any((c) => c.id == category.id);

                    return InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        onToggleCategory(category);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? const Color(0xFF6BBBAE)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF6BBBAE)
                                      : (isDark
                                          ? const Color(0xFF636363)
                                          : const Color(0xFFB5B6B8)),
                                  width: 1.5,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category.name,
                                    style: AppTextStyle.interMedium14.copyWith(
                                      color: theme.colorScheme.onSurface,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${category.productsCount} ${category.productsCount == 1 ? "product" : "products"}',
                                    style: AppTextStyle.interRegular12.copyWith(
                                      color: isDark
                                          ? const Color(0xFF8E8E93)
                                          : const Color(0xFFA0A0A0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF2C2D30)
                                    : const Color(0xFFEBEBEB),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${category.productsCount}',
                                style: AppTextStyle.interMedium10.copyWith(
                                  color: isDark
                                      ? const Color(0xFFCCCCCC)
                                      : const Color(0xFF636363),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
