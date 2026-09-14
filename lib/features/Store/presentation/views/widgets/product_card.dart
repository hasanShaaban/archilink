import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product, this.onTap});

  final ProductEntity product;
  final VoidCallback? onTap;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late final PageController _pageController;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final product = widget.product;

    return Material(
      color: Colors.transparent,
      child: InkWell(
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
                  child: _buildImageSection(context, isDark),
                ),
              ),

              const SizedBox(height: 8),

              // // Page indicator dots
              // Center(
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: List.generate(totalDots, (index) {
              //       final isActive = index == _currentImageIndex;
              //       return Container(
              //         width: 6.5,
              //         height: 6.5,
              //         margin: const EdgeInsets.symmetric(horizontal: 3),
              //         decoration: BoxDecoration(
              //           shape: BoxShape.circle,
              //           color: isActive
              //               ? theme.colorScheme.onSurface
              //               : (isDark
              //                     ? const Color(0xFF6B6D72)
              //                     : const Color(0xFFB5B6B8)),
              //         ),
              //       );
              //     }),
              //   ),
              // ),
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
                    _StatusChip(
                      status: product.formattedStatus,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 6),
                    _LocationChip(location: product.location, isDark: isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, bool isDark) {
    if (widget.product.images.isEmpty) {
      return Container(
        color: isDark ? const Color(0xFF2B2C2E) : const Color(0xFFD9D9D9),
      );
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: widget.product.images.length,
      itemBuilder: (context, index) {
        final url = widget.product.images[index];
        if (url.startsWith('http')) {
          return CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: isDark ? const Color(0xFF2B2C2E) : const Color(0xFFD9D9D9),
            ),
            errorWidget: (context, url, error) => Container(
              color: isDark ? const Color(0xFF2B2C2E) : const Color(0xFFD9D9D9),
              child: const Icon(Icons.broken_image_outlined),
            ),
          );
        }
        return Container(
          color: isDark ? const Color(0xFF2B2C2E) : const Color(0xFFD9D9D9),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, required this.isDark});

  final String status;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final lower = status.toLowerCase();
    final Color bgColor;
    final Color borderColor;
    final Color textColor;

    if (lower.contains('available') || lower.contains('in stock')) {
      bgColor = isDark ? const Color(0xFF132A1C) : const Color(0xFFEAF7EE);
      borderColor = isDark ? const Color(0xFF2A593A) : const Color(0xFF8CD49E);
      textColor = isDark ? const Color(0xFF6EDC8E) : const Color(0xFF2E854B);
    } else if (lower.contains('out') || lower.contains('sold')) {
      bgColor = isDark ? const Color(0xFF2B181A) : const Color(0xFFFDF0F1);
      borderColor = isDark ? const Color(0xFF6B2D33) : const Color(0xFFF1AAB1);
      textColor = isDark ? const Color(0xFFEA707D) : const Color(0xFFC73644);
    } else {
      // 'Coming Soon' / pending / default warm gold
      bgColor = isDark ? const Color(0xFF2C2415) : const Color(0xFFFBF4E7);
      borderColor = isDark ? const Color(0xFF7A5F26) : const Color(0xFFE2C98F);
      textColor = isDark ? const Color(0xFFE6BA62) : const Color(0xFFBF8835);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        status,
        style: AppTextStyle.interMedium10.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _LocationChip extends StatelessWidget {
  const _LocationChip({required this.location, required this.isDark});

  final String location;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final grayColor = AppColorsFromTheme.grayForText(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColorsFromTheme.borderColor(
            context,
          ).withValues(alpha: isDark ? 0.4 : 0.7),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on_outlined, size: 12, color: grayColor),
          const SizedBox(width: 3),
          Text(
            location,
            style: AppTextStyle.interRegular10.copyWith(
              color: grayColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
