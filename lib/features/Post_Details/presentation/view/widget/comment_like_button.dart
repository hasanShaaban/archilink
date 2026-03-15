import 'dart:developer';

import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Post_Details/presentation/manager/bloc/post_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CommentLikeButton extends StatelessWidget {
  const CommentLikeButton({
    super.key,
    required this.isLiked,
    required this.likeCount,
    required this.commentId,
  });
  final bool isLiked;
  final int likeCount;
  final int commentId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${likeCount.toString()} ',
          style: AppTextStyle.interMedium12.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        GestureDetector(
          onTap: () {
            log('tapped');
            context.read<PostDetailsBloc>().add(ToggleCommentLike(commentId));
          },
          child: SvgPicture.asset(
            isLiked ? Assets.assetsIconsFilldLike : Assets.assetsIconsLike,
            color: isLiked ? null : Theme.of(context).colorScheme.onSurface,
            width: 16,
          ),
        ),
      ],
    );
  }
}
