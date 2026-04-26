import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class SingleActionButton extends StatelessWidget {
  const SingleActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.color,
  });

  final String label;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyle.interMedium12.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
