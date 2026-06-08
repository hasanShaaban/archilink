import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/message_entity.dart';
import 'package:archilink/features/settings/domain/repo/setting_repo.dart';
import 'package:bloc/bloc.dart';
import 'customer_support_messages_state.dart';

class CustomerSupportMessagesCubit extends Cubit<CustomerSupportMessagesState> {
  CustomerSupportMessagesCubit(this._settingRepo) : super(const CustomerSupportMessagesInitial());

  final SettingRepo _settingRepo;

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
