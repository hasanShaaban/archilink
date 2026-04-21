class LastMessageEntity {
  final int id;
  final int chatId;
  final String content;
  final DateTime sentAt;
  final DateTime? editedAt;

  const LastMessageEntity({
    required this.id,
    required this.chatId,
    required this.content,
    required this.sentAt,
    this.editedAt,
  });
}
