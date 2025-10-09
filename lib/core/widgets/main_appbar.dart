import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/widgets/app_bar_action_button.dart';
import 'package:flutter/material.dart';

AppBar mainAppBar() {
    return AppBar(
      actionsPadding: EdgeInsets.only(right: 27),
      titleSpacing: 27,
    title: Text(
      'Acrhi Link',
      style: AppTextStyle.appTilte.copyWith(height: 1),
      textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
    ),
      actions: [
        AppBarActionButton(icon: Assets.assetsIconsMail, onPress: () {}),
        AppBarActionButton(icon: Assets.assetsIconsSearch, onPress: () {}),
      ],
    );
  }