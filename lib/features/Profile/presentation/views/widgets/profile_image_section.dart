import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileImageSection extends StatelessWidget {
  const ProfileImageSection({super.key, required this.width, this.image});

  final double width;
  final String? image;

  @override
  Widget build(BuildContext context) {
    final imageRadius = width * 35 / 402;
    return Skeleton.unite(
      child: CircleAvatar(
        radius: imageRadius,
        backgroundColor: AppColorsFromTheme.grayForTheme(context),
        child: ClipOval(
          child: image == null
              ? SvgPicture.asset(
                  Assets.assetsIconsUser,
                  width: 35,
                  color: AppColorsFromTheme.reverseGrayForTheme(context),
                )
              : CachedNetworkImage(
                  imageUrl: image!,
                  fit: BoxFit.cover,
                  width: imageRadius * 2,
                  height: imageRadius * 2,
                  errorWidget: (context, url, error) => SvgPicture.asset(
                    Assets.assetsIconsUser,
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 24,
                  ),
                  placeholder: (context, url) => Skeletonizer(
                    enabled: true,
                    child: Container(width: imageRadius, height: imageRadius),
                  ),
                ),
        ),
      ),
    );
  }
}
