import 'package:archilink/features/settings/presentation/views/widgets/customer_support_input_field.dart';
import 'package:archilink/features/settings/presentation/views/widgets/support_date_divider.dart';
import 'package:archilink/features/settings/presentation/views/widgets/support_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SupportMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const SupportMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class CustomerSupportChatView extends StatefulWidget {
  const CustomerSupportChatView({super.key});

  static const String name = 'customerSupportChatView';

  @override
  State<CustomerSupportChatView> createState() =>
      _CustomerSupportChatViewState();
}

class _CustomerSupportChatViewState extends State<CustomerSupportChatView> {
  final List<SupportMessage> _messages = [
    SupportMessage(
      text: "Hello! How can we help you today?",
      isUser: false,
      timestamp: DateTime(2025, 4, 15, 10, 0),
    ),
    SupportMessage(
      text: "I have a problem with my saved collections.",
      isUser: true,
      timestamp: DateTime(2025, 4, 15, 10, 2),
    ),
    SupportMessage(
      text: "Could you please describe the issue in detail?",
      isUser: false,
      timestamp: DateTime(2025, 4, 15, 10, 5),
    ),
    SupportMessage(
      text: "It keeps throwing an error when I try to open 'Modern Kitchens'.",
      isUser: true,
      timestamp: DateTime(2025, 4, 16, 9, 30),
    ),
  ];

  List<dynamic> get _displayItems {
    final List<dynamic> list = [];
    for (int i = _messages.length - 1; i >= 0; i--) {
      final msg = _messages[i];
      final msgDate = DateTime(
        msg.timestamp.year,
        msg.timestamp.month,
        msg.timestamp.day,
      );

      list.add(msg);

      if (i == 0) {
        list.add(DateFormat('d MMMM y').format(msg.timestamp));
      } else {
        final prevMsg = _messages[i - 1];
        final prevMsgDate = DateTime(
          prevMsg.timestamp.year,
          prevMsg.timestamp.month,
          prevMsg.timestamp.day,
        );
        if (msgDate != prevMsgDate) {
          list.add(DateFormat('d MMMM y').format(msg.timestamp));
        }
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final displayItems = _displayItems;

    return Scaffold(
      appBar: AppBar(title: const Text('Customer Support')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: displayItems.length,
                  itemBuilder: (context, index) {
                    final item = displayItems[index];

                    if (item is String) {
                      return SupportDateDivider(date: item);
                    }

                    final message = item as SupportMessage;
                    return SupportMessageBubble(message: message);
                  },
                ),
              ),
              const SizedBox(height: 12),
              CustomerSupportInputField(
                onSend: (text) {
                  setState(() {
                    _messages.add(
                      SupportMessage(
                        text: text,
                        isUser: true,
                        timestamp: DateTime.now(),
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
