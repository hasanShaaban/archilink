class ChatArgs {
  final int conversationId;
  final String chatTitle;
  final String? profileImage;

  /// The last outgoing message id that the OTHER user has already read,
  /// sourced from ChatEntity.readOutboxMaxId when opening the chat.
  final int? readOutboxMaxId;

  const ChatArgs({
    required this.conversationId,
    required this.chatTitle,
    this.profileImage,
    this.readOutboxMaxId,
  });
}