import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class YearPickerRow extends StatelessWidget {
  const YearPickerRow({
    super.key,
    required this.title,
    required this.valueText,
    required this.onTap,
  });

  final String title;
  final String valueText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyle.interMedium12.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              valueText,
              style: AppTextStyle.interRegular12.copyWith(
                color: AppColorsFromTheme.grayForText(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
