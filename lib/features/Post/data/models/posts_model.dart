import 'package:archilink/features/Post/data/models/pagination_model.dart';
import 'package:archilink/features/Post/data/models/post_model.dart';
import 'package:archilink/features/Post/domain/entity/posts_entity.dart';

class PostsModel {
  final List<PostModel> posts;
  final PaginationModel pagination;

  PostsModel({
    required this.posts,
    required this.pagination,
  });

  factory PostsModel.fromJson(Map<String, dynamic> json) {

    return PostsModel(
      posts: (json['posts'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination']),
    );
  }

  PostsEntity toEntity() {
    return PostsEntity(
      posts: posts.map((e) => e.toEntity()).toList(),
      pagination: pagination.toEntity(),
    );
  }
}