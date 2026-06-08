import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/message_entity.dart';
import 'package:equatable/equatable.dart';

class CustomerSupportMessagesState extends Equatable {
  static const Object _noChange = Object();

  const CustomerSupportMessagesState({
    this.messages = const <MessageEntity>[],
    this.messagesPage = 0,
    this.hasMoreMessages = true,
    this.isLoadingMessages = false,
    this.isLoadingMoreMessages = false,
    this.messagesErrorMessage,
  });

  final List<MessageEntity> messages;
  final int messagesPage;
  final bool hasMoreMessages;
  final bool isLoadingMessages;
  final bool isLoadingMoreMessages;
  final String? messagesErrorMessage;

  bool get hasMessagesData => messages.isNotEmpty;

  CustomerSupportMessagesState copyWith({
    List<MessageEntity>? messages,
    int? messagesPage,
    bool? hasMoreMessages,
    bool? isLoadingMessages,
    bool? isLoadingMoreMessages,
    Object? messagesErrorMessage = _noChange,
  }) {
    return CustomerSupportMessagesState(
      messages: messages ?? this.messages,
      messagesPage: messagesPage ?? this.messagesPage,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      isLoadingMoreMessages:
          isLoadingMoreMessages ?? this.isLoadingMoreMessages,
      messagesErrorMessage: messagesErrorMessage == _noChange
          ? this.messagesErrorMessage
          : messagesErrorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
        messages,
        messagesPage,
        hasMoreMessages,
        isLoadingMessages,
        isLoadingMoreMessages,
        messagesErrorMessage,
      ];
}

final class CustomerSupportMessagesInitial extends CustomerSupportMessagesState {
  const CustomerSupportMessagesInitial();
}
