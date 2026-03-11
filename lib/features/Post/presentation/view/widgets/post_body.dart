import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/widgets/expandable_text.dart';
import 'package:archilink/features/Home/domain/entity/media_item_entity.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_image_listview.dart';
import 'package:flutter/material.dart';

class PostBody extends StatelessWidget {
  const PostBody({
    super.key,
    required this.width,
    required this.height,
    required this.withDetails,
    required this.body,
    required this.mediaItems,
  });

  final double width, height;
  final bool withDetails;
  final String body;
  final List<MediaItemEntity> mediaItems;

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
        if (mediaItems.isNotEmpty)
          SizedBox(
            height: height * 158 / 847,
            child: PostImagesListView(width: width, mediaItems: mediaItems),
          ),
      ],
    );
  }
}
