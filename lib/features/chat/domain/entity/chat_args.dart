class ChatArgs {
  final int conversationId;
  final String chatTitle;
  final String? profileImage;

  const ChatArgs({
    required this.conversationId,
    required this.chatTitle,
    this.profileImage,
  });
}