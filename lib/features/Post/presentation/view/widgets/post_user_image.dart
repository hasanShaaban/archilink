import 'package:archilink/core/utils/assets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PostUserImage extends StatelessWidget {
  const PostUserImage({super.key, required this.width, this.imageURL});

  final double width;
  final String? imageURL;

  @override
  Widget build(BuildContext context) {
    final imageRadius = width * 34 / 402;
    return CircleAvatar(
      radius: imageRadius / 2,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: ClipOval(
        child: imageURL == null
            ? SvgPicture.asset(
                Assets.assetsIconsUser, //---------------image
                color: Theme.of(context).colorScheme.onSurface,
                width: 24,
              )
            : CachedNetworkImage(
                imageUrl: imageURL!,
                fit: BoxFit.cover,
                width: imageRadius,
                height: imageRadius,
                errorWidget: (context, url, error) => SvgPicture.asset(
                  Assets.assetsIconsUser,
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 24,
                ),
                placeholder: (context, url) => Skeletonizer(
                  child: Container(width: imageRadius, height: imageRadius),
                ),
              ),
      ),
    );
  }
}
