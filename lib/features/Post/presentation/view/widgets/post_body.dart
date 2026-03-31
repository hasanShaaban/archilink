import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/widgets/expandable_text.dart';
import 'package:archilink/features/Post/domain/entity/media_item_entity.dart';
import 'package:archilink/features/Post/presentation/view/widgets/post_image_listview.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostBody extends StatelessWidget {
  const PostBody({
    super.key,
    required this.width,
    required this.height,
    required this.withDetails,
    required this.body,
    required this.mediaItems,
    this.localAssets = const [],
  });

  final double width, height;
  final bool withDetails;
  final String body;
  final List<MediaItemEntity> mediaItems;
  final List<AssetEntity> localAssets;

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
        if (localAssets.isNotEmpty)
          SizedBox(
            height: height * 158 / 847,
            child: _LocalImagesListView(width: width, assets: localAssets),
          )
        else if (mediaItems.isNotEmpty)
          SizedBox(
            height: height * 158 / 847,
            child: PostImagesListView(width: width, mediaItems: mediaItems),
          ),
      ],
    );
  }
}

class _LocalImagesListView extends StatelessWidget {
  const _LocalImagesListView({
    required this.width,
    required this.assets,
  });

  final double width;
  final List<AssetEntity> assets;

  @override
  Widget build(BuildContext context) {
    final itemSize = width * 150 / 402;
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: assets.length,
      separatorBuilder: (_, __) => const SizedBox(width: 4),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AssetEntityImage(
            assets[index],
            isOriginal: false,
            fit: BoxFit.cover,
            width: itemSize,
            height: itemSize,
          ),
        );
      },
    );
  }
}
