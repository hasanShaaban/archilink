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

  FetchInitialMessages({
    required this.conversationId,
    required this.currentUserId,
    required this.chatTitle,
    this.profileImage,
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

