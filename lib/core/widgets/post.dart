
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/widgets/post_actions.dart';
import 'package:archilink/core/widgets/post_body.dart';
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
            // User image section
            PostUserImage(width: width),
            SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: width * 34 / 402 / 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User name and date section
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
                    // Post body section
                    PostBody(width: width, height: height),
                    // Post actions section
                    PostActions(width: width),
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

