// ignore_for_file: deprecated_member_use

import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostActions extends StatelessWidget {
  const PostActions({
    super.key,
    required this.width,
    required this.likesCount,
    required this.commentsCount,
    required this.likedByMe,
  });

  final double width;
  final int likesCount, commentsCount;
  final bool likedByMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              PostLikeButton(likedByMe: likedByMe, likesCount: likesCount),
              SizedBox(width: width * 25 / 402),
              PostCommentButton(commentsCount: commentsCount,),
            ],
          ),
          PostShareButton(),
          PostSaveButton(),
        ],
      ),
    );
  }
}

class PostLikeButton extends StatefulWidget {
  const PostLikeButton({
    super.key,
    required this.likesCount,
    required this.likedByMe,
  });
  final int likesCount;
  final bool likedByMe;

  @override
  State<PostLikeButton> createState() => _PostLikeButtonState();
}

class _PostLikeButtonState extends State<PostLikeButton> {
  late bool liked;
  late int likeCount;
  @override
  void initState() {
    liked = widget.likedByMe;
    likeCount = widget.likesCount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PostActionButton(
      count: likeCount,
      withCount: true,
      onTap: () {
        setState(() {
          liked = !liked;
          if (liked) {
            likeCount += 1;
          } else {
            likeCount -= 1;
          }
        });
      },
      icon: SvgPicture.asset(
        liked ? Assets.assetsIconsFilldLike : Assets.assetsIconsLike,
        color: liked ? null : Theme.of(context).colorScheme.onSurface,
        width: 24,
      ),
    );
  }
}

class PostCommentButton extends StatelessWidget {
  const PostCommentButton({super.key, required this.commentsCount});

  final int commentsCount;

  @override
  Widget build(BuildContext context) {
    return PostActionButton(
      onTap: () {},
      withCount: true,
      count: commentsCount,
      icon: SvgPicture.asset(
        Assets.assetsIconsComment,
        color: Theme.of(context).colorScheme.onSurface,
        width: 24,
      ),
    );
  }
}

class PostShareButton extends StatelessWidget {
  const PostShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PostActionButton(
      onTap: () {},
      icon: SvgPicture.asset(
        Assets.assetsIconsSharePost,
        width: 24,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      withCount: false,
    );
  }
}

class PostSaveButton extends StatefulWidget {
  const PostSaveButton({super.key});

  @override
  State<PostSaveButton> createState() => _PostSaveButtonState();
}

class _PostSaveButtonState extends State<PostSaveButton> {
  bool saved = false;
  @override
  Widget build(BuildContext context) {
    return PostActionButton(
      onTap: () {
        setState(() {
          saved = !saved;
        });
      },
      icon: SvgPicture.asset(
        saved ? Assets.assetsIconsSaveFilled : Assets.assetsIconsSave,
        width: 24,
        color: saved ? null : Theme.of(context).colorScheme.onSurface,
      ),
      withCount: false,
    );
  }
}
