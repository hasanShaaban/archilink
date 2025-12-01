import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  static const String name = '/onboarding';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: OnBoardingViewBody()
      ),
    );
  }
}

class OnBoardingViewBody extends StatelessWidget {
  const OnBoardingViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        
      ],
    );
  }
}