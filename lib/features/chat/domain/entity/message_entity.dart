class MessageEntity {
  final int id;
  final int conversationId;
  final int senderId;
  final String content;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });
}