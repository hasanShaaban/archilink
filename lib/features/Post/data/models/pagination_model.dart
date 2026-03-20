import 'package:archilink/features/Post/domain/entity/pagination_entity.dart';

class PaginationModel {
  final int currentPage;
  final int perPage;
  final int lastPage;
  final int total;
  final bool hasMore;
  final String? next;
  final String? prev;

  PaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.lastPage,
    required this.total,
    required this.hasMore,
    this.next,
    this.prev,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['current_page'],
      perPage: json['per_page'],
      lastPage: json['last_page'],
      total: json['total'],
      hasMore: json['has_more'],
      next: json['next'],
      prev: json['prev'],
    );
  }

  PaginationEntity toEntity() {
    return PaginationEntity(
      currentPage: currentPage,
      perPage: perPage,
      lastPage: lastPage,
      total: total,
      hasMore: hasMore,
      next: next,
      prev: prev,
    );
  }
}