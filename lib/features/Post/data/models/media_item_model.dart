import 'package:archilink/features/Post/data/models/media_urls_model.dart';
import 'package:archilink/features/Post/domain/entity/media_item_entity.dart';

class MediaItemModel {
  final int id;
  final String type;
  final int index;
  final MediaUrlsModel urls;
  final double aspectRatio;
  final int? durationSeconds;

  const MediaItemModel({
    required this.id,
    required this.type,
    required this.index,
    required this.urls,
    required this.aspectRatio,
    this.durationSeconds,
  });

  factory MediaItemModel.fromJson(Map<String, dynamic> json) {
    return MediaItemModel(
      id: json['id'],
      type: json['type'],
      index: json['index'],
      urls: MediaUrlsModel.fromJson(json['urls']),
      aspectRatio: (json['aspect_ratio'] as num).toDouble(),
      durationSeconds: json['duration_seconds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'index': index,
      'urls': urls.toJson(),
      'aspect_ratio': aspectRatio,
      'duration_seconds': durationSeconds,
    };
  }

  MediaItemEntity toEntity() {
    return MediaItemEntity(
      id: id,
      type: type,
      index: index,
      urls: urls.toEntity(),
      aspectRatio: aspectRatio,
      durationSeconds: durationSeconds,
    );
  }
}
