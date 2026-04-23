import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class FilterOptionContainer extends StatelessWidget {
  const FilterOptionContainer({
    super.key,
    required this.title,
    required this.onTap,
    required this.borderColor,
    this.selectedOptionText,
    required this.backgroundColor,
  });
  final String title;
  final VoidCallback onTap;
  final Color borderColor;
  final String? selectedOptionText;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: backgroundColor,
          border: Border.all(color: borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6.5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: AppTextStyle.interMedium12),
              if (selectedOptionText != null &&
                  selectedOptionText!.isNotEmpty) ...[
                const SizedBox(width: 6),
                Text(
                  selectedOptionText!,
                  style: AppTextStyle.interMedium12.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
              const SizedBox(width: 10),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
