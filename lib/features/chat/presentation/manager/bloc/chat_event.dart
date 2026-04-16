part of 'chat_bloc.dart';

sealed class ChatBlocEvent {}

class SubscribeToChat extends ChatBlocEvent {
  final int conversationId;
  SubscribeToChat(this.conversationId);
}

class UnsubscribeFromChat extends ChatBlocEvent {
  final int conversationId;
  UnsubscribeFromChat(this.conversationId);
}
class FetchInitialMessages extends ChatBlocEvent {
  final int conversationId;
  FetchInitialMessages(this.conversationId);
}

class FetchMoreMessages extends ChatBlocEvent {
  final int conversationId;
  FetchMoreMessages(this.conversationId);
}