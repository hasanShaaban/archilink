import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class EditProfileAccountTypeButton extends StatefulWidget {
  const EditProfileAccountTypeButton({
    super.key,
  });

  @override
  State<EditProfileAccountTypeButton> createState() =>
      _EditProfileAccountTypeButtonState();
}

class _EditProfileAccountTypeButtonState
    extends State<EditProfileAccountTypeButton> {
  static const String _student = 'Student';
  static const String _mentor = 'Mentor';
  String _selected = _student;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Account Type',
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
            onSelected: (value) {
              setState(() {
                _selected = value;
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _student,
                child: Text(_student),
              ),
              PopupMenuItem(
                value: _mentor,
                child: Text(_mentor),
              ),
            ],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selected,
                  style: AppTextStyle.interRegular12.copyWith(
                    color: AppColorsFromTheme.grayForText(
                      context,
                    ),
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