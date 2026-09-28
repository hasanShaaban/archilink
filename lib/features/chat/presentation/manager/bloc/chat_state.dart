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
  final ChatSocketEvent? lastSocketEvent;
  final MessageEntity? lastSentMessage;
  final String? lastSentTempId;
  final String? failedTempId;

  /// The conversation ID currently loaded in this chat view.
  final int? currentConversationId;

  /// Pre-built ChatController owned by the Bloc so the view never rebuilds it.
  /// Null until the first page of messages has arrived.
  final ChatController? chatController;

  ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.hasReachedMax = false,
    this.page = 1,
    this.status = ChatStatus.initial,
    this.errorMessage,
    this.participants = const [],
    this.lastSocketEvent,
    this.lastSentMessage,
    this.lastSentTempId,
    this.failedTempId,
    this.currentConversationId,
    this.chatController,
  });

  ChatState copyWith({
    List<MessageEntity>? messages,
    bool? isLoading,
    bool? hasReachedMax,
    int? page,
    ChatStatus? status,
    String? errorMessage,
    List<SenderEntity>? participants,
    ChatSocketEvent? lastSocketEvent,
    MessageEntity? lastSentMessage,
    String? lastSentTempId,
    String? failedTempId,
    int? currentConversationId,
    ChatController? chatController,
    bool clearChatController = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      participants: participants ?? this.participants,
      lastSocketEvent: lastSocketEvent ?? this.lastSocketEvent,
      lastSentMessage: lastSentMessage ?? this.lastSentMessage,
      lastSentTempId: lastSentTempId ?? this.lastSentTempId,
      failedTempId: failedTempId ?? this.failedTempId,
      currentConversationId:
          currentConversationId ?? this.currentConversationId,
      chatController:
          clearChatController ? null : (chatController ?? this.chatController),
    );
  }
}
