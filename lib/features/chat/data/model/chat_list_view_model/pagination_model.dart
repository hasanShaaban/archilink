

import 'package:archilink/features/Chat/domain/entity/chat_list_view_entity.dart/pagination_entity.dart';

class PaginationModel extends PaginationEntity {
  const PaginationModel({
    required super.currentPage,
    required super.perPage,
    required super.total,
    required super.lastPage,
    super.from,
    super.to,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 20,
      total: (json['total'] as num?)?.toInt() ?? 0,
      lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
      from: (json['from'] as num?)?.toInt(),
      to: (json['to'] as num?)?.toInt(),
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

