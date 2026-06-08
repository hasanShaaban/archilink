import 'package:archilink/features/settings/domain/entity/customer_support_chat_entity.dart';
import 'package:archilink/features/settings/domain/repo/setting_repo.dart';
import 'package:bloc/bloc.dart';
import 'customer_support_chat_state.dart';

class CustomerSupportChatCubit extends Cubit<CustomerSupportChatState> {
  CustomerSupportChatCubit(this._settingRepo) : super(const CustomerSupportChatInitial());

  final SettingRepo _settingRepo;

  void updateLastMessage(CustomerSupportLastMessageEntity lastMessage) {
    if (state.chatDetails == null) return;

    final updatedChatDetails = CustomerSupportChatEntity(
      id: state.chatDetails!.id,
      type: state.chatDetails!.type,
      chatName: state.chatDetails!.chatName,
      chatCoverUrl: state.chatDetails!.chatCoverUrl,
      lastMessage: lastMessage,
      unreadMessagesCount: state.chatDetails!.unreadMessagesCount,
    );

    emit(state.copyWith(chatDetails: updatedChatDetails));
  }

  Future<void> fetchChatDetails() async {
    if (state.isLoadingChatDetails) return;

    emit(
      state.copyWith(
        isLoadingChatDetails: true,
        chatDetailsErrorMessage: null,
      ),
    );

    final result = await _settingRepo.getCustomerSupportChatDetails();
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingChatDetails: false,
            chatDetailsErrorMessage: failure.message,
          ),
        );
      },
      (chatDetails) {
        emit(
          state.copyWith(
            isLoadingChatDetails: false,
            chatDetailsErrorMessage: null,
            chatDetails: chatDetails,
          ),
        );
      },
    );
  }
}
