import 'package:archilink/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CollectionPageIndicator extends StatelessWidget {
  const CollectionPageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });

  final int currentPage;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final double dotSize = size.height * 0.01;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(pageCount, (index) {
          final isActive = index == currentPage;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
            height: dotSize,
            width: dotSize,
            decoration: BoxDecoration(
              color: isActive
                  ? Theme.of(context).colorScheme.onSurface
                  : AppColorsFromTheme.grayForTheme(context),
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}
