

import 'package:archilink/features/Chat/domain/entity/chat_list_view_entity.dart/pagination_entity.dart';

class PaginationModel extends PaginationEntity {
  const PaginationModel({
    required super.currentPage,
    required super.perPage,
    required super.total,
    required super.lastPage,
    required super.from,
    required super.to,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['current_page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
      lastPage: json['last_page'] as int,
      from: json['from'] as int,
      to: json['to'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'per_page': perPage,
      'total': total,
      'last_page': lastPage,
      'from': from,
      'to': to,
    };
  }
}
