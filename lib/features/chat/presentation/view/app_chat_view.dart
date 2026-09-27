import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/utils/message_mapper.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/Chat/domain/entity/chat_args.dart';
import 'package:archilink/features/Chat/domain/entity/chat_entity.dart/sender_entity.dart';
import 'package:archilink/features/Chat/domain/repo/chat_websocket_repo.dart';
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
    return Scaffold(
      body: SafeArea(
        child: BlocProvider.value(
          value: sl<ChatBloc>()..add(FetchInitialMessages(args.conversationId)),
          child: _ChatViewBody(args: args),
        ),
      ),
    );
  }
}

// ─── Private enum for the popup menu ────────────────────────────────────────
enum _ChatAction { viewMembers, muteNotifications, exportChat, starMessage }

// ─── Stateful body ──────────────────────────────────────────────────────────
class _ChatViewBody extends StatefulWidget {
  final ChatArgs args;
  const _ChatViewBody({required this.args});

  @override
  State<_ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<_ChatViewBody> {
  ChatController? _chatController;
  bool _controllerInitialized = false;
  String? _lastHandledSentTempId;
  String? _lastHandledFailedTempId;

  @override
  void initState() {
    super.initState();
    final chatBloc = context.read<ChatBloc>();
    if (chatBloc.state.status == ChatStatus.ready) {
      _initController(chatBloc.state);
    }
  }

  @override
  void dispose() {
    _chatController?.dispose();
    super.dispose();
  }

  // Called when initial messages arrive or state is ready
  void _initController(ChatState state) {
    if (_controllerInitialized) return;

    final currentUserState = context.read<CurrentUserCubit>().state;
    final currentUserIdStr = currentUserState.id?.toString() ?? '0';

    SenderEntity? currentSender;
    try {
      currentSender = state.participants.firstWhere(
        (p) =>
            (currentUserState.id != null && p.id == currentUserState.id) ||
            (currentUserState.username != null &&
                p.username.toLowerCase() ==
                    currentUserState.username?.toLowerCase()),
      );
    } catch (_) {
      currentSender = null;
    }

    final currentUser = ChatUser(
      id: currentSender?.id.toString() ?? currentUserIdStr,
      name: currentSender?.name ?? currentUserState.username ?? 'Me',
      profilePhoto: currentSender?.userAvatar,
    );

    final otherSenders = state.participants
        .where((p) => p.id.toString() != currentUser.id)
        .toList();

    final otherUsers = otherSenders
        .map(
          (s) => ChatUser(
            id: s.id.toString(),
            name: s.name,
            profilePhoto: s.userAvatar,
          ),
        )
        .toList();

    if (otherUsers.isEmpty) {
      otherUsers.add(
        ChatUser(
          id: 'chat_${widget.args.conversationId}',
          name: widget.args.chatTitle.isNotEmpty
              ? widget.args.chatTitle
              : 'Chat',
          profilePhoto: widget.args.profileImage,
        ),
      );
    }

    final chatViewMessages = state.messages
        .map((e) => e.toChatViewMessage(currentUser.id))
        .toList()
        .reversed
        .toList();

    _chatController = ChatController(
      initialMessageList: chatViewMessages,
      scrollController: ScrollController(),
      currentUser: currentUser,
      otherUsers: otherUsers,
    );

    _controllerInitialized = true;
  }

  void _onSendTap(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) {
    final text = message.trim();
    if (text.isEmpty) return;

    final currentUserId =
        _chatController?.currentUser.id ??
        context.read<CurrentUserCubit>().state.id?.toString() ??
        '0';
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();

    final messageObj = Message(
      id: tempId,
      message: text,
      createdAt: DateTime.now(),
      sentBy: currentUserId,
      replyMessage: replyMessage,
      messageType: messageType,
      status: MessageStatus.pending,
    );

    _chatController?.addMessage(messageObj);

    context.read<ChatBloc>().add(
      SendChatMessage(
        conversationId: widget.args.conversationId,
        content: text,
        tempId: tempId,
      ),
    );
  }

  // ─── Menu action handler ──────────────────────────────────────────────────
  void _onMenuAction(_ChatAction action) {
    switch (action) {
      case _ChatAction.viewMembers:
        // TODO: navigate to members screen
        break;
      case _ChatAction.muteNotifications:
        // TODO: toggle mute
        break;
      case _ChatAction.exportChat:
        // TODO: export chat
        break;
      case _ChatAction.starMessage:
        // TODO: star message logic
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return BlocConsumer<ChatBloc, ChatState>(
      listenWhen: (prev, curr) =>
          prev.messages != curr.messages ||
          prev.status != curr.status ||
          prev.lastSocketEvent != curr.lastSocketEvent ||
          prev.lastSentTempId != curr.lastSentTempId ||
          prev.failedTempId != curr.failedTempId,
      listener: (BuildContext context, ChatState state) {
        if (!_controllerInitialized &&
            (state.status == ChatStatus.ready || state.messages.isNotEmpty)) {
          _initController(state);
        } else if (_controllerInitialized) {
          // Handle send message success -> update to delivered (two gray ticks)
          if (state.lastSentTempId != null &&
              state.lastSentTempId != _lastHandledSentTempId) {
            _lastHandledSentTempId = state.lastSentTempId;
            final index = _chatController!.initialMessageList.indexWhere(
              (m) => m.id == state.lastSentTempId,
            );
            if (index != -1) {
              final msg = _chatController!.initialMessageList[index];
              msg.setStatus = MessageStatus.delivered;
            }
          }

          // Handle send message failure
          if (state.failedTempId != null &&
              state.failedTempId != _lastHandledFailedTempId) {
            _lastHandledFailedTempId = state.failedTempId;
            final index = _chatController!.initialMessageList.indexWhere(
              (m) => m.id == state.failedTempId,
            );
            if (index != -1) {
              final msg = _chatController!.initialMessageList[index];
              msg.setStatus = MessageStatus.undelivered;
            }
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          }

          // Handle real-time incoming messages
          if (state.lastSocketEvent is MessageSentEvent) {
            final event = state.lastSocketEvent as MessageSentEvent;
            final currentUserId = _chatController!.currentUser.id;
            final isFromMe =
                event.message.sender.id.toString() == currentUserId;
            final alreadyPresent = _chatController!.initialMessageList.any(
              (m) => m.id == event.message.id.toString(),
            );
            if (!alreadyPresent) {
              if (isFromMe) {
                final pendingIndex = _chatController!.initialMessageList
                    .indexWhere(
                      (m) =>
                          m.sentBy == currentUserId &&
                          m.message == event.message.content &&
                          m.status == MessageStatus.pending,
                    );
                if (pendingIndex != -1) {
                  _chatController!.initialMessageList[pendingIndex].setStatus =
                      MessageStatus.delivered;
                  return;
                }
              }
              _chatController!.addMessage(
                event.message.toChatViewMessage(currentUserId),
              );
            }
          }
        }

        // Trigger rebuild so ChatView gets the controller
        setState(() {});
      },
      builder: (context, state) {
        if (state.status == ChatStatus.error && _chatController == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage ?? 'Something went wrong',
                    style: AppTextStyle.interMedium14.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ChatBloc>().add(
                        FetchInitialMessages(widget.args.conversationId),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (_chatController == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final hasProfilePic =
            widget.args.profileImage != null &&
            widget.args.profileImage!.isNotEmpty;

        return ChatView(
          onSendTap: _onSendTap,
          chatViewStateConfig: ChatViewStateConfiguration(
            onReloadButtonTap: () {
              context.read<ChatBloc>().add(
                FetchInitialMessages(widget.args.conversationId),
              );
            },
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

          chatController: _chatController!,
          chatViewState: state.messages.isEmpty
              ? ChatViewState.noData
              : ChatViewState.hasMessages,

          // ─── Features ──────────────────────────────────────────────────────────
          featureActiveConfig: const FeatureActiveConfig(
            enableOtherUserName: false,
            enablePagination: true,
            enableSwipeToReply: false,
            enableReactionPopup: true,
            enableScrollToBottomButton: true,
            enableDoubleTapToLike: true,
            enableReplySnackBar: false,
            enableChatSeparator: true,
            receiptsBuilderVisibility: true,
          ),

          // ─── AppBar ────────────────────────────────────────────────────────────
          appBar: ChatViewAppBar(
            imageType: hasProfilePic ? ImageType.network : ImageType.asset,
            backGroundColor: scaffoldBg,
            profilePicture: hasProfilePic
                ? widget.args.profileImage!
                : Assets.assetsImagesBackgroundDark,
            chatTitle: widget.args.chatTitle.isNotEmpty
                ? widget.args.chatTitle
                : 'Chat',
            chatTitleTextStyle: AppTextStyle.interSemiBold16.copyWith(
              color: colorScheme.onSurface,
            ),
            userStatus: 'Online',
            userStatusTextStyle: AppTextStyle.interRegular10.copyWith(
              color: Colors.green,
            ),
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

          // ─── Background ────────────────────────────────────────────────────────
          chatBackgroundConfig: ChatBackgroundConfiguration(
            backgroundColor: scaffoldBg,
          ),

          // ─── Profile circle ────────────────────────────────────────────────────
          profileCircleConfig: const ProfileCircleConfiguration(
            profileImageUrl: '',
            circleRadius: 16,
          ),

          // ─── Bubbles ───────────────────────────────────────────────────────────
          chatBubbleConfig: ChatBubbleConfiguration(
            inComingChatBubbleConfig: ChatBubble(
              textStyle: AppTextStyle.interRegular16.copyWith(
                color: colorScheme.onSurface,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColorsFromTheme.grayForTheme(context),
              borderRadius: BorderRadius.circular(16),
            ),
            outgoingChatBubbleConfig: ChatBubble(
              receiptsWidgetConfig: ReceiptsWidgetConfig(
                showReceiptsIn: ShowReceiptsIn.all,
                receiptsBuilder: (status) {
                  return switch (status) {
                    MessageStatus.pending => const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: AppColors.gray,
                      ),
                    ),
                    MessageStatus.delivered => const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.done_all,
                        size: 16,
                        color: AppColors.gray,
                      ),
                    ),
                    MessageStatus.read => const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.done_all, size: 16, color: Colors.blue),
                    ),
                    MessageStatus.undelivered => const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.error_outline,
                        size: 16,
                        color: Colors.red,
                      ),
                    ),
                  };
                },
              ),
              border: Border.all(
                color: AppColorsFromTheme.grayForTheme(context),
                width: 1.5,
              ),
              textStyle: AppTextStyle.interRegular16.copyWith(
                color: colorScheme.onSurface,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: scaffoldBg,
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          // ─── Reaction popup (long-press) ───────────────────────────────────────
          reactionPopupConfig: ReactionPopupConfiguration(
            showGlassMorphismEffect: true,
            backgroundColor: colorScheme.surface,
            shadow: BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            userReactionCallback: (message, emoji) {
              // chatview handles it internally via chatController
            },
          ),

          // ─── Reaction chip below bubbles ───────────────────────────────────────

          // ─── Input bar ─────────────────────────────────────────────────────────
          sendMessageConfig: SendMessageConfiguration(
            allowRecordingVoice: false,
            shouldSendImageWithText: false,
            textFieldBackgroundColor: AppColorsFromTheme.grayForTheme(context),
            textFieldConfig: TextFieldConfiguration(
              margin: const EdgeInsetsDirectional.all(15),
              hintText: 'Message',
              hintStyle: AppTextStyle.interRegular16.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              textStyle: AppTextStyle.interRegular16.copyWith(
                color: colorScheme.onSurface,
              ),
              borderRadius: BorderRadius.circular(16),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              leadingActions: (context, controller) => const [],
              trailingActions: (context, controller) => const [],
            ),
            sendButtonIcon: Icon(
              Icons.send_outlined,
              color: colorScheme.primary,
            ),
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
