import 'package:archilink/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.height,
    required this.content,
    this.secondary = false, required this.onPressed,
  });
  final Widget content;
  final double height;
  final bool secondary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height * 45 / 896,
      child: TextButton(
        
        style: TextButton.styleFrom(
          overlayColor: AppColorsFromTheme.grayForTheme(context),
          backgroundColor:!secondary? Theme.of(context).colorScheme.primary : AppColorsFromTheme.secondaryColor(context).withOpacity(0.8),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: secondary
                ? BorderSide(color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),width: 1)
                : BorderSide.none,
          ),
        ),
        onPressed: onPressed,
        child: content,
      ),
    );
  }
}
