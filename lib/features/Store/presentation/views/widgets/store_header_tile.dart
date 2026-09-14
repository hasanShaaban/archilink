import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Store/domain/entity/product_store_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StoreHeaderTile extends StatelessWidget {
  const StoreHeaderTile({
    super.key,
    required this.store,
    this.logoSize = 36.0,
    this.onTap,
  });

  final ProductStoreEntity store;
  final double logoSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final grayColor = AppColorsFromTheme.grayForText(context);
    final logoUrl = store.storeLogoUrl;
    final hasLogo = logoUrl != null &&
        logoUrl.isNotEmpty &&
        logoUrl.startsWith('http');

    final content = Row(
      children: [
        // Store Logo (small, not too big)
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? const Color(0xFF2B2C2E) : const Color(0xFFE8E8E8),
            border: Border.all(
              color: AppColorsFromTheme.borderColor(context).withValues(
                alpha: isDark ? 0.35 : 0.65,
              ),
              width: 1,
            ),
          ),
          child: ClipOval(
            child: hasLogo
                ? CachedNetworkImage(
                    imageUrl: logoUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: isDark
                          ? const Color(0xFF2B2C2E)
                          : const Color(0xFFE8E8E8),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.storefront_outlined,
                      size: logoSize * 0.5,
                      color: grayColor,
                    ),
                  )
                : Icon(
                    Icons.storefront_outlined,
                    size: logoSize * 0.5,
                    color: grayColor,
                  ),
          ),
        ),
        const SizedBox(width: 10),

        // Store name (bold) & store username beneath (regular and gray)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                store.name,
                style: AppTextStyle.interSemiBold14.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '@${store.handle.isNotEmpty ? store.handle : store.name}',
                style: AppTextStyle.interRegular12.copyWith(
                  color: grayColor,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: content,
      );
    }

    return content;
  }
}
