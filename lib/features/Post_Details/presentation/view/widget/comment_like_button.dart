import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CommentLikeButton extends StatefulWidget {
  const CommentLikeButton({
    super.key,
    required this.isLiked,
    required this.likeCount,
  });
  final bool isLiked;
  final int likeCount;

  @override
  State<CommentLikeButton> createState() => _CommentLikeButtonState();
}

class _CommentLikeButtonState extends State<CommentLikeButton> {
  @override
  Widget build(BuildContext context) {
    bool liked = widget.isLiked;
    return Row(
      children: [
        Text(
          '${widget.likeCount.toString()} ',
          style: AppTextStyle.interMedium12.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              liked = !liked;
            });
          },
          child: SvgPicture.asset(
            liked ? Assets.assetsIconsFilldLike : Assets.assetsIconsLike,
            color: liked ? null : Theme.of(context).colorScheme.onSurface,
            width: 16,
          ),
        ),
      ],
    );
  }
}
