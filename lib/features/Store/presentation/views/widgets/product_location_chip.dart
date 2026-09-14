import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class ProductLocationChip extends StatelessWidget {
  const ProductLocationChip({
    super.key,
    required this.location,
    this.padding = const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
    this.alignment,
  });

  final String location;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final grayColor = AppColorsFromTheme.grayForText(context);

    return Container(
      padding: padding,
      alignment: alignment,
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
        mainAxisSize: alignment != null ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: alignment != null
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Icon(Icons.location_on_outlined, size: 12, color: grayColor),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              location,
              style: AppTextStyle.interRegular10.copyWith(
                color: grayColor,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
