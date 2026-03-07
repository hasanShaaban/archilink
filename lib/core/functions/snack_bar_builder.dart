import 'dart:ui';

import 'package:archilink/core/error/failure.dart';
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

Color getSnackBarColor(BuildContext context, Failure failure) {
  return AppColorsFromTheme.grayForTheme(context);
}

IconData getSnackBarIcon(Failure failure) {
  if (failure is NetworkFailure || failure is ServerFailure) {
    return Icons.signal_wifi_connected_no_internet_4_rounded;
  } else if (failure is UnknownFailure || failure is NotFoundFailure) {
    return Icons.gpp_bad_outlined;
  } else {
    return Icons.error_outline_rounded;
  }
}

SnackBar appSnackBar(BuildContext context, Failure failure, String message) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(13),
      side: BorderSide(
        color: Theme.of(context).colorScheme.error.withAlpha(200),
      ),
    ),
    duration: Duration(seconds: 5),
    backgroundColor: getSnackBarColor(context, failure),
    content: Row(
      children: [
        Icon(
          getSnackBarIcon(failure),
          color: Theme.of(context).colorScheme.onSurface,
        ),
        SizedBox(width: 5),
        Text(
          message,
          style: AppTextStyle.mallannaSemiBold14.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    ),
  );
}
