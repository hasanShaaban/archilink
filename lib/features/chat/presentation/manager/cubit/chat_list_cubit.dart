import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Chat/domain/entity/chat_list_view_entity.dart/chat_entity.dart';
import 'package:archilink/features/Chat/domain/repo/chat_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final ChatRepo chatRepo;
  ChatListCubit(this.chatRepo) : super(ChatListState());

  Future<void> getChats() async {
    emit(state.copyWith(isLoading: true, failure: null));
    final result = await chatRepo.getChats();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
      (chats) => emit(state.copyWith(isLoading: false, chats: chats.chats)),
    );
  }
}
