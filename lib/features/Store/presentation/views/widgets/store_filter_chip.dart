import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class StoreFilterChip extends StatelessWidget {
  const StoreFilterChip({
    super.key,
    required this.label,
    required this.icon,
    this.options = const [],
    this.selectedValue,
    this.onSelected,
    this.isHighlighted = false,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String>? onSelected;
  final bool isHighlighted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = AppColorsFromTheme.primaryColor(context);
    final isSelected = selectedValue != null || isHighlighted;

    final borderColor = isSelected
        ? primaryColor
        : AppColorsFromTheme.borderColor(context).withValues(
            alpha: isDark ? 0.4 : 0.7,
          );

    final displayLabel = selectedValue ?? label;

    final chipContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor,
          width: isSelected ? 1.2 : 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            displayLabel,
            style: AppTextStyle.interMedium12.copyWith(
              color: isSelected ? primaryColor : theme.colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          const SizedBox(width: 5),
          Icon(
            icon,
            size: 15,
            color: isSelected ? primaryColor : AppColorsFromTheme.grayForText(context),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: chipContent,
        ),
      );
    }

    return PopupMenuButton<String>(
      tooltip: label,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColorsFromTheme.borderColor(context).withValues(
            alpha: isDark ? 0.35 : 0.65,
          ),
        ),
      ),
      color: theme.colorScheme.surface,
      onSelected: (value) {
        onSelected?.call(value);
      },
      itemBuilder: (context) {
        return options.map((option) {
          final isOptionSelected = option == selectedValue;
          return PopupMenuItem<String>(
            value: option,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  option,
                  style: AppTextStyle.interMedium14.copyWith(
                    color: isOptionSelected
                        ? primaryColor
                        : theme.colorScheme.onSurface,
                    fontWeight: isOptionSelected
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
                if (isOptionSelected)
                  Icon(Icons.check_rounded, size: 16, color: primaryColor),
              ],
            ),
          );
        }).toList();
      },
      child: chipContent,
    );
  }
}
