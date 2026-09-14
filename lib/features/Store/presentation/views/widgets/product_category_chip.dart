import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class ProductCategoryChip extends StatelessWidget {
  const ProductCategoryChip({
    super.key,
    required this.name,
    this.onTap,
  });

  final String name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColorsFromTheme.borderColor(context).withValues(
            alpha: isDark ? 0.35 : 0.65,
          ),
          width: 1,
        ),
      ),
      child: Text(
        name,
        style: AppTextStyle.interMedium12.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: chip,
      );
    }

    return chip;
  }
}
