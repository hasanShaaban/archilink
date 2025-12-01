import 'dart:ui';

import 'package:archilink/core/utils/assets.dart';
import 'package:flutter/material.dart';

class AuthBackGround extends StatelessWidget {
  const AuthBackGround({
    super.key,

  });


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
                Theme.of(context).brightness == Brightness.dark ? Assets.assetsImagesBackgroundDark :
                Assets.assetsImagesBackgroundLight,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Expanded(child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
              Colors.black.withOpacity(0.6),
              Colors.black.withOpacity(0.4)
            ])
          ),
        )),
      ],
    );
  }
}