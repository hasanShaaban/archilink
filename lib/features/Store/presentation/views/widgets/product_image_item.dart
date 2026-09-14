import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductImageItem extends StatelessWidget {
  const ProductImageItem({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderColor,
  });

  final String imageUrl;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? placeholderColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBgColor = placeholderColor ??
        (isDark ? const Color(0xFF2B2C2E) : const Color(0xFFD9D9D9));

    Widget imageWidget;
    if (imageUrl.isNotEmpty && imageUrl.startsWith('http')) {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        placeholder: (context, url) => Container(color: defaultBgColor),
        errorWidget: (context, url, error) => Container(
          color: defaultBgColor,
          child: Icon(
            Icons.broken_image_outlined,
            color: isDark ? const Color(0xFF6B6D72) : const Color(0xFF989898),
          ),
        ),
      );
    } else {
      imageWidget = Container(
        color: defaultBgColor,
        child: Icon(
          Icons.image_outlined,
          color: isDark ? const Color(0xFF6B6D72) : const Color(0xFF989898),
        ),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }
    return imageWidget;
  }
}
