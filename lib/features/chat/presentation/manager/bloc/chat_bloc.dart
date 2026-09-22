import 'dart:async';

import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/message_entity.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/sender_entity.dart';
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
  int? _subscribedUserId;

  ChatBloc(this._listenToChat, this._chatRepo) : super(ChatState()) {
    on<SubscribeToChat>(_onSubscribe);
    on<UnsubscribeFromChat>(_onUnsubscribe);
    on<FetchInitialMessages>(_onFetchInitial);
    on<FetchMoreMessages>(_onFetchMore);
    on<_OnInternalSocketEvent>(_onSocketEvent);
    on<_OnInternalSocketError>(_onSocketError);
  }

  Future<void> _onSubscribe(
    SubscribeToChat event,
    Emitter<ChatState> emit,
  ) async {
    if (_subscribedUserId == event.userId && _subscription != null) {
      return;
    }
    _subscribedUserId = event.userId;
    emit(state.copyWith(status: ChatStatus.connecting));

    await _subscription?.cancel();
    _subscription = _listenToChat(event.userId).listen(
      (socketEvent) {
        add(_OnInternalSocketEvent(socketEvent));
      },
      onError: (e) => add(_OnInternalSocketError(e.toString())),
    );
  }

  void _onSocketEvent(
    _OnInternalSocketEvent event,
    Emitter<ChatState> emit,
  ) {
    final socketEvent = event.event;
    switch (socketEvent) {
      case MessageSentEvent():
        final updated = [socketEvent.message, ...state.messages];
        emit(state.copyWith(
          messages: updated,
          status: ChatStatus.ready,
          lastSocketEvent: socketEvent,
        ));

      case MessageDeletedEvent():
        final updated = state.messages
            .where((m) => m.id != socketEvent.messageId)
            .toList();
        emit(state.copyWith(
          messages: updated,
          lastSocketEvent: socketEvent,
        ));

      case MessagesDeliveredEvent():
      case MessagesSeenEvent():
        emit(state.copyWith(lastSocketEvent: socketEvent));
    }
  }

  void _onSocketError(
    _OnInternalSocketError event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(
      status: ChatStatus.error,
      errorMessage: event.error,
    ));
  }

  Future<void> _onUnsubscribe(
    UnsubscribeFromChat event,
    Emitter<ChatState> emit,
  ) async {
    _subscribedUserId = null;
    await _subscription?.cancel();
    _subscription = null;
    emit(ChatState());
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
    emit(state.copyWith(isLoading: true, status: ChatStatus.loading));

    final result = await _chatRepo.fetchMessages(
      conversationId: event.conversationId,
      page: 1,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ChatStatus.error,
          errorMessage: failure.message,
          isLoading: false,
        ),
      ),
      (response) {
        final participants = response.messages
            .map((m) => m.sender)
            .toSet()
            .toList();
        emit(
          state.copyWith(
            messages: response.messages,
            participants: participants,
            isLoading: false,
            hasReachedMax: !response.pagination.hasMore,
            page: 1,
            status: ChatStatus.ready,
          ),
        );
      },
    );
  }

  Future<void> _onFetchMore(
    FetchMoreMessages event,
    Emitter<ChatState> emit,
  ) async {
    if (state.isLoading || state.hasReachedMax) return;

    emit(state.copyWith(isLoading: true));

    final result = await _chatRepo.fetchMessages(
      conversationId: event.conversationId,
      page: state.page + 1,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ChatStatus.error,
          errorMessage: failure.message,
          isLoading: false,
        ),
      ),
      (response) => emit(
        state.copyWith(
          // older messages go at the end (chat is newest-first)
          messages: [...state.messages, ...response.messages],
          isLoading: false,
          hasReachedMax: !response.pagination.hasMore,
          page: state.page + 1,
        ),
      ),
    );
  }
}
