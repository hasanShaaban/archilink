
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';

class PhoneNumberTextField extends StatelessWidget {
  const PhoneNumberTextField({super.key, required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Phone Number',
            style: AppTextStyle.mallannaSemiBold14.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            children: [
              TextSpan(
                text: ' (Optional)',
                style: AppTextStyle.mallannaSemiBold14.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: height * 41 / 896,
          child: TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 6),
                    child: Text(
                      '+963',
                      style: AppTextStyle.mallannaSemiBold14.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  VerticalDivider(
                    endIndent: 6,
                    indent: 6,
                    color: AppColors.lightGrayDarkMode,
                    thickness: 1,
                  ),
                ],
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
              hint: Text(
                'xxx xxx xxx',
                style: AppTextStyle.mallannaSemiBold14.copyWith(
                  color: AppColors.lightGrayDarkMode,
                ),
              ),
              border: buildBorder(Theme.of(context).colorScheme.primary),
              enabledBorder: buildBorder(
                AppColorsFromTheme.secondaryColor(context).withOpacity(0.5),
              ),
              fillColor: AppColorsFromTheme.secondaryColor(
                context,
              ).withOpacity(0.5),
              filled: true,
            ),
          ),
        ),
      ],
    );
  }
}
