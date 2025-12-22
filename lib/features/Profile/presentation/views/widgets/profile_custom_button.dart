
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileCustomButton extends StatelessWidget {
  const ProfileCustomButton({
    super.key, required this.onPress, required this.icon, required this.title, required this.backgroundColor, required this.textStyle, required this.iconSize,
  });

  final VoidCallback onPress;
  final String icon, title;
  final Color backgroundColor;
  final TextStyle textStyle;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
         shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10))
      ),
      onPressed: onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(icon, width: iconSize,color: Theme.of(context).colorScheme.onSurface,),
          SizedBox(width: 4),
          Text(title, style: textStyle,),
        ],
      ),
    );
  }
}
