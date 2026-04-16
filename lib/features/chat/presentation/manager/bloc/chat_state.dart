part of 'chat_bloc.dart';

class ChatState {
  final List<MessageEntity> messages;
  final bool isLoading;
  final bool hasReachedMax;
  final int page;

  ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.hasReachedMax = false,
    this.page = 1,
  });

  ChatState copyWith({
    List<MessageEntity>? messages,
    bool? isLoading,
    bool? hasReachedMax,
    int? page,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
    );
  }
}

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
