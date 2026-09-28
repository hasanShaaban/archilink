import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/message_entity.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/reaction_entity.dart';

abstract class ChatWebsocketRepo {
  Stream<ChatSocketEvent> connect(int currentUserId);
  Future<void> disconnect();
}

sealed class ChatSocketEvent {}

/// Fired when a new message is added.
/// Backend event: `message.added`
class MessageAddedEvent extends ChatSocketEvent {
  final MessageEntity message;
  MessageAddedEvent(this.message);
}

/// Backwards compatibility alias for MessageAddedEvent
typedef MessageSentEvent = MessageAddedEvent;

/// Fired when a message is deleted.
/// Backend event: `message.deleted`
/// Payload: { chat_id, message_id }
class MessageDeletedEvent extends ChatSocketEvent {
  final int chatId;
  final int messageId;
  MessageDeletedEvent({required this.chatId, required this.messageId});
}

/// Fired when messages in a chat are marked as seen.
/// Backend event: `messages.seen`
/// Payload: { user_id, chat_id, read_outbox_max_id }
class MessagesSeenEvent extends ChatSocketEvent {
  final int userId;
  final int chatId;
  /// The last message id that was read (messages up to this id are considered seen).
  final int readOutboxMaxId;
  MessagesSeenEvent({
    required this.userId,
    required this.chatId,
    required this.readOutboxMaxId,
  });
}

/// Fired when a reaction is added to a message.
/// Backend event: `message.reaction.added`
/// Payload: { chat_id, reaction: MessageReactionResource }
class MessageReactionAddedEvent extends ChatSocketEvent {
  final int chatId;
  final ReactionEntity reaction;
  MessageReactionAddedEvent({required this.chatId, required this.reaction});
}

/// Fired when a reaction is removed from a message.
/// Backend event: `message.reaction.removed`
/// Payload: { chat_id, message_id, user_id }
class MessageReactionRemovedEvent extends ChatSocketEvent {
  final int chatId;
  final int messageId;
  final int userId;
  MessageReactionRemovedEvent({
    required this.chatId,
    required this.messageId,
    required this.userId,
  });
}
