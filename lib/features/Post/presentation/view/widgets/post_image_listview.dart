import 'package:archilink/features/Post/domain/entity/media_item_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PostImagesListView extends StatelessWidget {
  const PostImagesListView({
    super.key,
    required this.width,
    required this.mediaItems,
  });

  final double width;
  final List<MediaItemEntity> mediaItems;

  @override
  Widget build(BuildContext context) {
    final itemSize = width * 150 / 402;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: mediaItems.length,
      itemBuilder: (context, index) {
        final media = mediaItems[index];

        return Padding(
          padding: const EdgeInsets.all(4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: itemSize,
              height: itemSize,
              child: CachedNetworkImage(
                imageUrl: media.urls.feed, // not original
                fit: BoxFit.cover,

                placeholder: (context, url) => _ImageSkeleton(itemSize: itemSize,),

                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).colorScheme.secondary,
                  child: const Icon(Icons.image_not_supported),
                ),

                memCacheWidth: 300,
                memCacheHeight: 300,
                fadeInDuration: const Duration(milliseconds: 200),
              ),
            ),
          ),
        );
      },
    );
  }
}


class _ImageSkeleton extends StatelessWidget {
  final double itemSize;

  const _ImageSkeleton({required this.itemSize});
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.secondary,
        ),
        width: itemSize,
        height: itemSize,
        
      ),
    );
  }
}