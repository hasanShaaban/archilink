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
    return CircleAvatar(
      radius: width * 34 / 402 / 2,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: ClipOval(
        child: imageURL == null
            ? SvgPicture.asset(
                //change it to Cached Network Image
                Assets.assetsIconsUser, //---------------image
                color: Theme.of(context).colorScheme.onSurface,
                width: 24,
              )
            : CachedNetworkImage(
                imageUrl: imageURL!,
                progressIndicatorBuilder: (context, url, progress) =>
                    Skeletonizer(child: Container()),
              ),
      ),
    );
  }
}
