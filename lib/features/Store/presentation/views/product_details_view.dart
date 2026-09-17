import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Store/domain/entity/product_category_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_category_chip.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_image_item.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_location_chip.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_page_indicator.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_status_chip.dart';
import 'package:archilink/features/Store/presentation/views/widgets/store_header_tile.dart';
import 'package:archilink/features/Profile/presentation/views/store_profile_view.dart';
import 'package:flutter/material.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key, required this.product});

  final ProductEntity product;

  static const String name = '/productDetails';

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  late final PageController _pageController;
  int _currentImageIndex = 0;

  List<String> get _images {
    if (widget.product.images.isNotEmpty) {
      return widget.product.images;
    }
    // Fallback placeholder items to match mockup presentation
    return const ['', '', ''];
  }

  List<ProductCategoryEntity> get _categories {
    if (widget.product.categories.isNotEmpty) {
      return widget.product.categories;
    }
    // Fallback sample categories for preview if none provided
    return const [
      ProductCategoryEntity(id: 1, name: 'Stationery', slug: 'stationery'),
      ProductCategoryEntity(id: 2, name: 'Rulers', slug: 'rulers'),
      ProductCategoryEntity(id: 3, name: 'Wood Tools', slug: 'wood-tools'),
    ];
  }

  @override
  void initState() {
    super.initState();
    final hasMultipleImages = _images.length > 1;
    _pageController = PageController(
      viewportFraction: hasMultipleImages ? 0.47 : 1.0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final product = widget.product;
    final images = _images;
    final categories = _categories;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "${product.name}'s Details",
          style: AppTextStyle.interSemiBold16.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        titleSpacing: 0,
        centerTitle: false,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductCard(
                context,
                product,
                images,
                categories,
                theme,
                isDark,
              ),
              const SizedBox(height: 20),
              _buildDescriptionSection(product, theme),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    ProductEntity product,
    List<String> images,
    List<ProductCategoryEntity> categories,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorsFromTheme.secondaryColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColorsFromTheme.borderColor(
            context,
          ).withValues(alpha: isDark ? 0.35 : 0.65),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store Header (Logo + Name + Username) — tapping navigates to the store profile
          StoreHeaderTile(
            store: product.store,
            onTap: () {
              Navigator.of(context, rootNavigator: true).pushNamed(
                StoreProfileView.name,
                arguments: product.store,
              );
            },
          ),
          const SizedBox(height: 12),

          // Image Carousel
          _buildImageCarousel(images),
          const SizedBox(height: 12),

          // Page Indicator Dots
          ProductPageIndicator(
            itemCount: images.length,
            currentIndex: _currentImageIndex,
          ),
          const SizedBox(height: 12),

          // Product Name and Price
          _buildProductHeader(context, product, theme),
          const SizedBox(height: 6),

          // Quantity in Stock
          _buildQuantityInStock(context, product.quantityInStock, theme),

          // Categories wrapped together
          if (categories.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildCategories(categories),
          ],

          const SizedBox(height: 14),

          // Status and Location Chips
          _buildChipsRow(product),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(List<String> images) {
    return SizedBox(
      height: 155,
      child: PageView.builder(
        controller: _pageController,
        padEnds: false,
        itemCount: images.length,
        onPageChanged: (index) {
          setState(() {
            _currentImageIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final url = images[index];
          return Padding(
            padding: EdgeInsets.only(
              right: images.length > 1 ? 10 : 0,
            ),
            child: ProductImageItem(
              imageUrl: url,
              borderRadius: BorderRadius.circular(14),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductHeader(
    BuildContext context,
    ProductEntity product,
    ThemeData theme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            product.name,
            style: AppTextStyle.interSemiBold16.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${product.price.toStringAsFixed(2)} ${product.currency}',
          style: AppTextStyle.interBold20.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityInStock(
    BuildContext context,
    int quantity,
    ThemeData theme,
  ) {
    final grayColor = AppColorsFromTheme.grayForText(context);
    final inStock = quantity > 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.inventory_2_outlined,
          size: 14,
          color: inStock ? grayColor : theme.colorScheme.error,
        ),
        const SizedBox(width: 5),
        Text(
          inStock ? '$quantity in stock' : 'Out of stock',
          style: AppTextStyle.interMedium12.copyWith(
            color: inStock ? grayColor : theme.colorScheme.error,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCategories(List<ProductCategoryEntity> categories) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: categories.map((category) {
        return ProductCategoryChip(name: category.name);
      }).toList(),
    );
  }

  Widget _buildChipsRow(ProductEntity product) {
    return Row(
      children: [
        Expanded(
          child: ProductStatusChip(
            status: product.formattedStatus,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            alignment: Alignment.center,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ProductLocationChip(
            location: product.location,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            alignment: Alignment.center,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(ProductEntity product, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: AppTextStyle.interBold20.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          product.description.trim().isNotEmpty
              ? product.description
              : 'No description available.',
          style: AppTextStyle.interRegular14.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
