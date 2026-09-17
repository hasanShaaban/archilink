import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class ProductFormField extends StatelessWidget {
  const ProductFormField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.customChild,
  });

  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? minLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final Widget? customChild;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.interSemiBold14.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        customChild ??
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
              child: TextFormField(
                controller: controller,
                initialValue: controller == null ? initialValue : null,
                onChanged: onChanged,
                readOnly: readOnly,
                onTap: onTap,
                keyboardType: keyboardType,
                maxLines: maxLines,
                minLines: minLines,
                style: AppTextStyle.interRegular14.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: AppTextStyle.interRegular14.copyWith(
                    color: isDark
                        ? const Color(0xFF8E8E93)
                        : const Color(0xFFA0A0A0),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: maxLines > 1 ? 12 : 14,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF242527)
                      : const Color(0xFFF2F2F2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColorsFromTheme.borderColor(context).withValues(alpha: 0.5),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColorsFromTheme.borderColor(context).withValues(alpha: 0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF6BBBAE),
                      width: 1.5,
                    ),
                  ),
                  suffixIcon: suffixIcon,
                ),
              ),
            ),
      ],
    );
  }
}
