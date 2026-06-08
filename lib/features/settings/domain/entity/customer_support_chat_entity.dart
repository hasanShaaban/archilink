class CustomerSupportChatEntity {
  final int id;
  final String type;
  final String chatName;
  final String? chatCoverUrl;
  final CustomerSupportLastMessageEntity? lastMessage;
  final int unreadMessagesCount;

  const CustomerSupportChatEntity({
    required this.id,
    required this.type,
    required this.chatName,
    this.chatCoverUrl,
    this.lastMessage,
    required this.unreadMessagesCount,
  });
}

class CustomerSupportLastMessageEntity {
  final int id;
  final int chatId;
  final String content;
  final DateTime sentAt;
  final DateTime? editedAt;

  const CustomerSupportLastMessageEntity({
    required this.id,
    required this.chatId,
    required this.content,
    required this.sentAt,
    this.editedAt,
  });
}
