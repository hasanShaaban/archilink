import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class ProductStatusChip extends StatelessWidget {
  const ProductStatusChip({
    super.key,
    required this.status,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    this.alignment,
  });

  final String status;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
      padding: padding,
      alignment: alignment,
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
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
