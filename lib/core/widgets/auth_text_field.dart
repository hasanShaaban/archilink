import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthTextFiled extends StatefulWidget {
  const AuthTextFiled({
    super.key,
    required this.height,
    required this.label,
    required this.hint,
    this.isPassword = false,
    required this.controller,
    this.validator,
    this.keyboardType,
  });

  final double height;
  final String label, hint;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  State<AuthTextFiled> createState() => _AuthTextFiledState();
}

class _AuthTextFiledState extends State<AuthTextFiled> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyle.mallannaSemiBold14),
        SizedBox(
          width: double.infinity,
          height: widget.height * 41 / 896,
          child: TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? obscureText : false,
            decoration: InputDecoration(
              suffixIcon: widget.isPassword
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      icon: SvgPicture.asset(Assets.assetsIconsEyeFill),
                    )
                  : null,
              hint: Text(
                widget.hint,
                style: AppTextStyle.mallannaSemiBold14.copyWith(
                  color: AppColors.lightGrayDarkMode,
                ),
              ),
              contentPadding: const EdgeInsets.only(left: 12, right: 12),
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

OutlineInputBorder buildBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color, width: 1.5),
  );
}
