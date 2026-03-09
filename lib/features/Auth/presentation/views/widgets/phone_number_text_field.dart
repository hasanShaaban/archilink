
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNumberTextField extends StatefulWidget {
  const PhoneNumberTextField({
    super.key,
    required this.height,
    required this.controler, this.errorText, this.onChanged, this.onSaved,
  });
  final double height;
  final TextEditingController controler;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;

  @override
  State<PhoneNumberTextField> createState() => _PhoneNumberTextFieldState();
}

class _PhoneNumberTextFieldState extends State<PhoneNumberTextField> {
  bool _hasFocus = false;
  Color _borderColor(BuildContext context) {
    if (!_hasFocus) {
      return AppColorsFromTheme.secondaryColor(context).withOpacity(0.5);
    }

    if (widget.errorText != null) {
      return AppColors.red;
    }

    return Theme.of(context).colorScheme.primary;
  }

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
        Focus(
          onFocusChange: (focus) {
            setState(() {
              _hasFocus = focus;
            });
          },
          child: SizedBox(
            width: double.infinity,
            height: widget.height * 41 / 896,
            child: TextFormField(
              onChanged: (value){
                widget.onChanged?.call(value);
              },
              onSaved: widget.onSaved,
              controller: widget.controler,
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
                border: buildBorder(_borderColor(context)),
                enabledBorder: buildBorder(_borderColor(context),
                ),
                focusedBorder: buildBorder(_borderColor(context)),
                fillColor: AppColorsFromTheme.secondaryColor(
                  context,
                ).withOpacity(0.5),
                filled: true,
              ),
            ),
          ),
        ),
        /// Error container (does NOT affect text field height)
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topLeft,
          child: widget.errorText != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.errorText!,
                      style: AppTextStyle.interRegular10.copyWith(
                        color: AppColors.red,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
