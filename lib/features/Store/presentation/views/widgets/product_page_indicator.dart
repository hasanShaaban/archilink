import 'package:flutter/material.dart';

class ProductPageIndicator extends StatelessWidget {
  const ProductPageIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.dotSize = 6.5,
    this.spacing = 3.0,
  });

  final int itemCount;
  final int currentIndex;
  final double dotSize;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (itemCount <= 1) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(itemCount, (index) {
          final isActive = index == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: dotSize,
            height: dotSize,
            margin: EdgeInsets.symmetric(horizontal: spacing),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? theme.colorScheme.onSurface
                  : (isDark
                        ? const Color(0xFF6B6D72)
                        : const Color(0xFFB5B6B8)),
            ),
          );
        }),
      ),
    );
  }
}
