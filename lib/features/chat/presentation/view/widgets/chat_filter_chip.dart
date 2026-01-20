import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

class ChatFilterChip extends StatelessWidget {
  const ChatFilterChip({
    super.key,
    required this.chatListController,
    required this.onSelected,
    required this.label,
    required this.selected,
  });

  final ChatListController chatListController;
  final Function(bool) onSelected;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return FilterChip.elevated(
      backgroundColor: selected
          ? AppColorsFromTheme.grayForTheme(context)
          : Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColorsFromTheme.grayForTheme(context)),
      ),
      label: Text(
        label,
        style: AppTextStyle.interRegular12.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      onSelected: (value) => onSelected(value)
      ,
    );
  }
}