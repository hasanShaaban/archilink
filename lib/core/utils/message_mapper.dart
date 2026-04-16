import 'package:archilink/features/Chat/domain/entity/message_entity.dart';
import 'package:chatview/chatview.dart';

extension MessageMapper on MessageEntity {
  Message toChatViewMessage(String currentUserId) {
    return Message(
      id: id.toString(),
      message: content,
      createdAt: sentAt ?? DateTime.now(),
      sentBy: sender.id.toString(),
      // Map first reaction if any — chatview takes a single emoji string
      reaction: reactions.isNotEmpty
          ? Reaction(
              reactions: reactions.map((r) => r.reaction).toList(),
              reactedUserIds: reactions
                  .map((r) => r.userId.toString())
                  .toList(),
            )
          : null,
    );
  }
}
