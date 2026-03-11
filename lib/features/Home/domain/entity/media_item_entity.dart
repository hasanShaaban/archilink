import 'package:archilink/features/Home/domain/entity/media_urls_entity.dart';

class MediaItemEntity {
  final int id;
  final String type;
  final int index;
  final MediaUrlsEntity urls;
  final double aspectRatio;
  final int? durationSeconds;

  const MediaItemEntity({
    required this.id,
    required this.type,
    required this.index,
    required this.urls,
    required this.aspectRatio,
    this.durationSeconds,
  });
}
