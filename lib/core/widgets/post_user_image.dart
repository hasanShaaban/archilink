import 'package:archilink/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostUserImage extends StatelessWidget {
  const PostUserImage({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: width * 34 / 402 / 2,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: ClipOval(
        child: SvgPicture.asset(
          //change it to Cached Network Image
          Assets.assetsIconsUser, //---------------image
          color: Theme.of(context).colorScheme.onSurface,
          width: 24,
        ),
      ),
    );
  }
}
