class LastMessageEntity {
  final int id;
  final int chatId;
  final String content;
  final DateTime sentAt;
  final DateTime? editedAt;

  /// The ID of the user who sent this message.
  /// Parsed from the API's `user_id` / `sender_id` field in the
  /// latest_message object.  May be null for legacy data.
  final int? senderId;

  const LastMessageEntity({
    required this.id,
    required this.chatId,
    required this.content,
    required this.sentAt,
    this.editedAt,
    this.senderId,
  });
}
