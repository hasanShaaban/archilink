import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppChatView extends StatelessWidget {
  const AppChatView({super.key});
  static const String name = '/chat';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: _ChatViewBody()));
  }
}

// ─── Private enum for the popup menu ────────────────────────────────────────
enum _ChatAction { viewMembers, muteNotifications, exportChat, starMessage }

// ─── Stateful body ──────────────────────────────────────────────────────────
class _ChatViewBody extends StatefulWidget {
  const _ChatViewBody();

  @override
  State<_ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<_ChatViewBody> {
  late final ChatController _chatController;

  @override
  void initState() {
    super.initState();
    _chatController = ChatController(
      initialMessageList: _demoMessages,
      scrollController: ScrollController(),
      currentUser: ChatUser(id: '1', name: 'Flutter Dev'),
      otherUsers: [ChatUser(id: '2', name: 'Simform')],
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  // ─── Send handler ──────────────────────────────────────────────────────────
  // void _onSendTap(
  //   String message,
  //   ReplyMessage replyMessage,
  //   MessageType messageType,
  // ) {
  //   _chatController.addMessage(
  //     Message(
  //       id: const Uuid().v4(),
  //       message: message,
  //       createdAt: DateTime.now(),
  //       sentBy: '1',
  //       replyMessage: replyMessage,
  //       messageType: messageType,
  //     ),
  //   );
  // }

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

    return ChatView(
      // onSendTap: _onSendTap,
      chatController: _chatController,
      chatViewState: ChatViewState.hasMessages,

      // ─── Features ──────────────────────────────────────────────────────────
      featureActiveConfig: const FeatureActiveConfig(
        enableOtherUserName: false,
        enablePagination: true,
        enableSwipeToReply: true,
        enableReactionPopup: true,
        enableScrollToBottomButton: true,
        enableDoubleTapToLike: true,
      ),

      // ─── AppBar ────────────────────────────────────────────────────────────
      appBar: ChatViewAppBar(
        imageType: ImageType.asset, //TODO: change to network for real images

        backGroundColor: scaffoldBg,
        profilePicture: Assets.assetsImagesBackgroundDark,
        chatTitle: 'Simform',
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: AppColorsFromTheme.grayForTheme(context),
          borderRadius: BorderRadius.circular(16),
        ),
        outgoingChatBubbleConfig: ChatBubble(
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

      // ─── Reply message ─────────────────────────────────────────────────────
      // repliedMessageConfig: RepliedMessageConfiguration(
      //   backgroundColor: AppColorsFromTheme.grayForTheme(context),
      //   textStyle: AppTextStyle.interRegular14.copyWith(
      //     color: colorScheme.onSurface.withOpacity(0.7),
      //   ),
      //   replyTitleTextStyle: AppTextStyle.interSemiBold16.copyWith(
      //     color: colorScheme.primary,
      //   ),
      //   closeIconColor: colorScheme.onSurface,
      // ),

      // ─── Reaction popup (long-press) ───────────────────────────────────────
      reactionPopupConfig: ReactionPopupConfiguration(
        showGlassMorphismEffect: true,
        backgroundColor: colorScheme.surface,
        shadow: BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
        userReactionCallback: (message, emoji) {
          // chatview handles it internally via chatController
        },
      ),

      // ─── Reaction chip below bubbles ───────────────────────────────────────

      // ─── Image messages ────────────────────────────────────────────────────
      messageConfig: MessageConfiguration(
        imageMessageConfig: ImageMessageConfiguration(
          padding: const EdgeInsets.all(4),
        ),
      ),

      // ─── Input bar ─────────────────────────────────────────────────────────
      sendMessageConfig: SendMessageConfiguration(
        voiceRecordingConfiguration: VoiceRecordingConfiguration(
          waveStyle: WaveStyle(
            waveColor: colorScheme.primary,
            middleLineColor: colorScheme.primary,
          ),
          micIcon: SvgPicture.asset(
            Assets.assetsIconsMic,
            color: colorScheme.primary,
          ),
        ),
        textFieldBackgroundColor: AppColorsFromTheme.grayForTheme(context),
        textFieldConfig: TextFieldConfiguration(
          margin: EdgeInsetsDirectional.all(15),
          hintText: 'Message',
          hintStyle: AppTextStyle.interRegular16.copyWith(
            color: colorScheme.onSurface.withOpacity(0.4),
          ),
          textStyle: AppTextStyle.interRegular16.copyWith(
            color: colorScheme.onSurface,
          ),
          borderRadius: BorderRadius.circular(16),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
        sendButtonIcon: Icon(Icons.send_outlined, color: colorScheme.primary),

        imagePickerIconsConfig: ImagePickerIconsConfiguration(
          galleryImagePickerIcon: SvgPicture.asset(
            Assets.assetsIconsAttachment,
            color: colorScheme.primary,
          ),
          cameraImagePickerIcon: Icon(
            Icons.camera_alt_outlined,
            color: colorScheme.primary,
          ),
        ),
        replyMessageColor: colorScheme.onSurface,
        replyDialogColor: AppColorsFromTheme.grayForTheme(context),
        replyTitleColor: colorScheme.primary,
        closeIconColor: colorScheme.onSurface,
      ),
    );
  }
}

// ─── Demo data ────────────────────────────────────────────────────────────────
final List<Message> _demoMessages = [
  Message(
    id: '1',
    message: 'Hi there!',
    createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    sentBy: '2',
  ),
  Message(
    id: '2',
    message: 'Hello! How are you?',
    createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
    sentBy: '1',
  ),
  Message(
    id: '3',
    message: 'Doing great! Check this out 👇',
    createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
    sentBy: '2',
    replyMessage: const ReplyMessage(
      messageId: '1',
      message: 'Hi there!',
      replyTo: '2',
      replyBy: '2',
      messageType: MessageType.text,
    ),
  ),
];
