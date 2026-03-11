import 'package:archilink/features/Post/domain/entity/media_urls_entity.dart';

class MediaUrlsModel {
  final String thumbnail;
  final String feed;
  final String original;

  const MediaUrlsModel({
    required this.thumbnail,
    required this.feed,
    required this.original,
  });

  factory MediaUrlsModel.fromJson(Map<String, dynamic> json) {
    return MediaUrlsModel(
      thumbnail: json['thumbnail'],
      feed: json['feed'],
      original: json['original'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'thumbnail': thumbnail, 'feed': feed, 'original': original};
  }

  MediaUrlsEntity toEntity() {
    return MediaUrlsEntity(
      thumbnail: thumbnail,
      feed: feed,
      original: original,
    );
  }
}
