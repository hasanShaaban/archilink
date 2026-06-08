import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/message_entity.dart';
import 'package:equatable/equatable.dart';

enum MessageStatus { sending, sent, failed }

class CustomerSupportMessagesState extends Equatable {
  static const Object _noChange = Object();

  const CustomerSupportMessagesState({
    this.messages = const <MessageEntity>[],
    this.pendingMessages = const <MessageEntity>[],
    this.messageStatuses = const <int, MessageStatus>{},
    this.messagesPage = 0,
    this.hasMoreMessages = true,
    this.isLoadingMessages = false,
    this.isLoadingMoreMessages = false,
    this.messagesErrorMessage,
    this.sendMessageFailure,
  });

  final List<MessageEntity> messages;
  final List<MessageEntity> pendingMessages;
  final Map<int, MessageStatus> messageStatuses;
  final int messagesPage;
  final bool hasMoreMessages;
  final bool isLoadingMessages;
  final bool isLoadingMoreMessages;
  final String? messagesErrorMessage;
  final Failure? sendMessageFailure;

  bool get hasMessagesData => messages.isNotEmpty || pendingMessages.isNotEmpty;

  CustomerSupportMessagesState copyWith({
    List<MessageEntity>? messages,
    List<MessageEntity>? pendingMessages,
    Map<int, MessageStatus>? messageStatuses,
    int? messagesPage,
    bool? hasMoreMessages,
    bool? isLoadingMessages,
    bool? isLoadingMoreMessages,
    Object? messagesErrorMessage = _noChange,
    Object? sendMessageFailure = _noChange,
  }) {
    return CustomerSupportMessagesState(
      messages: messages ?? this.messages,
      pendingMessages: pendingMessages ?? this.pendingMessages,
      messageStatuses: messageStatuses ?? this.messageStatuses,
      messagesPage: messagesPage ?? this.messagesPage,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      isLoadingMoreMessages:
          isLoadingMoreMessages ?? this.isLoadingMoreMessages,
      messagesErrorMessage: messagesErrorMessage == _noChange
          ? this.messagesErrorMessage
          : messagesErrorMessage as String?,
      sendMessageFailure: sendMessageFailure == _noChange
          ? this.sendMessageFailure
          : sendMessageFailure as Failure?,
    );
  }

  @override
  List<Object?> get props => [
    messages,
    pendingMessages,
    messageStatuses,
    messagesPage,
    hasMoreMessages,
    isLoadingMessages,
    isLoadingMoreMessages,
    messagesErrorMessage,
    sendMessageFailure,
  ];
}

final class CustomerSupportMessagesInitial
    extends CustomerSupportMessagesState {
  const CustomerSupportMessagesInitial();
}
