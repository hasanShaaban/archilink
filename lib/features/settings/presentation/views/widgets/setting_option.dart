

import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingOption extends StatelessWidget {
  const SettingOption({
    super.key,
    required this.colorScheme,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final String icon;
  final String title;

  final ColorScheme colorScheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 30, vertical: 12.5),
          child: Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 24,
                height: 24,
                color: colorScheme.onSurface,
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyle.interMedium12.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}