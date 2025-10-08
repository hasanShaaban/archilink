import 'package:archilink/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBarActionButton extends StatelessWidget {
  const AppBarActionButton({super.key, required this.icon, this.onPress});
  final String icon;
  final VoidCallback? onPress;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 20,
      splashColor: AppColorsFromTheme.lightGray(context),
      onPressed: onPress,
      icon: SvgPicture.asset(
        icon,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
