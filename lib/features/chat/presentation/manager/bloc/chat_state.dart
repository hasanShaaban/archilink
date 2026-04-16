part of 'chat_bloc.dart';

sealed class ChatState {}

final class ChatInitial extends ChatState {}

class ChatConnecting extends ChatState {}

class ChatUpdated extends ChatState {
  final List<MessageEntity> messages;
  ChatUpdated(this.messages);
}

class MessageRemovedState extends ChatState {
  final int messageId;
  MessageRemovedState(this.messageId);
}

class MessagesStatusUpdated extends ChatState {
  final String status; // 'delivered' | 'seen'
  MessagesStatusUpdated(this.status);
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
