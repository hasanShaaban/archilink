import 'dart:async';

import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/utils/message_mapper.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/Chat/domain/entity/chat_args.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/message_entity.dart';
import 'package:archilink/features/Chat/presentation/manager/bloc/chat_bloc.dart';

import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppChatView extends StatelessWidget {
  const AppChatView({super.key, required this.args});
  static const String name = '/chat';
  final ChatArgs args;

  @override
  Widget build(BuildContext context) {
    final currentUserId =
        context.read<CurrentUserCubit>().state.id ?? 0;

    return Scaffold(
      body: SafeArea(
        child: BlocProvider.value(
          value: sl<ChatBloc>()
            ..add(
              FetchInitialMessages(
                conversationId: args.conversationId,
                currentUserId: currentUserId,
                chatTitle: args.chatTitle,
                profileImage: args.profileImage,
                readOutboxMaxId: args.readOutboxMaxId,
              ),
            ),
          child: _ChatViewBody(args: args),
        ),
      ),
    );
  }
}

// ─── Private enum for the popup menu ────────────────────────────────────────
class _ChatViewBody extends StatefulWidget {
  final ChatArgs args;
  const _ChatViewBody({required this.args});

  @override
  State<_ChatViewBody> createState() => _ChatViewBodyState();
}

enum _ChatAction { viewMembers, muteNotifications, exportChat, starMessage }

/// Thin UI widget — all state lives in [ChatBloc].
/// This widget only:
///  • dispatches events (send, load-more, retry)
///  • updates temp-message status on delivery / failure
///  • renders based on [ChatState.chatController]
class _ChatViewBodyState extends State<_ChatViewBody> {
  String? _lastHandledSentTempId;
  String? _lastHandledFailedTempId;
  final Map<String, String> _tempIdToRealId = {};

  // ─── Delete (unsend) tap ─────────────────────────────────────────────────
  void _onUnsendTap(Message message) {
    final chatBloc = context.read<ChatBloc>();
    final conversationId = chatBloc.state.currentConversationId;
    if (conversationId == null) return;

    // message.id is the ID as it lives in the ChatController.
    // It may be a temp timestamp string (e.g. "1719000000000") or the real
    // backend ID string (e.g. "82").
    final chatViewMessageId = message.id;

    // Look up the real backend ID. If it was confirmed by the socket/API,
    // it will be in _tempIdToRealId.  Otherwise message.id IS the real ID.
    final resolvedIdStr = _tempIdToRealId[chatViewMessageId] ?? chatViewMessageId;
    final messageId = int.tryParse(resolvedIdStr);

    // Guard: if we can't resolve a numeric ID it's still pending — the
    // server hasn't acknowledged it yet, so there's nothing to delete.
    if (messageId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait for the message to be delivered before deleting.'),
        ),
      );
      return;
    }

    // Extra safety: a temp timestamp number (13 digits) is never a real ID.
    // If _tempIdToRealId has no mapping yet but message.id looks like a
    // millisecond timestamp, the real ID hasn't been received yet.
    if (_tempIdToRealId.containsKey(chatViewMessageId) == false &&
        resolvedIdStr.length >= 10 &&
        !chatBloc.state.messages.any((m) => m.id == messageId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait for the message to be delivered before deleting.'),
        ),
      );
      return;
    }

    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        context.read<ChatBloc>().add(
              DeleteChatMessage(
                conversationId: conversationId,
                messageId: messageId,
                chatViewMessageId: chatViewMessageId,
              ),
            );
      }
    });
  }

  // ─── Send tap ────────────────────────────────────────────────────────────
  void _onSendTap(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) {
    final text = message.trim();
    if (text.isEmpty) return;

    final chatBloc = context.read<ChatBloc>();
    final ctrl = chatBloc.state.chatController;
    if (ctrl == null) return;

    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final currentUserId = ctrl.currentUser.id;

    ctrl.addMessage(
      Message(
        id: tempId,
        message: text,
        createdAt: DateTime.now(),
        sentBy: currentUserId,
        replyMessage: replyMessage,
        messageType: messageType,
        status: MessageStatus.pending,
      ),
    );

    chatBloc.add(
      SendChatMessage(
        conversationId: widget.args.conversationId,
        content: text,
        tempId: tempId,
      ),
    );
  }

  // ─── Pagination ──────────────────────────────────────────────────────────
  Future<void> _loadMoreData(dynamic direction, Message message) async {
    if (direction.isNext == true) return;
    if (direction.isPrevious != true) return;

    final chatBloc = context.read<ChatBloc>();
    if (chatBloc.state.hasReachedMax || chatBloc.state.isLoading) return;

    final completer = Completer<List<MessageEntity>?>();
    chatBloc.add(FetchMoreMessages(widget.args.conversationId, completer));

    final olderEntities = await completer.future;
    final ctrl = chatBloc.state.chatController;
    if (olderEntities != null && olderEntities.isNotEmpty && ctrl != null) {
      final currentUserId = ctrl.currentUser.id;
      final existingIds = ctrl.initialMessageList.map((m) => m.id).toSet();
      // Snapshot readOutboxMaxId at the time the page resolved so that older
      // outgoing messages already read by the other user show blue ticks.
      final readOutboxMaxId = chatBloc.state.readOutboxMaxId ?? 0;

      // Older messages come in newest-first from the API; reverse so they
      // are in oldest-first order, matching the ascending timeline at the top.
      final uniqueOlder = olderEntities
          .map((e) {
            final msg = e.toChatViewMessage(currentUserId);
            // Apply read status: if this outgoing message's id ≤ readOutboxMaxId
            // the other user has already read it — show blue ticks.
            final msgId = int.tryParse(msg.id);
            if (msgId != null &&
                readOutboxMaxId > 0 &&
                msgId <= readOutboxMaxId &&
                msg.sentBy == currentUserId &&
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
          .where((m) => !existingIds.contains(m.id))
          .toList();

      if (uniqueOlder.isNotEmpty) {
        // ⚠️  We do NOT call ctrl.loadMoreData() here.
        // chatview's loadMoreData() internally tries to restore scroll
        // position by computing an item index after insertion. That
        // calculation produces an out-of-bounds index when the total list
        // size doesn't match its assumptions, crashing with:
        //   RangeError (length): Not in inclusive range 0..N: N+k
        //
        // Instead, prepend directly and notify via the stream — chatview
        // will re-render the list correctly without any scroll arithmetic.
        ctrl.initialMessageList.insertAll(0, uniqueOlder);
        if (!ctrl.messageStreamController.isClosed) {
          ctrl.messageStreamController.sink.add(ctrl.initialMessageList);
        }
      }
    }
  }

  // ─── Menu ────────────────────────────────────────────────────────────────
  void _onMenuAction(_ChatAction action) {
    switch (action) {
      case _ChatAction.viewMembers:
        break;
      case _ChatAction.muteNotifications:
        break;
      case _ChatAction.exportChat:
        break;
      case _ChatAction.starMessage:
        break;
    }
  }

  FetchInitialMessages _fetchInitialEvent() {
    final currentUserId = context.read<CurrentUserCubit>().state.id ?? 0;
    return FetchInitialMessages(
      conversationId: widget.args.conversationId,
      currentUserId: currentUserId,
      chatTitle: widget.args.chatTitle,
      profileImage: widget.args.profileImage,
      readOutboxMaxId: widget.args.readOutboxMaxId,
    );
  }

  // ─── Build ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final currentUserId = context.read<CurrentUserCubit>().state.id ?? 0;

    return BlocConsumer<ChatBloc, ChatState>(
      // Rebuild when the controller reference changes (new chat) or status changes
      buildWhen: (prev, curr) =>
          prev.chatController != curr.chatController ||
          prev.status != curr.status ||
          prev.errorMessage != curr.errorMessage,
      listenWhen: (prev, curr) =>
          prev.lastSentTempId != curr.lastSentTempId ||
          prev.failedTempId != curr.failedTempId ||
          prev.deleteErrorMessage != curr.deleteErrorMessage,
      listener: (context, state) {
        final ctrl = state.chatController;
        if (ctrl == null) return;

        // ─ Delivery confirmation: find temp-id bubble and mark delivered
        if (state.lastSentTempId != null &&
            state.lastSentTempId != _lastHandledSentTempId) {
          _lastHandledSentTempId = state.lastSentTempId;

          if (state.lastSentMessage != null) {
            _tempIdToRealId[state.lastSentTempId!] =
                state.lastSentMessage!.id.toString();
          }

          final realIdStr = state.lastSentMessage?.id.toString();
          final idx = ctrl.initialMessageList
              .indexWhere((m) => m.id == state.lastSentTempId);
          if (idx != -1) {
            final existing = ctrl.initialMessageList[idx];
            ctrl.initialMessageList[idx] = Message(
              id: realIdStr ?? existing.id,
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

        // ─ Send failure: mark as undelivered
        if (state.failedTempId != null &&
            state.failedTempId != _lastHandledFailedTempId) {
          _lastHandledFailedTempId = state.failedTempId;
          final idx = ctrl.initialMessageList
              .indexWhere((m) => m.id == state.failedTempId);
          if (idx != -1) {
            ctrl.initialMessageList[idx].setStatus = MessageStatus.undelivered;
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        }
        // ─ Delete failure: show error snackbar
        if (state.deleteErrorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.deleteErrorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        // ─ Loading
        if (state.chatController == null &&
            state.status == ChatStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        // ─ Error with retry
        if (state.chatController == null &&
            state.status == ChatStatus.error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage ?? 'Something went wrong',
                    style: AppTextStyle.interMedium14
                        .copyWith(color: colorScheme.onSurface),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<ChatBloc>()
                        .add(_fetchInitialEvent()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // ─ Fallback spinner
        if (state.chatController == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final ctrl = state.chatController!;
        final hasProfilePic = widget.args.profileImage != null &&
            widget.args.profileImage!.isNotEmpty;

        return ChatView(
          onSendTap: _onSendTap,
          isLastPage: () => context.read<ChatBloc>().state.hasReachedMax,
          loadMoreData: _loadMoreData,
          chatViewStateConfig: ChatViewStateConfiguration(
            onReloadButtonTap: () =>
                context.read<ChatBloc>().add(_fetchInitialEvent()),
            loadingWidgetConfig: const ChatViewStateWidgetConfiguration(
              title: 'Loading messages...',
            ),
            errorWidgetConfig: ChatViewStateWidgetConfiguration(
              title: state.errorMessage ?? 'Something went wrong',
              subTitle: 'Tap reload to try again',
            ),
            noMessageWidgetConfig: const ChatViewStateWidgetConfiguration(
              title: 'No messages yet',
              subTitle: 'Say hello 👋',
            ),
          ),

          chatController: ctrl,
          chatViewState: ctrl.initialMessageList.isNotEmpty
              ? ChatViewState.hasMessages
              : ChatViewState.noData,

          // ─── Features ───────────────────────────────────────────────────
          featureActiveConfig: const FeatureActiveConfig(
            enableOtherUserName: false,
            enablePagination: true,
            enableSwipeToReply: false,
            enableReactionPopup: true,
            enableScrollToBottomButton: true,
            enableDoubleTapToLike: true,
            enableReplySnackBar: true,
            enableChatSeparator: true,
            receiptsBuilderVisibility: true,
          ),

          // ─── AppBar ─────────────────────────────────────────────────────
          appBar: ChatViewAppBar(
            imageType: hasProfilePic ? ImageType.network : ImageType.asset,
            backGroundColor: scaffoldBg,
            profilePicture: hasProfilePic
                ? widget.args.profileImage!
                : Assets.assetsImagesBackgroundDark,
            chatTitle: widget.args.chatTitle.isNotEmpty
                ? widget.args.chatTitle
                : 'Chat',
            chatTitleTextStyle: AppTextStyle.interSemiBold16
                .copyWith(color: colorScheme.onSurface),
            userStatus: 'Online',
            userStatusTextStyle: AppTextStyle.interRegular10
                .copyWith(color: Colors.green),
            actions: [
              PopupMenuButton<_ChatAction>(
                icon: Icon(Icons.menu, color: colorScheme.onSurface),
                color: scaffoldBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: colorScheme.outlineVariant),
                ),
                onSelected: _onMenuAction,
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: _ChatAction.viewMembers,
                    child: Text('View Members'),
                  ),
                  PopupMenuItem(
                    value: _ChatAction.muteNotifications,
                    child: Text('Mute Notifications'),
                  ),
                  PopupMenuItem(
                    value: _ChatAction.exportChat,
                    child: Text('Export Chat'),
                  ),
                  PopupMenuItem(
                    value: _ChatAction.starMessage,
                    child: Text('Star Message'),
                  ),
                ],
              ),
            ],
          ),

          // ─── Background ─────────────────────────────────────────────────
          chatBackgroundConfig: ChatBackgroundConfiguration(
            backgroundColor: scaffoldBg,
          ),

          // ─── Profile circle ─────────────────────────────────────────────
          profileCircleConfig: const ProfileCircleConfiguration(
            profileImageUrl: '',
            circleRadius: 16,
          ),

          // ─── Bubbles ────────────────────────────────────────────────────
          chatBubbleConfig: ChatBubbleConfiguration(
            inComingChatBubbleConfig: ChatBubble(
              textStyle: AppTextStyle.interRegular16
                  .copyWith(color: colorScheme.onSurface),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColorsFromTheme.grayForTheme(context),
              borderRadius: BorderRadius.circular(16),
              onMessageRead: (message) {
                // Fired by chatview when an incoming bubble scrolls into view.
                // Parse the backend integer ID and dispatch seen receipt.
                final msgId = int.tryParse(message.id);
                if (msgId == null) return;
                context.read<ChatBloc>().add(
                      MarkMessagesSeen(
                        conversationId: widget.args.conversationId,
                        messageId: msgId,
                      ),
                    );
              },
            ),
            outgoingChatBubbleConfig: ChatBubble(
              receiptsWidgetConfig: ReceiptsWidgetConfig(
                showReceiptsIn: ShowReceiptsIn.all,
                receiptsBuilder: (status) {
                  return switch (status) {
                    MessageStatus.pending => const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.access_time_rounded,
                          size: 14, color: AppColors.gray),
                    ),
                    MessageStatus.delivered => const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child:
                          Icon(Icons.done_all, size: 16, color: AppColors.gray),
                    ),
                    MessageStatus.read => const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.done_all, size: 16, color: Colors.blue),
                    ),
                    MessageStatus.undelivered => const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.error_outline,
                          size: 16, color: Colors.red),
                    ),
                  };
                },
              ),
              border: Border.all(
                color: AppColorsFromTheme.grayForTheme(context),
                width: 1.5,
              ),
              textStyle: AppTextStyle.interRegular16
                  .copyWith(color: colorScheme.onSurface),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: scaffoldBg,
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          // ─── Reply popup (long-press on message) ─────────────────────────
          replyPopupConfig: ReplyPopupConfiguration(
            backgroundColor: scaffoldBg,
            buttonTextStyle: AppTextStyle.interMedium14
                .copyWith(color: colorScheme.onSurface),
            topBorderColor: colorScheme.outlineVariant,
            onUnsendTap: _onUnsendTap,
          ),

          // ─── Reaction popup ──────────────────────────────────────────────
          reactionPopupConfig: ReactionPopupConfiguration(
            showGlassMorphismEffect: true,
            backgroundColor: colorScheme.surface,
            shadow: BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            userReactionCallback: (message, emoji) {
              final chatBloc = context.read<ChatBloc>();
              final conversationId = chatBloc.state.currentConversationId;
              if (conversationId == null) return;

              // Resolve real int ID (temp IDs use _tempIdToRealId map)
              final resolvedIdStr =
                  _tempIdToRealId[message.id] ?? message.id;
              final messageId = int.tryParse(resolvedIdStr);
              if (messageId == null) return;

              // ⚠️ Do NOT use `message.reaction` from the chatview callback.
              // chatview applies its own optimistic UI update BEFORE calling
              // this callback, so the emoji is already in reactedUserIds by
              // the time we get here — making alreadyReactedWithEmoji always
              // true and firing DELETE instead of POST.
              //
              // Instead check the server-confirmed domain state, which only
              // updates after the socket event / API response confirms it.
              final domainMsg = chatBloc.state.messages
                  .cast<MessageEntity?>()
                  .firstWhere(
                    (m) => m?.id == messageId,
                    orElse: () => null,
                  );

              final alreadyReactedWithEmoji = domainMsg != null &&
                  domainMsg.reactions.any(
                    (r) => r.userId == currentUserId && r.reaction == emoji,
                  );

              if (alreadyReactedWithEmoji) {
                chatBloc.add(
                  RemoveReaction(
                    conversationId: conversationId,
                    messageId: messageId,
                  ),
                );
              } else {
                chatBloc.add(
                  ReactToMessage(
                    conversationId: conversationId,
                    messageId: messageId,
                    emoji: emoji,
                  ),
                );
              }
            },
          ),

          // ─── Message reaction & bottom sheet configuration ───────────────
          messageConfig: MessageConfiguration(
            messageReactionConfig: MessageReactionConfiguration(
              backgroundColor: AppColorsFromTheme.grayForTheme(context),
              borderColor: scaffoldBg,
              borderWidth: 1.5,
              borderRadius: BorderRadius.circular(16),
              reactionSize: 14,
              reactionCountTextStyle: AppTextStyle.interMedium12
                  .copyWith(color: colorScheme.onSurface),
              reactionsBottomSheetConfig: ReactionsBottomSheetConfiguration(
                backgroundColor: scaffoldBg,
                reactedUserTextStyle: AppTextStyle.interMedium14
                    .copyWith(color: colorScheme.onSurface),
                reactionSize: 22,
                profileCircleRadius: 18,
                bottomSheetPadding: const EdgeInsets.only(
                  right: 16,
                  left: 16,
                  top: 20,
                  bottom: 20,
                ),
                reactionWidgetPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                reactionWidgetMargin: const EdgeInsets.only(bottom: 10),
                reactionWidgetDecoration: BoxDecoration(
                  color: AppColorsFromTheme.grayForTheme(context),
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
                reactedUserCallback: (reactedUser, reactionEmoji) {
                  if (reactedUser.id == currentUserId.toString()) {
                    Navigator.of(context).pop();
                    Message? targetMsg;
                    for (final m in ctrl.initialMessageList) {
                      final uIdx =
                          m.reaction.reactedUserIds.indexOf(reactedUser.id);
                      if (uIdx != -1 &&
                          m.reaction.reactions[uIdx] == reactionEmoji) {
                        targetMsg = m;
                        break;
                      }
                    }
                    if (targetMsg != null) {
                      final resolvedIdStr =
                          _tempIdToRealId[targetMsg.id] ?? targetMsg.id;
                      final messageId = int.tryParse(resolvedIdStr);
                      if (messageId != null) {
                        context.read<ChatBloc>().add(
                              RemoveReaction(
                                conversationId: widget.args.conversationId,
                                messageId: messageId,
                              ),
                            );
                      }
                    }
                  }
                },
              ),
            ),
          ),

          // ─── Input bar ───────────────────────────────────────────────────
          sendMessageConfig: SendMessageConfiguration(
            allowRecordingVoice: false,
            shouldSendImageWithText: false,
            textFieldBackgroundColor:
                AppColorsFromTheme.grayForTheme(context),
            textFieldConfig: TextFieldConfiguration(
              margin: const EdgeInsetsDirectional.all(15),
              hintText: 'Message',
              hintStyle: AppTextStyle.interRegular16.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              textStyle: AppTextStyle.interRegular16
                  .copyWith(color: colorScheme.onSurface),
              borderRadius: BorderRadius.circular(16),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              leadingActions: (context, controller) => const [],
              trailingActions: (context, controller) => const [],
            ),
            sendButtonIcon:
                Icon(Icons.send_outlined, color: colorScheme.primary),
            replyMessageColor: colorScheme.onSurface,
            replyDialogColor: AppColorsFromTheme.grayForTheme(context),
            replyTitleColor: colorScheme.primary,
            closeIconColor: colorScheme.onSurface,
          ),
        );
      },
    );
  }

}
