
import 'package:flutter/material.dart';

abstract class AppColors {
  static const white = Color(0xFFF5F4F5);
  static const whiteForElements = Color(0xFFF2F2F2);
  static const tael = Color(0xFF008080);
  static const lightTeal = Color(0xFF00ACAC);
  static const richBlack = Color(0xFF020202);
  static const lightGreyLightMode = Color(0xFFD9D9D9);
  static const lightGrayDarkMode = Color(0xFF989898);
  static const gray = Color(0xFF636363);
  static const darkGray = Color(0xFF242527);
}

abstract class AppColorsFromTheme {
  static lightGray(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? AppColors.lightGreyLightMode
      : AppColors.lightGrayDarkMode;
  static primaryColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? AppColors.tael
      : AppColors.lightTeal;
  static textColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
      ? AppColors.richBlack
      : AppColors.whiteForElements;
  
}
