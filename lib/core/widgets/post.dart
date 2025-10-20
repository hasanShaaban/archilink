import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/widgets/expandable_text.dart';
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
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostUserImage(width: width),
          SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top:width * 34 / 402 / 8 ),
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
                  PostBody(width: width, height: height,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PostBody extends StatelessWidget {
  const PostBody({
    super.key,
    required this.width, required this.height,
  });

  final double width, height;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: width * 305 / 402,
          child: ExpandableText(
            'Sometimes being an INFP feels like your heart is a sponge, soaking up everyone else’s emotions while you’re still figuring out how to handle your own. Sometimes being an INFP feels like your heart is a sponge, soaking up everyone else’s emotions while you’re still figuring out how to handle your own.',
          ),
        ),
        SizedBox(
          height: height * 158 / 847,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.all(4),
            width: width * 150/402,
            height: width * 150/402,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(16)
            ),
          ), itemCount: 5))
      ],
    );
  }
}

class PostUserNameAndDate extends StatelessWidget {
  const PostUserNameAndDate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Hasan Shaaban',
        style: AppTextStyle.interMedium14,
        children: [
          TextSpan(
            text: '  3 Oct',
            style: AppTextStyle.interMedium14.copyWith(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class PostUserImage extends StatelessWidget {
  const PostUserImage({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: width * 34 / 402 / 2,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: ClipOval(
        child: SvgPicture.asset(
          Assets.assetsIconsUser,
          color: Theme.of(context).colorScheme.onSurface,
          width: 24,
        ),
      ),
    );
  }
}
