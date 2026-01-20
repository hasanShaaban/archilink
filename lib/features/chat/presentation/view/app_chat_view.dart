import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

class AppChatView extends StatelessWidget {
  const AppChatView({super.key});
  static const String name = '/chat';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: ChatViewBody()),
      
    );
  }
}

class ChatViewBody extends StatefulWidget {
  const ChatViewBody({super.key});

  @override
  State<ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<ChatViewBody> {
  final chatController = ChatController(
  initialMessageList: messageList,
  scrollController: ScrollController(),
  currentUser: ChatUser(id: '1', name: 'Flutter'),
  otherUsers: [ChatUser(id: '2', name: 'Simform')],
);
  @override
  Widget build(BuildContext context) {
    return ChatView(chatController: chatController, chatViewState: ChatViewState.hasMessages);
  }
}

List<Message> messageList = [
  Message(
    id: '1',
    message: "Hi",
    createdAt: DateTime.now(),
    sentBy: '2',
  ),
  Message(
    id: '2',
    message: "Hello",
    createdAt: DateTime.now(),
    sentBy: '1',
  ),
];