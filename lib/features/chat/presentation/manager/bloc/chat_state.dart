part of 'chat_bloc.dart';

enum ChatStatus { initial, connecting, loading, ready, error }

class ChatState {
  final List<MessageEntity> messages;
  final bool isLoading;
  final bool hasReachedMax;
  final int page;
  final ChatStatus status;
  final String? errorMessage;
  final List<SenderEntity> participants;

  ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.hasReachedMax = false,
    this.page = 1,
    this.status = ChatStatus.initial,
    this.errorMessage,
    this.participants = const [],
  });

  ChatState copyWith({
    List<MessageEntity>? messages,
    bool? isLoading,
    bool? hasReachedMax,
    int? page,
    ChatStatus? status,
    String? errorMessage,
    List<SenderEntity>? participants,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      participants: participants ?? this.participants,
    );
  }
}
