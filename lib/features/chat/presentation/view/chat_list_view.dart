import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/Chat/domain/entity/chat_args.dart';
import 'package:archilink/features/Chat/domain/entity/chat_list_view_entity.dart/chat_entity.dart';
import 'package:archilink/features/Chat/domain/repo/chat_repo.dart';
import 'package:archilink/features/Chat/domain/repo/chat_websocket_repo.dart';
import 'package:archilink/features/Chat/presentation/manager/bloc/chat_bloc.dart';
import 'package:archilink/features/Chat/presentation/manager/cubit/chat_list_cubit.dart';
import 'package:archilink/features/Chat/presentation/view/app_chat_view.dart';
import 'package:archilink/features/Chat/presentation/view/widgets/chat_app_bar.dart';
import 'package:archilink/features/Chat/presentation/view/widgets/chat_filter_chips_section.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  static const String name = '/chatListView';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: sl<ChatBloc>(),
            ),
            BlocProvider(
              create: (context) => ChatListCubit(sl<ChatRepo>())..getChats(),
            ),
          ],
          child: BlocConsumer<ChatListCubit, ChatListState>(
            listener: (context, state) {
              if (state.failure != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.failure!.message)));
              }
            },
            builder: (context, state) {
              if (state.isLoading && state.chats.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              }

              if (state.failure != null && state.chats.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.failure!.message,
                        style: AppTextStyle.interMedium14.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<ChatListCubit>().getChats(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return ChatListViewBody(chats: state.chats);
            },
          ),
        ),
      ),
    );
  }
}

class ChatListViewBody extends StatefulWidget {
  final List<ChatEntity> chats;
  const ChatListViewBody({super.key, required this.chats});

  @override
  State<ChatListViewBody> createState() => _ChatListViewBodyState();
}

class _ChatListViewBodyState extends State<ChatListViewBody> {
  late ChatListController chatListController;
  final ScrollController _scrollController = ScrollController();
  ChatSocketEvent? _lastHandledSocketEvent;

  @override
  void initState() {
    super.initState();
    chatListController = ChatListController(
      initialChatList: _mapChatsToItems(widget.chats),
      scrollController: _scrollController,
    );

    // Subscribe to the current user's channel as soon as the user enters the chats view
    final currentUserId = context.read<CurrentUserCubit>().state.id ??
        sl<CurrentUserCubit>().state.id;
    if (currentUserId != null) {
      context.read<ChatBloc>().add(SubscribeToChat(currentUserId));
    }

    // Ensure the stream emits items to the active listener after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        chatListController.loadMoreChats([]);
      }
    });
  }

  @override
  void didUpdateWidget(covariant ChatListViewBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.chats != oldWidget.chats) {
      final items = _mapChatsToItems(widget.chats);
      chatListController.chatListMap.clear();
      chatListController.loadMoreChats(items);
    }
  }

  @override
  void dispose() {
    chatListController.dispose();
    super.dispose();
  }

  void _handleSocketEvent(ChatSocketEvent event) {
    final currentUserId = context.read<CurrentUserCubit>().state.id;

    switch (event) {
      case MessageSentEvent(:final message):
        final chatIdStr = message.chatId.toString();
        if (chatListController.chatListMap.containsKey(chatIdStr)) {
          // Identify the matching chat and update its last message and unread count
          chatListController.updateChat(
            chatIdStr,
            (previousChat) {
              final isFromOther = message.sender.id != currentUserId;
              final currentUnread = previousChat.unreadCount ?? 0;
              return previousChat.copyWith(
                lastMessage: Message(
                  id: message.id.toString(),
                  message: message.content,
                  createdAt: message.sentAt ?? DateTime.now(),
                  sentBy: message.sender.id.toString(),
                  status: MessageStatus.delivered,
                ),
                unreadCount: isFromOther ? currentUnread + 1 : currentUnread,
              );
            },
          );
        } else {
          // If a new conversation was created that isn't in our list, refresh chats
          context.read<ChatListCubit>().getChats();
        }

      case MessageDeletedEvent():
        context.read<ChatListCubit>().getChats();

      case MessagesDeliveredEvent():
        break;

      case MessagesSeenEvent(:final conversationId):
        final chatIdStr = conversationId.toString();
        if (chatListController.chatListMap.containsKey(chatIdStr)) {
          chatListController.updateChat(
            chatIdStr,
            (previousChat) => previousChat.copyWith(unreadCount: 0),
          );
        }
    }
  }

  List<ChatListItem> _mapChatsToItems(List<ChatEntity> chats) {
    return chats.map((chat) {
      final displayName = chat.chatName.isNotEmpty
          ? chat.chatName
          : chat.contact.name;

      Message? lastMessage;
      if (chat.lastMessage != null) {
        lastMessage = Message(
          id: chat.lastMessage!.id.toString(),
          message: chat.lastMessage!.content,
          createdAt: chat.lastMessage!.sentAt,
          sentBy: chat.contact.id.toString(),
          status: MessageStatus.delivered,
        );
      }

      return ChatListItem(
        id: chat.id.toString(),
        name: displayName,
        chatRoomType: chat.type == ChatType.group
            ? ChatRoomType.group
            : ChatRoomType.oneToOne,
        imageUrl: chat.chatCoverUrl ?? chat.contact.avatar,
        unreadCount: chat.unreadCount,
        lastMessage: lastMessage,
      );
    }).toList();
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inDays == 0 && now.day == time.day) {
      return DateFormat('h:mm a').format(time);
    } else if (difference.inDays < 7) {
      return DateFormat('E').format(time);
    } else {
      return DateFormat('MMM d').format(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final avatarRadius = width * 20 / 402;

    return BlocListener<ChatBloc, ChatState>(
      listener: (context, chatState) {
        final event = chatState.lastSocketEvent;
        if (event != null && event != _lastHandledSocketEvent) {
          _lastHandledSocketEvent = event;
          _handleSocketEvent(event);
        }
      },
      child: RefreshIndicator(
        onRefresh: () => context.read<ChatListCubit>().getChats(),
        child: ChatList(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          controller: chatListController,
          appbar: const ChatAppBar(),
          stateConfig: ListStateConfig(
            noChatsWidgetConfig: ChatViewStateWidgetConfiguration(
              title: 'No chats yet',
              subTitle: 'Your conversations will appear here',
              titleTextStyle: AppTextStyle.interSemiBold16.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              subTitleTextStyle: AppTextStyle.interMedium12.copyWith(
                color: AppColors.gray,
              ),
            ),
          ),
          searchConfig: SearchConfig(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            prefixIcon: null,
            textFieldBackgroundColor: AppColorsFromTheme.grayForTheme(
              context,
            ),
            textEditingController: TextEditingController(),
            suffixIcon: IconButton(
              splashRadius: 1,
              onPressed: () {},
              icon: SvgPicture.asset(
                Assets.assetsIconsSearch,
                colorFilter: const ColorFilter.mode(
                  AppColors.gray,
                  BlendMode.srcIn,
                ),
              ),
            ),
            debounceDuration: const Duration(milliseconds: 300),
            onSearch: (value) async {
              if (value.isEmpty) {
                return null;
              }
              final list = chatListController.chatListMap.values
                  .where(
                    (chat) =>
                        chat.name.toLowerCase().contains(value.toLowerCase()),
                  )
                  .toList();
              return list;
            },
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          header: ChatFilterChipsSection(
            chatListController: chatListController,
          ),
          menuConfig: ChatMenuConfig(
            deleteCallback: (chat) => chatListController.removeChat(chat.id),
            // muteStatusCallback: (result) => chatListController.updateChat(
            //   result.chat.id,
            //   (previousChat) => previousChat.copyWith(
            //     settings: previousChat.settings.copyWith(
            //       muteStatus: result.status,
            //     ),
            //   ),
            // ),
            // pinStatusCallback: (result) => chatListController.updateChat(
            //   result.chat.id,
            //   (previousChat) => previousChat.copyWith(
            //     settings: previousChat.settings.copyWith(
            //       pinStatus: result.status,
            //     ),
            //   ),
            // ),
          ),
          tileConfig: ListTileConfig(
            lastMessageMaxLines: 2,
            timeConfig: LastMessageTimeConfig(
              timeBuilder: (time) {
                return Text(
                  _formatTime(time),
                  style: AppTextStyle.interMedium10.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                );
              },
            ),
            unreadCountConfig: UnreadCountConfig(
              backgroundColor: Theme.of(context).colorScheme.primary,
              style: UnreadCountStyle.ninetyNinePlus,
              fontSize: 10,
            ),
            userAvatarConfig: UserAvatarConfig(
              avatarBuilder: (chat) {
                final hasImage =
                    chat.imageUrl != null && chat.imageUrl!.isNotEmpty;

                return CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: AppColorsFromTheme.grayForTheme(context),
                  child: hasImage
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: chat.imageUrl!,
                            width: avatarRadius * 2,
                            height: avatarRadius * 2,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                SvgPicture.asset(
                              Assets.assetsIconsUser,
                              colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.onSurface,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        )
                      : SvgPicture.asset(
                          Assets.assetsIconsUser,
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onSurface,
                            BlendMode.srcIn,
                          ),
                        ),
                );
              },
            ),
            onTap: (chat) {
              Navigator.of(context, rootNavigator: true).pushNamed(
                AppChatView.name,
                arguments: ChatArgs(
                  conversationId: int.tryParse(chat.id) ?? 0,
                  chatTitle: chat.name,
                  profileImage: chat.imageUrl,
                ),
              );
            },
            padding: const EdgeInsets.all(12),
            middleWidgetPadding: const EdgeInsets.symmetric(horizontal: 12),
            lastMessageTextStyle: AppTextStyle.interMedium14.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            userNameTextStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
