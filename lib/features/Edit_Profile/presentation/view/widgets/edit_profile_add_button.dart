import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EditProfileAddButton extends StatelessWidget {
  const EditProfileAddButton({
    super.key,
     this.showInput,
    required this.onPressed,
    required this.title,
  });

  final bool? showInput;
  final VoidCallback onPressed;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColorsFromTheme.borderColor(context)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.5, horizontal: 24),
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.assetsIconsAdd,
                width: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              SizedBox(width: 16),
              Text(
                showInput != null
                    ? showInput!
                          ? 'Cancel'
                          : title
                    : title,
                style: AppTextStyle.interSemiBold12.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
