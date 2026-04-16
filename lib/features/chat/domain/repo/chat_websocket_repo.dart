import 'package:archilink/features/Chat/domain/entity/message_entity.dart';

abstract class ChatWebsocketRepo {
  Stream<ChatSocketEvent> subscribeToChannle(int conversationId);
  Future<void> unsubscribeFromChannle(int conversationId);
}

sealed class ChatSocketEvent {}

class MessageSentEvent extends ChatSocketEvent {
  final MessageEntity message;
  MessageSentEvent(this.message);
}

class MessageDeletedEvent extends ChatSocketEvent {
  final int messageId;
  MessageDeletedEvent(this.messageId);
}

class MessagesDeliveredEvent extends ChatSocketEvent {
  final int conversationId;
  MessagesDeliveredEvent(this.conversationId);
}

class MessagesSeenEvent extends ChatSocketEvent {
  final int conversationId;
  MessagesSeenEvent(this.conversationId);
}
