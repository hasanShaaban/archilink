import 'package:archilink/features/Post/domain/entity/pagination_entity.dart';

class MessagesPaginationModel extends PaginationEntity {
  const MessagesPaginationModel({
    required super.currentPage,
    required super.perPage,
    required super.lastPage,
    required super.total,
    required super.hasMore,
    super.next,
    super.prev,
  });

  factory MessagesPaginationModel.fromJson(Map<String, dynamic> json) {
    return MessagesPaginationModel(
      currentPage: json['current_page'] as int,
      perPage: json['per_page'] as int,
      lastPage: json['last_page'] as int,
      total: json['total'] as int,
      hasMore: json['has_more'] as bool,
      next: json['next'] as String?,
      prev: json['prev'] as String?,
    );
  }
}
