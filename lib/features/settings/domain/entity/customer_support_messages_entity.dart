import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/message_entity.dart';
import 'package:archilink/features/Post/domain/entity/pagination_entity.dart';

class CustomerSupportMessagesEntity {
  final List<MessageEntity> messages;
  final PaginationEntity pagination;

  const CustomerSupportMessagesEntity({
    required this.messages,
    required this.pagination,
  });
}
