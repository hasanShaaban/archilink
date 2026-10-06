part of 'chat_bloc.dart';

sealed class ChatBlocEvent {}

class SubscribeToChat extends ChatBlocEvent {
  final int userId;
  SubscribeToChat(this.userId);
}

class UnsubscribeFromChat extends ChatBlocEvent {}

class FetchInitialMessages extends ChatBlocEvent {
  final int conversationId;
  final int currentUserId;
  final String chatTitle;
  final String? profileImage;

  /// The readOutboxMaxId from the ChatEntity — used to initialise which
  /// outgoing messages already show green ticks before any WebSocket event.
  final int? readOutboxMaxId;

  FetchInitialMessages({
    required this.conversationId,
    required this.currentUserId,
    required this.chatTitle,
    this.profileImage,
    this.readOutboxMaxId,
  });
}

class FetchMoreMessages extends ChatBlocEvent {
  final int conversationId;
  final Completer<List<MessageEntity>?>? completer;
  FetchMoreMessages(this.conversationId, [this.completer]);
}

class _OnInternalSocketEvent extends ChatBlocEvent {
  final ChatSocketEvent event;
  _OnInternalSocketEvent(this.event);
}

class _OnInternalSocketError extends ChatBlocEvent {
  final String error;
  _OnInternalSocketError(this.error);
}

class SendChatMessage extends ChatBlocEvent {
  final int conversationId;
  final String content;
  final String tempId;

  SendChatMessage({
    required this.conversationId,
    required this.content,
    required this.tempId,
  });
}

class DeleteChatMessage extends ChatBlocEvent {
  final int conversationId;
  final int messageId;

  /// The ID string of this message as it currently lives in ChatController.
  /// This may be a temp ID (e.g. "1719000000000") for messages that were
  /// added optimistically and whose real-ID bubble also exists after socket
  /// delivery, or the real ID string (e.g. "82").
  /// The handler removes BOTH this ID and the real ID string from the
  /// controller so no stale bubble remains.
  final String chatViewMessageId;

  DeleteChatMessage({
    required this.conversationId,
    required this.messageId,
    required this.chatViewMessageId,
  });
}

class ReactToMessage extends ChatBlocEvent {
  final int conversationId;
  final int messageId;
  final String emoji;

  ReactToMessage({
    required this.conversationId,
    required this.messageId,
    required this.emoji,
  });
}

class RemoveReaction extends ChatBlocEvent {
  final int conversationId;
  final int messageId;

  RemoveReaction({
    required this.conversationId,
    required this.messageId,
  });
}

/// Fired from the UI when an incoming message becomes visible on screen.
/// The bloc will POST to chats/{conversationId}/seen and update outbox status
/// locally if [messageId] > current [readOutboxMaxId].
class MarkMessagesSeen extends ChatBlocEvent {
  final int conversationId;

  /// The integer ID of the last visible incoming message.
  final int messageId;

  MarkMessagesSeen({
    required this.conversationId,
    required this.messageId,
  });
}

/// Fired when the user enters a chat view.
/// The bloc immediately pings the presence endpoint and starts a 10-second
/// periodic timer that keeps pinging until [StopPresencePing] is dispatched.
class StartPresencePing extends ChatBlocEvent {
  final int conversationId;
  StartPresencePing(this.conversationId);
}

/// Fired when the user leaves a chat view.
/// Cancels the periodic ping timer and posts to the leave endpoint.
class StopPresencePing extends ChatBlocEvent {
  final int conversationId;
  StopPresencePing(this.conversationId);
}
