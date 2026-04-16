import 'dart:async';

import 'package:archilink/features/Chat/domain/entity/message_entity.dart';
import 'package:archilink/features/Chat/domain/repo/chat_repo.dart';
import 'package:archilink/features/Chat/domain/repo/chat_websocket_repo.dart';
import 'package:archilink/features/Chat/domain/usecase/listen_to_chat_usecase.dart';
import 'package:bloc/bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatBlocEvent, ChatState> {
  final ChatRepo _chatRepo;
  final ListenToChatUsecase _listenToChat;
  StreamSubscription<ChatSocketEvent>? _subscription;
  final List<MessageEntity> _messages = [];
  ChatBloc(this._listenToChat, this._chatRepo) : super(ChatInitial()) {
    on<SubscribeToChat>(_onSubscribe);
    on<UnsubscribeFromChat>(_onUnsubscribe);
    on<FetchInitialMessages>(_onFetchInitial);
    on<FetchMoreMessages>(_onFetchMore);
  }

  Future<void> _onSubscribe(
    SubscribeToChat event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatConnecting());

    _subscription = _listenToChat(event.conversationId).listen((socketEvent) {
      switch (socketEvent) {
        case MessageSentEvent():
          final updated = List<MessageEntity>.from(state.messages)
            ..add(socketEvent.message);

          emit(state.copyWith(messages: updated));

        case MessageDeletedEvent():
          _messages.removeWhere((m) => m.id == socketEvent.messageId);
          emit(MessageRemovedState(socketEvent.messageId));

        case MessagesDeliveredEvent():
          emit(MessagesStatusUpdated('delivered'));

        case MessagesSeenEvent():
          emit(MessagesStatusUpdated('seen'));
      }
    }, onError: (e) => emit(ChatError(e.toString())));
  }

  Future<void> _onUnsubscribe(
    UnsubscribeFromChat event,
    Emitter<ChatState> emit,
  ) async {
    await _subscription?.cancel();
    _messages.clear();
    emit(ChatInitial());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> _onFetchInitial(
    FetchInitialMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, page: 1));

    final result = await _chatRepo.fetchMessages(
      conversationId: event.conversationId,
      page: 1,
    );

    result.fold((failure) => emit(ChatError(failure.message)), (response) {
      emit(
        state.copyWith(
          messages: response.messages,
          isLoading: false,
          hasReachedMax: response.messages.isEmpty,
          page: 1,
        ),
      );
    });
  }

  Future<void> _onFetchMore(
    FetchMoreMessages event,
    Emitter<ChatState> emit,
  ) async {
    if (state.isLoading || state.hasReachedMax) return;

    emit(state.copyWith(isLoading: true));

    final nextPage = state.page + 1;

    final result = await _chatRepo.fetchMessages(
      conversationId: event.conversationId,
      page: nextPage,
    );

    result.fold((failure) => emit(ChatError(failure.message)), (response) {
      final newMessages = [...response.messages, ...state.messages];

      emit(
        state.copyWith(
          messages: newMessages,
          isLoading: false,
          hasReachedMax: response.messages.isEmpty,
          page: nextPage,
        ),
      );
    });
  }
}
