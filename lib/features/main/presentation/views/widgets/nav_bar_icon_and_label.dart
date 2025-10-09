import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NavBarIconAndLabel extends StatelessWidget {
  const NavBarIconAndLabel({
    super.key, required this.color, required this.title, required this.image, required this.alignment,
  });
  final Color color;
  final String title, image;
  final MainAxisAlignment alignment;


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: alignment,
      children: [
        SvgPicture.asset(image, width: 24,color: color),
        const SizedBox(height: 6),
        Text(
          title,
          style: AppTextStyle.interRegular10.copyWith(
            decoration: TextDecoration.none,
            height: 1,
            color: color,
          ),
        )
      ],
    );
  }
}
