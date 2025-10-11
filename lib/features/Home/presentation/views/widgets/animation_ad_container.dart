import 'package:flutter/material.dart';

class AnimatedAdContainer extends StatelessWidget {
  const AnimatedAdContainer({
    super.key,
    required int currentIndex,
    required List<Color> colors,
    required this.height,
  }) : _currentIndex = currentIndex, _colors = colors;

  final int _currentIndex;
  final List<Color> _colors;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Container(
          key: ValueKey<int>(_currentIndex),
          color: _colors[_currentIndex],
          height: height,
          width: double.infinity,
        ),
      ),
    );
  }
}