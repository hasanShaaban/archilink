import 'package:flutter/material.dart';

class AdsDotsIndecator extends StatelessWidget {
  const AdsDotsIndecator({
    super.key,
    required List<Color> colors,
    required int currentIndex,
  }) : _colors = colors, _currentIndex = currentIndex;

  final List<Color> _colors;
  final int _currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _colors.length,
        (index) => AnimatedContainer(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: index == _currentIndex
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.secondary
          ),
        ),
      ),
    );
  }
}