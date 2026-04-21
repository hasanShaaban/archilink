class MessagesPaginationEntity {
  final int currentPage;
  final int perPage;
  final int lastPage;
  final int total;
  final bool hasMore;
  final String? next;
  final String? prev;

  const MessagesPaginationEntity({
    required this.currentPage,
    required this.perPage,
    required this.lastPage,
    required this.total,
    required this.hasMore,
    this.next,
    this.prev,
  });
}