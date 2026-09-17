import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_image_item.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_location_chip.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_page_indicator.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_status_chip.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.showMenu = false,
    this.onEdit,
    this.onDelete,
  });

  final ProductEntity product;
  final VoidCallback? onTap;
  final bool showMenu;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late final PageController _pageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildOptionsMenu(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        color: theme.scaffoldBackgroundColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppColorsFromTheme.borderColor(context).withValues(
              alpha: isDark ? 0.35 : 0.65,
            ),
          ),
        ),
        icon: Container(
          padding: const EdgeInsets.all(4),
          color: Colors.transparent,
          child: const Icon(
            Icons.more_vert,
            size: 20,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 4,
                color: Colors.black54,
              ),
            ],
          ),
        ),
        onSelected: (value) {
          if (value == 'edit') {
            widget.onEdit?.call();
          } else if (value == 'delete') {
            widget.onDelete?.call();
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            value: 'edit',
            child: Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: theme.colorScheme.onSurface,
                ),
                const SizedBox(width: 8),
                Text(
                  'Edit',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_outline, size: 18, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Delete',
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final product = widget.product;
    final totalDots = product.images.length;

    return Material(
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
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
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image section
                  AspectRatio(
                    aspectRatio: 1.05,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: _buildImageSection(),
                    ),
                  ),

              const SizedBox(height: 8),

              // Page indicator dots
              ProductPageIndicator(
                itemCount: totalDots,
                currentIndex: _currentImageIndex,
              ),

              const SizedBox(height: 8),

              // Item Name
              Text(
                product.name,
                style: AppTextStyle.interSemiBold16.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 2),

              // @store name
              Text(
                '@${product.storeName}',
                style: AppTextStyle.interRegular12.copyWith(
                  color: AppColorsFromTheme.grayForText(context),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Description
              Text(
                product.description,
                style: AppTextStyle.interRegular12.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const Spacer(),

              // Price
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${product.price.toStringAsFixed(2)} ${product.currency}',
                  style: AppTextStyle.interBold20.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Bottom status & location chips
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProductStatusChip(status: product.formattedStatus),
                    const SizedBox(width: 6),
                    ProductLocationChip(location: product.location),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      if (widget.showMenu)
        Positioned(
          top: 6,
          right: 6,
          child: _buildOptionsMenu(context),
        ),
    ],
  ),
);
  }

  Widget _buildImageSection() {
    if (widget.product.images.isEmpty) {
      return const ProductImageItem(imageUrl: '');
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: widget.product.images.length,
      onPageChanged: (index) {
        setState(() {
          _currentImageIndex = index;
        });
      },
      itemBuilder: (context, index) {
        return ProductImageItem(imageUrl: widget.product.images[index]);
      },
    );
  }
}
