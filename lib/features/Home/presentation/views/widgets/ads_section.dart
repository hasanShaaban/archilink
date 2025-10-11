import 'dart:async';

import 'package:archilink/features/Home/presentation/views/widgets/ads_dots_indecator.dart';
import 'package:archilink/features/Home/presentation/views/widgets/animation_ad_container.dart';
import 'package:flutter/material.dart';

class AdsSection extends StatefulWidget {
  const AdsSection({super.key});

  @override
  State<AdsSection> createState() => _AdsSectionState();
}

class _AdsSectionState extends State<AdsSection> {
  final List<Color> _colors = [
    Colors.amberAccent,
    Colors.tealAccent,
    Colors.pinkAccent,
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Change color every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _colors.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 91 / 847;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          AnimatedAdContainer(currentIndex: _currentIndex, colors: _colors, height: height),
          SizedBox(height: 10),
          AdsDotsIndecator(colors: _colors, currentIndex: _currentIndex)
        ],
      ),
    );
  }
}



