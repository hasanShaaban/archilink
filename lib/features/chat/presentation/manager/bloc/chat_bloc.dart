import 'dart:async';

import 'package:archilink/features/Chat/domain/entity/message_entity.dart';
import 'package:archilink/features/Chat/domain/repo/chat_repo.dart';
import 'package:archilink/features/Chat/domain/usecase/listen_to_chat_usecase.dart';
import 'package:bloc/bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatBlocEvent, ChatState> {
  final ListenToChatUsecase _listenToChat;
  StreamSubscription<ChatSocketEvent>? _subscription;
  final List<MessageEntity> _messages = [];
  ChatBloc(this._listenToChat) : super(ChatInitial()) {
    on<SubscribeToChat>(_onSubscribe);
    on<UnsubscribeFromChat>(_onUnsubscribe);
  }

  Future<void> _onSubscribe(
    SubscribeToChat event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatConnecting());

    _subscription = _listenToChat(event.conversationId).listen((socketEvent) {
      switch (socketEvent) {
        case MessageSentEvent():
          _messages.add(socketEvent.message);
          emit(ChatUpdated(List.from(_messages)));

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
}
