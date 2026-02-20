import 'package:archilink/features/Home/data/model/pagination_model.dart';
import 'package:archilink/features/Home/data/model/post_model.dart';
import 'package:archilink/features/Home/domain/entity/global_feed_entity.dart';

class GlobalFeedModel {
  final List<PostModel> posts;
  final PaginationModel pagination;

  GlobalFeedModel({
    required this.posts,
    required this.pagination,
  });

  factory GlobalFeedModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return GlobalFeedModel(
      posts: (data['posts'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList(),
      pagination: PaginationModel.fromJson(data['pagination']),
    );
  }

  GlobalFeedEntity toEntity() {
    return GlobalFeedEntity(
      posts: posts.map((e) => e.toEntity()).toList(),
      pagination: pagination.toEntity(),
    );
  }
}