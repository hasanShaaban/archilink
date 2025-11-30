import 'package:archilink/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CommentLikeButton extends StatefulWidget {
  const CommentLikeButton({super.key});

  @override
  State<CommentLikeButton> createState() => _CommentLikeButtonState();
}

class _CommentLikeButtonState extends State<CommentLikeButton> {
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          liked = !liked;
        });
      },
      child: SvgPicture.asset(
        liked? Assets.assetsIconsFilldLike:
        Assets.assetsIconsLike,
        color:liked? null :
         Theme.of(context).colorScheme.onSurface,
        width: 16,
      ),
    );
  }
}
