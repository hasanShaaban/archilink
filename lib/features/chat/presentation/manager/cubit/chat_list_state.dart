part of 'chat_list_cubit.dart';

class ChatListState extends Equatable {
  final bool isLoading;
  final Failure? failure;
  final List<ChatEntity> chats;
  const ChatListState({
    this.isLoading = false,
    this.failure,
    this.chats = const [],
  });

  ChatListState copyWith({
    bool? isLoading,
    Failure? failure,
    List<ChatEntity>? chats,
  }) {
    return ChatListState(
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
      chats: chats ?? this.chats,
    );
  }

  @override
  List<Object?> get props => [isLoading, failure, chats];
}
