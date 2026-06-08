import 'package:archilink/features/settings/domain/entity/customer_support_chat_entity.dart';
import 'package:equatable/equatable.dart';

class CustomerSupportChatState extends Equatable {
  static const Object _noChange = Object();

  const CustomerSupportChatState({
    this.chatDetails,
    this.isLoadingChatDetails = false,
    this.chatDetailsErrorMessage,
  });

  final CustomerSupportChatEntity? chatDetails;
  final bool isLoadingChatDetails;
  final String? chatDetailsErrorMessage;

  CustomerSupportChatState copyWith({
    CustomerSupportChatEntity? chatDetails,
    bool? isLoadingChatDetails,
    Object? chatDetailsErrorMessage = _noChange,
  }) {
    return CustomerSupportChatState(
      chatDetails: chatDetails ?? this.chatDetails,
      isLoadingChatDetails: isLoadingChatDetails ?? this.isLoadingChatDetails,
      chatDetailsErrorMessage: chatDetailsErrorMessage == _noChange
          ? this.chatDetailsErrorMessage
          : chatDetailsErrorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
        chatDetails,
        isLoadingChatDetails,
        chatDetailsErrorMessage,
      ];
}

final class CustomerSupportChatInitial extends CustomerSupportChatState {
  const CustomerSupportChatInitial();
}
