import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class SaveTagsButton extends StatelessWidget {
  const SaveTagsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {},

        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8.5),
        ),
        child: Text(
          'Save',
          style: AppTextStyle.interMedium16.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
