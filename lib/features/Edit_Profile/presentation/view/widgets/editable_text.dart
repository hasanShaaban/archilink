import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class EditProfileTextField extends StatefulWidget {
  const EditProfileTextField({
    super.key,
    required this.title,
    required this.initialValue,
    required this.controller,
  });
  final String title, initialValue;
  final TextEditingController controller;

  @override
  State<EditProfileTextField> createState() => _EditProfileTextFieldState();
}

class _EditProfileTextFieldState extends State<EditProfileTextField> {
  bool focused = false;
  @override
  void initState() {
    widget.controller.text = widget.initialValue;
    super.initState();
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
              onTapOutside: (event) {
                focused = false;
                setState(() {});
              },
              onTap: () {

                focused = true;
                setState(() {});
              },
              style: AppTextStyle.interRegular12.copyWith(
                color: focused ? Theme.of(context).colorScheme.onSurface :
                AppColorsFromTheme.grayForText(context)
              ),
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.end,
              controller: widget.controller,
              decoration: InputDecoration(
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