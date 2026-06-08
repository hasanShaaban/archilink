import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/message_entity.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/sender_entity.dart';
import 'package:archilink/features/settings/domain/entity/customer_support_chat_entity.dart';
import 'package:archilink/features/settings/domain/repo/setting_repo.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/customer_support_chat_cubit.dart';
import 'package:bloc/bloc.dart';
import 'customer_support_messages_state.dart';

class CustomerSupportMessagesCubit extends Cubit<CustomerSupportMessagesState> {
  CustomerSupportMessagesCubit(
    this._settingRepo,
    this._currentUserCubit,
    this._chatCubit,
  ) : super(const CustomerSupportMessagesInitial());

  final SettingRepo _settingRepo;
  final CurrentUserCubit _currentUserCubit;
  final CustomerSupportChatCubit _chatCubit;

  Future<void> fetchMessages({bool refresh = false}) async {
    if (state.isLoadingMessages || state.isLoadingMoreMessages) return;

    if (!refresh && state.messagesPage > 0 && !state.hasMoreMessages) return;

    final nextPage = refresh ? 1 : (state.messagesPage + 1);
    final isFirstPage = nextPage == 1;

    emit(
      state.copyWith(
        isLoadingMessages: isFirstPage,
        isLoadingMoreMessages: !isFirstPage,
        messagesErrorMessage: null,
      ),
    );

    final result = await _settingRepo.getCustomerSupportMessages(page: nextPage);
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingMessages: false,
            isLoadingMoreMessages: false,
            messagesErrorMessage: failure.message,
          ),
        );
      },
      (supportMessagesData) {
        final messages = isFirstPage
            ? supportMessagesData.messages
            : _mergeMessages(state.messages, supportMessagesData.messages);

        emit(
          state.copyWith(
            isLoadingMessages: false,
            isLoadingMoreMessages: false,
            messagesErrorMessage: null,
            messages: messages,
            messagesPage: supportMessagesData.pagination.currentPage,
            hasMoreMessages: supportMessagesData.pagination.hasMore,
          ),
        );
      },
    );
  }

  Future<void> sendMessage(String content, {int? tempId}) async {
    final messageId = tempId ?? DateTime.now().millisecondsSinceEpoch;
    final currentUsername = _currentUserCubit.state.username;

    // Create a temporary MessageEntity representing the message in sending state
    final tempMessage = MessageEntity(
      id: messageId,
      chatId: 0,
      content: content,
      sentAt: DateTime.now(),
      sender: SenderEntity(
        id: 0,
        name: currentUsername ?? 'User',
        username: currentUsername ?? 'user',
      ),
      receiptUserIds: const [],
      reactions: const [],
    );

    // Add it to pending list and set status to sending
    final updatedPending = List<MessageEntity>.from(state.pendingMessages);
    final updatedStatuses = Map<int, MessageStatus>.from(state.messageStatuses);

    final existsIndex = updatedPending.indexWhere((m) => m.id == messageId);
    if (existsIndex != -1) {
      updatedPending[existsIndex] = tempMessage;
    } else {
      updatedPending.insert(0, tempMessage);
    }

    updatedStatuses[messageId] = MessageStatus.sending;

    emit(
      state.copyWith(
        pendingMessages: updatedPending,
        messageStatuses: updatedStatuses,
        sendMessageFailure: null,
      ),
    );

    final result = await _settingRepo.sendSupportMessage(message: content);
    if (isClosed) return;

    result.fold(
      (failure) {
        // Mark as failed
        final failedStatuses = Map<int, MessageStatus>.from(state.messageStatuses);
        failedStatuses[messageId] = MessageStatus.failed;
        emit(
          state.copyWith(
            messageStatuses: failedStatuses,
            sendMessageFailure: failure,
          ),
        );
      },
      (responseEntity) {
        // Success: convert to real MessageEntity and clean pending
        final realMessage = responseEntity.toMessageEntity();

        final successPending = List<MessageEntity>.from(state.pendingMessages);
        successPending.removeWhere((m) => m.id == messageId);

        final successStatuses = Map<int, MessageStatus>.from(state.messageStatuses);
        successStatuses.remove(messageId);

        final successMessages = List<MessageEntity>.from(state.messages);
        successMessages.insert(0, realMessage);

        emit(
          state.copyWith(
            pendingMessages: successPending,
            messageStatuses: successStatuses,
            messages: successMessages,
            sendMessageFailure: null,
          ),
        );

        _chatCubit.updateLastMessage(
          CustomerSupportLastMessageEntity(
            id: realMessage.id,
            chatId: realMessage.chatId,
            content: realMessage.content,
            sentAt: realMessage.sentAt ?? DateTime.now(),
            editedAt: realMessage.editedAt,
          ),
        );
      },
    );
  }

  void clearSendMessageFailure() {
    emit(state.copyWith(sendMessageFailure: null));
  }

  List<MessageEntity> _mergeMessages(
    List<MessageEntity> currentMessages,
    List<MessageEntity> incomingMessages,
  ) {
    final merged = <MessageEntity>[...currentMessages];
    final ids = currentMessages.map((e) => e.id).toSet();

    for (final message in incomingMessages) {
      if (ids.add(message.id)) {
        merged.add(message);
      }
    }

    return merged;
  }
}
