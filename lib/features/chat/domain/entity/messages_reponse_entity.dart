import 'package:archilink/features/Chat/domain/entity/message_entity.dart';
import 'package:archilink/features/Post/domain/entity/pagination_entity.dart';

class MessagesResponseEntity {
  final List<MessageEntity> messages;
  final PaginationEntity pagination;

  const MessagesResponseEntity({
    required this.messages,
    required this.pagination,
  });
}