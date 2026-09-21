import 'package:archilink/features/Post/domain/entity/media_item_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ExistingImagesListView extends StatelessWidget {
  const ExistingImagesListView({
    super.key,
    required this.height,
    required this.images,
    required this.width,
  });

  final List<MediaItemEntity> images;
  final double height, width;

  @override
  Widget build(BuildContext context) {
    final itemSize = width * 150 / 402;
    return SizedBox(
      height: height * 166 / 874,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 4),
        itemBuilder: (context, index) {
          final media = images[index];
          final imageUrl = media.urls.feed.isNotEmpty
              ? media.urls.feed
              : media.urls.original;

          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: itemSize,
              height: itemSize,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
