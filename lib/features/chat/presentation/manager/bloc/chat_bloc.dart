import 'dart:async';

import 'package:archilink/core/utils/message_mapper.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/message_entity.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/reaction_entity.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/sender_entity.dart';
import 'package:archilink/features/Chat/domain/repo/chat_repo.dart';
import 'package:archilink/features/Chat/domain/repo/chat_websocket_repo.dart';
import 'package:archilink/features/Chat/domain/usecase/listen_to_chat_usecase.dart';
import 'package:archilink/features/Chat/domain/usecase/mark_messages_seen_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter/widgets.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatBlocEvent, ChatState> {
  final ChatRepo _chatRepo;
  final ListenToChatUsecase _listenToChat;
  final MarkMessagesSeenUsecase _markMessagesSeen;
  StreamSubscription<ChatSocketEvent>? _subscription;
  int? _subscribedUserId;
  final Map<String, String> _tempToRealId = {};

  ChatBloc(this._listenToChat, this._chatRepo, this._markMessagesSeen)
      : super(ChatState()) {
    on<SubscribeToChat>(_onSubscribe);
    on<UnsubscribeFromChat>(_onUnsubscribe);
    on<FetchInitialMessages>(_onFetchInitial);
    on<FetchMoreMessages>(_onFetchMore);
    on<_OnInternalSocketEvent>(_onSocketEvent);
    on<_OnInternalSocketError>(_onSocketError);
    on<SendChatMessage>(_onSendMessage);
    on<DeleteChatMessage>(_onDeleteMessage);
    on<ReactToMessage>(_onReactToMessage);
    on<RemoveReaction>(_onRemoveReaction);
    on<MarkMessagesSeen>(_onMarkMessagesSeen);
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
        // Only process events for the currently open conversation
        if (socketEvent.chatId == state.currentConversationId) {
          final newMax = socketEvent.readOutboxMaxId;
          final prevMax = state.readOutboxMaxId ?? 0;

          if (newMax > prevMax) {
            // Mark outgoing messages as read in the ChatController
            final ctrl = state.chatController;
            if (ctrl != null) {
              bool changed = false;
              for (var i = 0; i < ctrl.initialMessageList.length; i++) {
                final msg = ctrl.initialMessageList[i];
                final msgId = int.tryParse(msg.id);
                if (msgId != null &&
                    msgId <= newMax &&
                    msg.sentBy == ctrl.currentUser.id &&
                    msg.status != MessageStatus.read) {
                  ctrl.initialMessageList[i] = Message(
                    id: msg.id,
                    message: msg.message,
                    createdAt: msg.createdAt,
                    sentBy: msg.sentBy,
                    status: MessageStatus.read,
                    replyMessage: msg.replyMessage,
                    reaction: msg.reaction,
                    messageType: msg.messageType,
                  );
                  changed = true;
                }
              }
              if (changed && !ctrl.messageStreamController.isClosed) {
                ctrl.messageStreamController.sink.add(ctrl.initialMessageList);
              }
            }

            emit(state.copyWith(
              readOutboxMaxId: newMax,
              lastSocketEvent: socketEvent,
            ));
          } else {
            emit(state.copyWith(lastSocketEvent: socketEvent));
          }
        } else {
          emit(state.copyWith(lastSocketEvent: socketEvent));
        }

      case MessageReactionAddedEvent():
        final matchesChat = socketEvent.chatId == 0 ||
            socketEvent.chatId == state.currentConversationId ||
            state.messages.any((m) => m.id == socketEvent.messageId) ||
            (state.chatController?.initialMessageList.any(
                  (m) =>
                      m.id == socketEvent.messageId.toString() ||
                      _tempToRealId[m.id] == socketEvent.messageId.toString(),
                ) ??
                false);

        if (matchesChat) {
          final newReaction = socketEvent.reaction;
          final updatedMessages = state.messages.map((m) {
            if (m.id != socketEvent.messageId) return m;
            // Keep existing reactions, replacing one from the same user if present
            final existing = m.reactions
                .where((r) => r.userId != newReaction.userId)
                .toList();
            return MessageEntity(
              id: m.id,
              chatId: m.chatId,
              content: m.content,
              sentAt: m.sentAt,
              editedAt: m.editedAt,
              sender: m.sender,
              receiptUserIds: m.receiptUserIds,
              reactions: [...existing, newReaction],
            );
          }).toList();

          // Also update the ChatController's Message reaction in-place
          final ctrl = state.chatController;
          if (ctrl != null) {
            final userIdStr = newReaction.userId.toString();
            if (userIdStr != ctrl.currentUser.id &&
                !ctrl.otherUsers.any((u) => u.id == userIdStr)) {
              final knownSender = state.participants
                      .cast<SenderEntity?>()
                      .firstWhere(
                        (p) => p?.id == newReaction.userId,
                        orElse: () => null,
                      ) ??
                  state.messages
                      .map((m) => m.sender)
                      .cast<SenderEntity?>()
                      .firstWhere(
                        (s) => s?.id == newReaction.userId,
                        orElse: () => null,
                      );
              final fallbackUser = ctrl.otherUsers.firstOrNull;
              ctrl.updateOtherUser(
                ChatUser(
                  id: userIdStr,
                  name: knownSender != null && knownSender.name.isNotEmpty
                      ? knownSender.name
                      : (fallbackUser?.name ?? 'User'),
                  profilePhoto: knownSender?.userAvatar ??
                      fallbackUser?.profilePhoto,
                ),
              );
            }

            final msgIdStr = socketEvent.messageId.toString();
            final idx = ctrl.initialMessageList.indexWhere(
              (m) => m.id == msgIdStr || _tempToRealId[m.id] == msgIdStr,
            );
            if (idx != -1) {
              final existing = ctrl.initialMessageList[idx];
              final prevReactions = existing.reaction.reactions;
              final prevUserIds = existing.reaction.reactedUserIds;

              // Replace this user's old reaction (if any), then add new one
              final userIdStr = newReaction.userId.toString();
              final filteredEmojis = <String>[];
              final filteredUsers = <String>[];
              for (var i = 0; i < prevUserIds.length; i++) {
                if (prevUserIds[i] != userIdStr) {
                  filteredEmojis.add(prevReactions[i]);
                  filteredUsers.add(prevUserIds[i]);
                }
              }
              filteredEmojis.add(newReaction.reaction);
              filteredUsers.add(userIdStr);

              existing.reaction.reactions
                ..clear()
                ..addAll(filteredEmojis);
              existing.reaction.reactedUserIds
                ..clear()
                ..addAll(filteredUsers);

              ctrl.initialMessageList[idx] = Message(
                id: msgIdStr,
                message: existing.message,
                createdAt: existing.createdAt,
                sentBy: existing.sentBy,
                status: existing.status,
                replyMessage: existing.replyMessage,
                reaction: existing.reaction,
                messageType: existing.messageType,
              );
              if (!ctrl.messageStreamController.isClosed) {
                ctrl.messageStreamController.sink
                    .add(ctrl.initialMessageList);
              }
            }
          }

          emit(state.copyWith(
            messages: updatedMessages,
            lastSocketEvent: socketEvent,
          ));
        } else {
          emit(state.copyWith(lastSocketEvent: socketEvent));
        }

      case MessageReactionRemovedEvent():
        final matchesChat = socketEvent.chatId == 0 ||
            socketEvent.chatId == state.currentConversationId ||
            state.messages.any((m) => m.id == socketEvent.messageId) ||
            (state.chatController?.initialMessageList.any(
                  (m) =>
                      m.id == socketEvent.messageId.toString() ||
                      _tempToRealId[m.id] == socketEvent.messageId.toString(),
                ) ??
                false);

        if (matchesChat) {
          final updatedMessages = state.messages.map((m) {
            if (m.id != socketEvent.messageId) return m;
            return MessageEntity(
              id: m.id,
              chatId: m.chatId,
              content: m.content,
              sentAt: m.sentAt,
              editedAt: m.editedAt,
              sender: m.sender,
              receiptUserIds: m.receiptUserIds,
              reactions: m.reactions
                  .where((r) => r.userId != socketEvent.userId)
                  .toList(),
            );
          }).toList();

          final ctrl = state.chatController;
          if (ctrl != null) {
            final msgIdStr = socketEvent.messageId.toString();
            final idx = ctrl.initialMessageList.indexWhere(
              (m) => m.id == msgIdStr || _tempToRealId[m.id] == msgIdStr,
            );
            if (idx != -1) {
              final existing = ctrl.initialMessageList[idx];
              final userIdStr = socketEvent.userId.toString();
              final userIdx =
                  existing.reaction.reactedUserIds.indexOf(userIdStr);
              if (userIdx != -1) {
                existing.reaction.reactions.removeAt(userIdx);
                existing.reaction.reactedUserIds.removeAt(userIdx);
              }
              ctrl.initialMessageList[idx] = Message(
                id: msgIdStr,
                message: existing.message,
                createdAt: existing.createdAt,
                sentBy: existing.sentBy,
                status: existing.status,
                replyMessage: existing.replyMessage,
                reaction: existing.reaction,
                messageType: existing.messageType,
              );
              if (!ctrl.messageStreamController.isClosed) {
                ctrl.messageStreamController.sink
                    .add(ctrl.initialMessageList);
              }
            }
          }

          emit(state.copyWith(
            messages: updatedMessages,
            lastSocketEvent: socketEvent,
          ));
        } else {
          emit(state.copyWith(lastSocketEvent: socketEvent));
        }
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
    _tempToRealId.clear();
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
      for (final r in m.reactions) {
        final rid = r.userId.toString();
        if (rid != currentUserId) {
          final knownSender = participants.cast<SenderEntity?>().firstWhere(
                (p) => p?.id == r.userId,
                orElse: () => null,
              ) ??
              messages.map((msg) => msg.sender).cast<SenderEntity?>().firstWhere(
                (sender) => sender?.id == r.userId,
                orElse: () => null,
              );
          map.putIfAbsent(
            rid,
            () => ChatUser(
              id: rid,
              name: knownSender != null && knownSender.name.isNotEmpty
                  ? knownSender.name
                  : (map.values.firstOrNull?.name ?? fallbackName),
              profilePhoto: knownSender?.userAvatar ??
                  (map.values.firstOrNull?.profilePhoto ?? fallbackAvatar),
            ),
          );
        }
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
    _tempToRealId.clear();

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

        final readOutboxMaxId = event.readOutboxMaxId ?? 0;

        // Apply initial read status based on readOutboxMaxId from ChatEntity
        final chatViewMessages = response.messages
            .map((e) {
              final msg = e.toChatViewMessage(currentUserIdStr);
              final msgId = int.tryParse(msg.id);
              if (msgId != null &&
                  msgId <= readOutboxMaxId &&
                  msg.sentBy == currentUserIdStr &&
                  msg.status != MessageStatus.read) {
                return Message(
                  id: msg.id,
                  message: msg.message,
                  createdAt: msg.createdAt,
                  sentBy: msg.sentBy,
                  status: MessageStatus.read,
                  replyMessage: msg.replyMessage,
                  reaction: msg.reaction,
                  messageType: msg.messageType,
                );
              }
              return msg;
            })
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
            readOutboxMaxId: readOutboxMaxId > 0 ? readOutboxMaxId : null,
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
            for (final r in entity.reactions) {
              final rid = r.userId.toString();
              if (rid != currentUserId &&
                  !ctrl.otherUsers.any((u) => u.id == rid)) {
                ctrl.updateOtherUser(
                  ChatUser(
                    id: rid,
                    name: 'User',
                    profilePhoto: null,
                  ),
                );
              }
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
        final realIdStr = sentMessage.id.toString();
        _tempToRealId[event.tempId] = realIdStr;

        final ctrl = state.chatController;
        if (ctrl != null) {
          final idx = ctrl.initialMessageList
              .indexWhere((m) => m.id == event.tempId);
          if (idx != -1) {
            final existing = ctrl.initialMessageList[idx];
            ctrl.initialMessageList[idx] = Message(
              id: realIdStr,
              message: existing.message,
              createdAt: existing.createdAt,
              sentBy: existing.sentBy,
              status: MessageStatus.delivered,
              replyMessage: existing.replyMessage,
              reaction: existing.reaction,
              messageType: existing.messageType,
            );
            if (!ctrl.messageStreamController.isClosed) {
              ctrl.messageStreamController.sink.add(ctrl.initialMessageList);
            }
          }
        }

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

  // ─── Delete message ───────────────────────────────────────────────────────

  Future<void> _onDeleteMessage(
    DeleteChatMessage event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isDeleting: true, clearDeleteError: true));

    // Optimistically remove from domain state list (uses real int ID)
    final updatedMessages =
        state.messages.where((m) => m.id != event.messageId).toList();

    // Remove from ChatController – we must remove BOTH:
    //  • the real-ID bubble (e.g. "82") added when the socket fired
    //  • the temp-ID bubble (e.g. "1719000000000") added when the user tapped Send
    // Both may coexist when the user unsends immediately after sending.
    final ctrl = state.chatController;
    if (ctrl != null) {
      final realIdStr = event.messageId.toString();
      // IDs to purge: the real string ID + the chatView ID (may be temp or same)
      final idsToRemove = {realIdStr, event.chatViewMessageId};

      bool removed = false;
      for (final id in idsToRemove) {
        ctrl.initialMessageList.removeWhere((m) {
          if (m.id == id) {
            removed = true;
            return true;
          }
          return false;
        });
      }

      if (removed && !ctrl.messageStreamController.isClosed) {
        ctrl.messageStreamController.sink.add(ctrl.initialMessageList);
      }
    }

    emit(state.copyWith(messages: updatedMessages));

    final result = await _chatRepo.deleteMessage(
      conversationId: event.conversationId,
      messageId: event.messageId,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isDeleting: false,
        deleteErrorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(isDeleting: false)),
    );
  }

  // ─── React to message ─────────────────────────────────────────────────────

  Future<void> _onReactToMessage(
    ReactToMessage event,
    Emitter<ChatState> emit,
  ) async {
    // Optimistically update the ChatController so the emoji appears immediately
    final ctrl = state.chatController;
    final currentUserId = ctrl?.currentUser.id;
    if (ctrl != null && currentUserId != null) {
      final msgIdStr = event.messageId.toString();
      final idx = ctrl.initialMessageList.indexWhere(
        (m) => m.id == msgIdStr || _tempToRealId[m.id] == msgIdStr,
      );
      if (idx != -1) {
        final existing = ctrl.initialMessageList[idx];
        final prevReactions = existing.reaction.reactions;
        final prevUserIds = existing.reaction.reactedUserIds;

        // Replace previous reaction by same user, then add new one
        final filteredEmojis = <String>[];
        final filteredUsers = <String>[];
        for (var i = 0; i < prevUserIds.length; i++) {
          if (prevUserIds[i] != currentUserId) {
            filteredEmojis.add(prevReactions[i]);
            filteredUsers.add(prevUserIds[i]);
          }
        }
        filteredEmojis.add(event.emoji);
        filteredUsers.add(currentUserId);

        existing.reaction.reactions
          ..clear()
          ..addAll(filteredEmojis);
        existing.reaction.reactedUserIds
          ..clear()
          ..addAll(filteredUsers);

        ctrl.initialMessageList[idx] = Message(
          id: msgIdStr,
          message: existing.message,
          createdAt: existing.createdAt,
          sentBy: existing.sentBy,
          status: existing.status,
          replyMessage: existing.replyMessage,
          reaction: existing.reaction,
          messageType: existing.messageType,
        );
        if (!ctrl.messageStreamController.isClosed) {
          ctrl.messageStreamController.sink.add(ctrl.initialMessageList);
        }
      }
    }

    final currentUserIdNum = int.tryParse(currentUserId ?? '');
    if (currentUserIdNum != null) {
      final updatedMessages = state.messages.map((m) {
        if (m.id != event.messageId) return m;
        final existingReactions =
            m.reactions.where((r) => r.userId != currentUserIdNum).toList();
        return MessageEntity(
          id: m.id,
          chatId: m.chatId,
          content: m.content,
          sentAt: m.sentAt,
          editedAt: m.editedAt,
          sender: m.sender,
          receiptUserIds: m.receiptUserIds,
          reactions: [
            ...existingReactions,
            ReactionEntity(
              userId: currentUserIdNum,
              reaction: event.emoji,
              createdAt: DateTime.now(),
            ),
          ],
        );
      }).toList();
      emit(state.copyWith(messages: updatedMessages));
    }

    // Call the API — the server will broadcast message.reaction.added via
    // WebSocket which will confirm/correct the optimistic update.
    final result = await _chatRepo.reactMessage(
      conversationId: event.conversationId,
      messageId: event.messageId,
      reaction: event.emoji,
    );

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {}, // socket event will update state
    );
  }

  // ─── Remove reaction ──────────────────────────────────────────────────────

  Future<void> _onRemoveReaction(
    RemoveReaction event,
    Emitter<ChatState> emit,
  ) async {
    // Optimistically update the ChatController
    final ctrl = state.chatController;
    final currentUserId = ctrl?.currentUser.id;
    if (ctrl != null && currentUserId != null) {
      final msgIdStr = event.messageId.toString();
      final idx = ctrl.initialMessageList.indexWhere(
        (m) => m.id == msgIdStr || _tempToRealId[m.id] == msgIdStr,
      );
      if (idx != -1) {
        final existing = ctrl.initialMessageList[idx];
        final prevReactions = existing.reaction.reactions;
        final prevUserIds = existing.reaction.reactedUserIds;

        final filteredEmojis = <String>[];
        final filteredUsers = <String>[];
        for (var i = 0; i < prevUserIds.length; i++) {
          if (prevUserIds[i] != currentUserId) {
            filteredEmojis.add(prevReactions[i]);
            filteredUsers.add(prevUserIds[i]);
          }
        }

        existing.reaction.reactions
          ..clear()
          ..addAll(filteredEmojis);
        existing.reaction.reactedUserIds
          ..clear()
          ..addAll(filteredUsers);

        ctrl.initialMessageList[idx] = Message(
          id: msgIdStr,
          message: existing.message,
          createdAt: existing.createdAt,
          sentBy: existing.sentBy,
          status: existing.status,
          replyMessage: existing.replyMessage,
          reaction: existing.reaction,
          messageType: existing.messageType,
        );
        if (!ctrl.messageStreamController.isClosed) {
          ctrl.messageStreamController.sink.add(ctrl.initialMessageList);
        }
      }
    }

    final currentUserIdNum = int.tryParse(currentUserId ?? '');
    if (currentUserIdNum != null) {
      final updatedMessages = state.messages.map((m) {
        if (m.id != event.messageId) return m;
        return MessageEntity(
          id: m.id,
          chatId: m.chatId,
          content: m.content,
          sentAt: m.sentAt,
          editedAt: m.editedAt,
          sender: m.sender,
          receiptUserIds: m.receiptUserIds,
          reactions:
              m.reactions.where((r) => r.userId != currentUserIdNum).toList(),
        );
      }).toList();
      emit(state.copyWith(messages: updatedMessages));
    }

    final result = await _chatRepo.removeReaction(
      conversationId: event.conversationId,
      messageId: event.messageId,
    );

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {},
    );
  }


  // --- Mark messages seen ---------------------------------------------------

  Future<void> _onMarkMessagesSeen(
    MarkMessagesSeen event,
    Emitter<ChatState> emit,
  ) async {
    // Skip if we've already reported this message (or a later one) as seen
    final prevMax = state.readOutboxMaxId ?? 0;
    if (event.messageId <= prevMax) return;

    // Optimistically update local state and ChatController
    final ctrl = state.chatController;
    if (ctrl != null) {
      bool changed = false;
      for (var i = 0; i < ctrl.initialMessageList.length; i++) {
        final msg = ctrl.initialMessageList[i];
        final msgId = int.tryParse(msg.id);
        if (msgId != null &&
            msgId <= event.messageId &&
            msg.sentBy == ctrl.currentUser.id &&
            msg.status != MessageStatus.read) {
          ctrl.initialMessageList[i] = Message(
            id: msg.id,
            message: msg.message,
            createdAt: msg.createdAt,
            sentBy: msg.sentBy,
            status: MessageStatus.read,
            replyMessage: msg.replyMessage,
            reaction: msg.reaction,
            messageType: msg.messageType,
          );
          changed = true;
        }
      }
      if (changed && !ctrl.messageStreamController.isClosed) {
        ctrl.messageStreamController.sink.add(ctrl.initialMessageList);
      }
    }

    emit(state.copyWith(readOutboxMaxId: event.messageId));

    // Fire-and-forget the API call; errors are silently swallowed so
    // the UI doesn't regress on a transient network hiccup.
    await _markMessagesSeen(
      conversationId: event.conversationId,
      lastSeenMessageId: event.messageId,
    );
  }
}

