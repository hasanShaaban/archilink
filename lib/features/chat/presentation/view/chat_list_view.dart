import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Chat/domain/repo/chat_repo.dart';
import 'package:archilink/features/Chat/presentation/manager/cubit/chat_list_cubit.dart';
import 'package:archilink/features/Chat/presentation/view/app_chat_view.dart';
import 'package:archilink/features/Chat/presentation/view/widgets/chat_app_bar.dart';
import 'package:archilink/features/Chat/presentation/view/widgets/chat_filter_chips_section.dart';
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
        body: BlocProvider(
          create: (context) => ChatListCubit(sl<ChatRepo>())..getChats(),
          child: ChatListViewBody(),
        ),
      ),
    );
  }
}

class ChatListViewBody extends StatefulWidget {
  const ChatListViewBody({super.key});

  @override
  State<ChatListViewBody> createState() => _ChatListViewBodyState();
}

class _ChatListViewBodyState extends State<ChatListViewBody> {
  late ChatListController chatListController;
  final ScrollController _scrollController = ScrollController(); // Define here

  @override
  void initState() {
    super.initState();
    chatListController = ChatListController(
      initialChatList: chatList,
      scrollController: _scrollController,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Always dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocConsumer<ChatListCubit, ChatListState>(
      listener: (context, state) {
        if (state.failure != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.failure.toString())));
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: ChatList(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            controller: chatListController,
            appbar: ChatAppBar(),
            searchConfig: SearchConfig(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16),
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
                  color: AppColors.gray,
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
              muteStatusCallback: (result) => chatListController.updateChat(
                result.chat.id,
                (previousChat) => previousChat.copyWith(
                  settings: previousChat.settings.copyWith(
                    muteStatus: result.status,
                  ),
                ),
              ),
              pinStatusCallback: (result) => chatListController.updateChat(
                result.chat.id,
                (previousChat) => previousChat.copyWith(
                  settings: previousChat.settings.copyWith(
                    pinStatus: result.status,
                  ),
                ),
              ),
            ),
            tileConfig: ListTileConfig(
              lastMessageMaxLines: 2,
              timeConfig: LastMessageTimeConfig(
                timeBuilder: (time) {
                  return Text(
                    DateFormat('h:mm a').format(time),
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
                  return CircleAvatar(
                    radius: width * 20 / 402,
                    backgroundColor: AppColorsFromTheme.grayForTheme(context),
                    child: SvgPicture.asset(
                      //TODO: replace with user image
                      Assets.assetsIconsUser,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  );
                },
              ),
              onTap: (chat) {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed(AppChatView.name);
              },
              padding: const EdgeInsets.all(12),
              middleWidgetPadding: const EdgeInsets.symmetric(horizontal: 12),
              lastMessageTextStyle: AppTextStyle.interMedium14.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              userNameTextStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}

List<ChatListItem> chatList = [
  ChatListItem(
    id: '2',
    name: 'Simform',
    unreadCount: 2, //self calc
    lastMessage: Message(
      id: '12',
      sentBy: '2',
      message: "🤩🤩",
      createdAt: DateTime.now(),
      status: MessageStatus.delivered,
    ),
    settings: ChatSettings(
      pinTime: DateTime.now(),
      pinStatus: PinStatus.pinned,
    ),
  ),
  ChatListItem(
    id: '1',
    name: 'Flutter',
    userActiveStatus: UserActiveStatus.online,
    typingUsers: {const ChatUser(id: '1', name: 'Simform')},
  ),
  ChatListItem(
    id: '3',
    name: 'group1',
    chatRoomType: ChatRoomType.oneToOne,
    lastMessage: Message(
      id: '12',
      sentBy: '2',
      message: "🤩🤩",
      createdAt: DateTime.now(),
      status: MessageStatus.delivered,
    ),
  ),
  ChatListItem(
    unreadCount: 1,
    id: '4',
    name: 'Hasan',
    chatRoomType: ChatRoomType.oneToOne,
    lastMessage: Message(
      id: '1',
      message: 'hi ',
      createdAt: DateTime.now(),
      sentBy: '2',
      status: MessageStatus.delivered,
    ),
  ),
];
