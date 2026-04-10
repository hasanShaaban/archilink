import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class EditProfileTextField extends StatefulWidget {
  const EditProfileTextField({
    super.key,
    required this.title,
    required this.initialValue,
    required this.controller,
    this.onChanged,
    required this.hintText,
  });
  final String title, initialValue, hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  State<EditProfileTextField> createState() => _EditProfileTextFieldState();
}

class _EditProfileTextFieldState extends State<EditProfileTextField> {
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    focusNode.addListener(() => setState(() {}));
    widget.controller.text = widget.initialValue;
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: AppTextStyle.interMedium12.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Expanded(
            child: TextField(
              focusNode: focusNode,
              onTapOutside: (event) {
                focusNode.unfocus();
              },
              style: AppTextStyle.interRegular12.copyWith(
                color: focusNode.hasFocus
                    ? Theme.of(context).colorScheme.onSurface
                    : AppColorsFromTheme.grayForText(context),
              ),
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.end,
              controller: widget.controller,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTextStyle.interMedium12.copyWith(
                  color: AppColorsFromTheme.grayForText(context),
                ),
                border: InputBorder.none,
                isCollapsed: true,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
