import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: false,

  scaffoldBackgroundColor:  AppColors.white,
  colorScheme: ColorScheme.light(
    primary: AppColors.tael,
    secondary: AppColors.darkGray,
    tertiary: AppColors.lightGreyLightMode,
    onPrimary: AppColors.richBlack,
    surface: AppColors.lightGreyLightMode,
    onSurface: AppColors.richBlack
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.white,
    foregroundColor: AppColors.richBlack,
    elevation: 0,
    centerTitle: false,
    
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColors.tael,
      foregroundColor: AppColors.richBlack,
      textStyle: AppTextStyle.interMedium16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      )

    )
  )
);