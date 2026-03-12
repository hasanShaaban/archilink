import 'package:archilink/features/Post_Details/data/models/comment_model.dart';
import 'package:archilink/features/Post_Details/data/models/comment_pagination_model.dart';
import 'package:archilink/features/Post_Details/domain/entity/post_comments_entity.dart';

class PostCommentsModel extends PostCommentsEntity {
  const PostCommentsModel({required super.comments, required super.pagination});

  factory PostCommentsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return PostCommentsModel(
      comments: List<CommentModel>.from(
        data['comments'].map((e) => CommentModel.fromJson(e)),
      ),
      pagination: CommentsPaginationModel.fromJson(data['pagination']),
    );
  }
}
