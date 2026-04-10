import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class EditProfilePopupField extends StatelessWidget {
  const EditProfilePopupField({
    super.key,
    required this.title,
    required this.value,
    required this.items,
    required this.onSelected,
    this.placeholder = 'Select',
    this.menuItems,
  });

  final String title;
  final String value;
  final List<String> items;
  final ValueChanged<String> onSelected;
  final String placeholder;
  final List<PopupMenuEntry<String>>? menuItems;

  @override
  Widget build(BuildContext context) {
    final displayValue = value.isEmpty ? placeholder : value;
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
          PopupMenuButton<String>(
            menuPadding: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            color: Theme.of(context).scaffoldBackgroundColor,
            elevation: 2,
            offset: const Offset(0, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.16),
              ),
            ),
            onSelected: onSelected,
            itemBuilder: (context) =>
                menuItems ??
                items
                    .map(
                      (item) => PopupMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayValue,
                  style: AppTextStyle.interRegular12.copyWith(
                    color: AppColorsFromTheme.grayForText(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
