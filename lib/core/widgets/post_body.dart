import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/widgets/expandable_text.dart';
import 'package:archilink/core/widgets/post_image_listview.dart';
import 'package:flutter/material.dart';

class PostBody extends StatelessWidget {
  const PostBody({
    super.key,
    required this.width,
    required this.height,
    required this.withDetails,
    required this.body,
  });

  final double width, height;
  final bool withDetails;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: width * 305 / 402,
          child: withDetails
              ? Text(
                  body,
                  style: AppTextStyle.mallannaRegular14.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.2,
                  ),
                )
              : ExpandableText(
                  //-----------------body
                  body,
                ),
        ),
        SizedBox(height: 9),
        SizedBox(
          height: height * 158 / 847,
          child: PostImagesListView(width: width),
        ),
      ],
    );
  }
}
