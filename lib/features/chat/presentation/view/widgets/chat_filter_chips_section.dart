import 'package:archilink/features/chat/presentation/view/widgets/chat_filter_chip.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

class ChatFilterChipsSection extends StatefulWidget {
  const ChatFilterChipsSection({super.key, required this.chatListController});
  final ChatListController chatListController;

  @override
  State<ChatFilterChipsSection> createState() => _ChatFilterChipsSectionState();
}

class _ChatFilterChipsSectionState extends State<ChatFilterChipsSection> {
  bool allSelected = true, usersSelected = false, groupsSelected = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChatFilterChip(
            selected: allSelected,
            label: 'All',
            chatListController: widget.chatListController,
            onSelected: (bool value) {
              setState(() {
                allSelected = value;
                usersSelected = false;
                groupsSelected = false;
              });
              widget.chatListController.clearSearch();
            },
          ),
          const SizedBox(width: 8),
          ChatFilterChip(
            selected: usersSelected,
            label: 'Users',
            chatListController: widget.chatListController,
            onSelected: (bool value) {
              setState(() {
                allSelected = false;
                usersSelected = value;
                groupsSelected = false;
              });
              widget.chatListController.setSearchChats(
                widget.chatListController.chatListMap.values
                    .where((e) => e.chatRoomType.isOneToOne)
                    .toList(),
              );
            },
          ),
          const SizedBox(width: 8),
          ChatFilterChip(
            selected: groupsSelected,
            chatListController: widget.chatListController,
            onSelected: (bool value) {
              setState(() {
                allSelected = false;
                usersSelected = false;
                groupsSelected = value;
              });
              widget.chatListController.setSearchChats(
                widget.chatListController.chatListMap.values
                    .where((e) => e.chatRoomType.isGroup)
                    .toList(),
              );
            },
            label: 'Groups',
          ),
        ],
      ),
    );
  }
}