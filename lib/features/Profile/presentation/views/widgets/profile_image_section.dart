import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileImageSection extends StatelessWidget {
  const ProfileImageSection({
    super.key,
    required this.width, this.image,
  });

  final double width;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: width * 35 / 402,
      backgroundColor: AppColorsFromTheme.grayForTheme(context),
      child:image == null? SvgPicture.asset(
        Assets.assetsIconsUser,
        width: 35,
        color: AppColorsFromTheme.reverseGrayForTheme(context),
      ) : CachedNetworkImage(imageUrl: image!),
    );
  }
}