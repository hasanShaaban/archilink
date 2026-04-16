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
