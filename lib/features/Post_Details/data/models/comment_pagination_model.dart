import 'package:archilink/features/Post_Details/domain/entity/comment_pagination_entity.dart';

class CommentsPaginationModel extends CommentsPaginationEntity {
  const CommentsPaginationModel({
    required super.currentPage,
    required super.perPage,
    required super.lastPage,
    required super.total,
    required super.hasMore,
    super.next,
    super.prev,
  });

  factory CommentsPaginationModel.fromJson(Map<String, dynamic> json) {
    return CommentsPaginationModel(
      currentPage: json['current_page'],
      perPage: json['per_page'],
      lastPage: json['last_page'],
      total: json['total'],
      hasMore: json['has_more'],
      next: json['next'],
      prev: json['prev'],
    );
  }
}