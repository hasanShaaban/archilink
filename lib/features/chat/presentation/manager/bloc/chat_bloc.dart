import 'dart:async';

import 'package:archilink/core/utils/message_mapper.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/message_entity.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/sender_entity.dart';
import 'package:archilink/features/Chat/domain/repo/chat_repo.dart';
import 'package:archilink/features/Chat/domain/repo/chat_websocket_repo.dart';
import 'package:archilink/features/Chat/domain/usecase/listen_to_chat_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter/widgets.dart';

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
    on<SendChatMessage>(_onSendMessage);
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
        final msg = socketEvent.message;
        final updated = [msg, ...state.messages];
        final ctrl = state.chatController;

        if (ctrl != null) {
          final currentUserId = ctrl.currentUser.id;
          final msgId = msg.id.toString();

          // Register sender if not already known
          final senderId = msg.sender.id.toString();
          if (senderId != currentUserId) {
            ctrl.updateOtherUser(
              ChatUser(
                id: senderId,
                name: msg.sender.name.isNotEmpty ? msg.sender.name : senderId,
                profilePhoto: msg.sender.userAvatar,
              ),
            );
          }

          // Only add to UI if not already present (dedup with temp-id handled in view)
          final alreadyPresent =
              ctrl.initialMessageList.any((m) => m.id == msgId);
          if (!alreadyPresent) {
            ctrl.addMessage(msg.toChatViewMessage(currentUserId));
          }
        }

        emit(state.copyWith(
          messages: updated,
          status: ChatStatus.ready,
          lastSocketEvent: socketEvent,
        ));

      case MessageDeletedEvent():
        if (socketEvent.chatId == state.currentConversationId) {
          final updated = state.messages
              .where((m) => m.id != socketEvent.messageId)
              .toList();

          // Remove from ChatController's list directly
          final ctrl = state.chatController;
          if (ctrl != null) {
            final msgIdStr = socketEvent.messageId.toString();
            final idx = ctrl.initialMessageList
                .indexWhere((m) => m.id == msgIdStr);
            if (idx != -1) {
              ctrl.initialMessageList.removeAt(idx);
              if (!ctrl.messageStreamController.isClosed) {
                ctrl.messageStreamController.sink
                    .add(ctrl.initialMessageList);
              }
            }
          }

          emit(state.copyWith(messages: updated, lastSocketEvent: socketEvent));
        } else {
          emit(state.copyWith(lastSocketEvent: socketEvent));
        }

      case MessagesSeenEvent():
      case MessageReactionAddedEvent():
      case MessageReactionRemovedEvent():
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
    await _listenToChat.disconnect();
    emit(ChatState());
  }


  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  /// Build the full set of other-users from a participant+message list.
  Map<String, ChatUser> _buildOtherUsersMap({
    required List<SenderEntity> participants,
    required List<MessageEntity> messages,
    required String currentUserId,
    required String fallbackName,
    required String? fallbackAvatar,
  }) {
    final map = <String, ChatUser>{};
    for (final s in participants) {
      final sid = s.id.toString();
      if (sid != currentUserId) {
        map[sid] = ChatUser(
          id: sid,
          name: s.name.isNotEmpty ? s.name : fallbackName,
          profilePhoto: s.userAvatar ?? fallbackAvatar,
        );
      }
    }
    for (final m in messages) {
      final s = m.sender;
      final sid = s.id.toString();
      if (sid != currentUserId) {
        map.putIfAbsent(
          sid,
          () => ChatUser(
            id: sid,
            name: s.name.isNotEmpty ? s.name : fallbackName,
            profilePhoto: s.userAvatar ?? fallbackAvatar,
          ),
        );
      }
    }
    if (map.isEmpty) {
      map['__placeholder__'] = ChatUser(
        id: '__placeholder__',
        name: fallbackName,
        profilePhoto: fallbackAvatar,
      );
    }
    return map;
  }

  // ─── Fetch initial ───────────────────────────────────────────────────────

  Future<void> _onFetchInitial(
    FetchInitialMessages event,
    Emitter<ChatState> emit,
  ) async {
    // Dispose old controller so the view gets null → loading indicator
    state.chatController?.dispose();

    emit(state.copyWith(
      isLoading: true,
      status: ChatStatus.loading,
      messages: [],
      participants: [],
      page: 1,
      hasReachedMax: false,
      currentConversationId: event.conversationId,
      clearChatController: true,
    ));

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
        final participants =
            response.messages.map((m) => m.sender).toSet().toList();

        final currentUserIdStr = event.currentUserId.toString();
        final currentSender = participants.cast<SenderEntity?>().firstWhere(
              (p) => p!.id == event.currentUserId,
              orElse: () => null,
            );

        final currentUser = ChatUser(
          id: currentUserIdStr,
          name: currentSender?.name ?? '',
          profilePhoto: currentSender?.userAvatar,
        );

        final otherUsersMap = _buildOtherUsersMap(
          participants: participants,
          messages: response.messages,
          currentUserId: currentUserIdStr,
          fallbackName: event.chatTitle,
          fallbackAvatar: event.profileImage,
        );

        final chatViewMessages = response.messages
            .map((e) => e.toChatViewMessage(currentUserIdStr))
            .toList()
            .reversed
            .toList();

        final controller = ChatController(
          initialMessageList: chatViewMessages,
          scrollController: ScrollController(),
          currentUser: currentUser,
          otherUsers: otherUsersMap.values.toList(),
        );

        emit(
          state.copyWith(
            messages: response.messages,
            participants: participants,
            isLoading: false,
            hasReachedMax: !response.pagination.hasMore,
            page: 1,
            status: ChatStatus.ready,
            currentConversationId: event.conversationId,
            chatController: controller,
          ),
        );
      },
    );
  }

  // ─── Fetch more (pagination) ──────────────────────────────────────────────

  Future<void> _onFetchMore(
    FetchMoreMessages event,
    Emitter<ChatState> emit,
  ) async {
    if (state.isLoading || state.hasReachedMax) {
      event.completer?.complete(null);
      return;
    }

    emit(state.copyWith(isLoading: true));

    final result = await _chatRepo.fetchMessages(
      conversationId: event.conversationId,
      page: state.page + 1,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ChatStatus.error,
            errorMessage: failure.message,
            isLoading: false,
          ),
        );
        event.completer?.complete(null);
      },
      (response) {
        final newParticipants = response.messages.map((m) => m.sender);
        final allParticipants = {
          ...state.participants,
          ...newParticipants,
        }.toList();

        // Register any new senders in the controller
        final ctrl = state.chatController;
        if (ctrl != null) {
          final currentUserId = ctrl.currentUser.id;
          for (final entity in response.messages) {
            final s = entity.sender;
            final sid = s.id.toString();
            if (sid != currentUserId) {
              ctrl.updateOtherUser(
                ChatUser(
                  id: sid,
                  name: s.name.isNotEmpty ? s.name : sid,
                  profilePhoto: s.userAvatar,
                ),
              );
            }
          }
        }

        emit(
          state.copyWith(
            messages: [...state.messages, ...response.messages],
            participants: allParticipants,
            isLoading: false,
            hasReachedMax: !response.pagination.hasMore,
            page: state.page + 1,
          ),
        );
        event.completer?.complete(response.messages);
      },
    );
  }

  // ─── Send message ─────────────────────────────────────────────────────────

  Future<void> _onSendMessage(
    SendChatMessage event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepo.sendMessage(
      conversationId: event.conversationId,
      content: event.content,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          failedTempId: event.tempId,
        ),
      ),
      (sentMessage) {
        final updated = state.messages.any((m) => m.id == sentMessage.id)
            ? state.messages
            : [sentMessage, ...state.messages];
        emit(
          state.copyWith(
            messages: updated,
            lastSentMessage: sentMessage,
            lastSentTempId: event.tempId,
          ),
        );
      },
    );
  }
}
