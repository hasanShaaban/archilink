import 'dart:ui';

import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Auth/presentation/views/auth_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  static const String name = 'SplashView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: SplashViewBody()),
    );
  }
}

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({
    super.key,
  });

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {

  double opacity = 0;

  @override
  void initState() {

    Future.delayed(const Duration(microseconds: 300), () {
      setState(() {
        opacity = 1;
      });
    });

    Future.delayed(const Duration(milliseconds: 2300), () {
      _navigation();
    });

    
    super.initState();
  }

  void _navigation() {
    Navigator.pushReplacementNamed(context, AuthView.name);
  }

  @override
  Widget build(BuildContext context) {
    final double viewportWidth = MediaQuery.of(context).size.width;
    final double viewportHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Positioned(
          top: -30,
          child: SizedBox(
            width: viewportWidth,
            height: viewportHeight,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Image.asset(
                Assets.assetsImagesBackgroundLight,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(seconds: 1),
          curve: Curves.easeInCubic,
          opacity: opacity,
          child: Center(child: SvgPicture.asset(Assets.assetsIconsAppLogo)),
        ),
      ],
    );
  }
}
