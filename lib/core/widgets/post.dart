import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/widgets/post_body.dart';
import 'package:archilink/core/widgets/post_like_button.dart';
import 'package:archilink/core/widgets/post_user_image.dart';
import 'package:archilink/core/widgets/post_username_and_date.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Post extends StatelessWidget {
  const Post({
    super.key,
    required this.lang,
    required this.width,
    required this.height,
  });
  final S lang;
  final double width, height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostUserImage(width: width),
            SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: width * 34 / 402 / 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PostUserNameAndDate(),
                        InkWell(
                          onTap: () {},
                          child: SvgPicture.asset(
                            Assets.assetsIconsMoreVertical,
                            color: Theme.of(context).colorScheme.onSurface,
                            width: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    PostBody(width: width, height: height),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              LikeButton(),
                              SizedBox(width: width * 25 / 402),
                              CommentButton(),
                            ],
                          ),
                          PostActionButton(icon: Assets.assetsIconsShare),
                          PostActionButton(icon: Assets.assetsIconsSave),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentButton extends StatelessWidget {
  const CommentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          Assets.assetsIconsComment,
          color: Theme.of(context).colorScheme.onSurface,
          width: 24,
        ),
        SizedBox(width: 4),
        Text('500', style: AppTextStyle.interBold12),
      ],
    );
  }
}

class PostActionButton extends StatelessWidget {
  const PostActionButton({super.key, required this.icon});

  final String icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SvgPicture.asset(
        icon,
        color: Theme.of(context).colorScheme.onSurface,
        width: 24,
      ),
    );
  }
}
