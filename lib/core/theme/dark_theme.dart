import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: false,
  scaffoldBackgroundColor: AppColors.richBlack,
  colorScheme: ColorScheme.dark(
    primary: AppColors.lightTeal,
    onPrimary: AppColors.whiteForElements,
    surface: AppColors.richBlack,
    onSurface: AppColors.whiteForElements,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.richBlack,
    foregroundColor: AppColors.whiteForElements,
    elevation: 0,
    centerTitle: false,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColors.lightTeal,
      foregroundColor: AppColors.whiteForElements,
      textStyle: AppTextStyle.interMedium16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
);
