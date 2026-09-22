part of 'chat_bloc.dart';

sealed class ChatBlocEvent {}

class SubscribeToChat extends ChatBlocEvent {
  final int userId;
  SubscribeToChat(this.userId);
}

class UnsubscribeFromChat extends ChatBlocEvent {
  final int userId;
  UnsubscribeFromChat(this.userId);
}

class FetchInitialMessages extends ChatBlocEvent {
  final int conversationId;
  FetchInitialMessages(this.conversationId);
}

class FetchMoreMessages extends ChatBlocEvent {
  final int conversationId;
  FetchMoreMessages(this.conversationId);
}

class _OnInternalSocketEvent extends ChatBlocEvent {
  final ChatSocketEvent event;
  _OnInternalSocketEvent(this.event);
}

class _OnInternalSocketError extends ChatBlocEvent {
  final String error;
  _OnInternalSocketError(this.error);
}

