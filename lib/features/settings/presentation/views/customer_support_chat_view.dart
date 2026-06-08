import 'package:archilink/core/functions/snack_bar_builder.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/customer_support_messages_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/customer_support_messages_state.dart';
import 'package:archilink/features/settings/presentation/views/widgets/customer_support_input_field.dart';
import 'package:archilink/features/settings/presentation/views/widgets/support_date_divider.dart';
import 'package:archilink/features/settings/presentation/views/widgets/support_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SupportMessage {
  final int? id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final MessageStatus status;

  const SupportMessage({
    this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.status = MessageStatus.sent,
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<CustomerSupportMessagesCubit>().fetchMessages();
    }
  }

  List<dynamic> _buildDisplayItems(List<SupportMessage> messages) {
    final List<dynamic> list = [];
    for (int i = 0; i < messages.length; i++) {
      final msg = messages[i];
      list.add(msg);

      final msgDate = DateTime(
        msg.timestamp.year,
        msg.timestamp.month,
        msg.timestamp.day,
      );

      if (i == messages.length - 1) {
        list.add(DateFormat('d MMMM y').format(msg.timestamp));
      } else {
        final nextMsg = messages[i + 1];
        final nextMsgDate = DateTime(
          nextMsg.timestamp.year,
          nextMsg.timestamp.month,
          nextMsg.timestamp.day,
        );
        if (msgDate != nextMsgDate) {
          list.add(DateFormat('d MMMM y').format(msg.timestamp));
        }
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Support')),
      body:
          BlocListener<
            CustomerSupportMessagesCubit,
            CustomerSupportMessagesState
          >(
            listenWhen: (prev, current) =>
                current.sendMessageFailure != null &&
                current.sendMessageFailure !=
                    prev.sendMessageFailure,
            listener: (context, state) {
              if (state.sendMessageFailure != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  appSnackBar(
                    context,
                    state.sendMessageFailure!,
                    state.sendMessageFailure!.message,
                  ),
                );
                context
                    .read<CustomerSupportMessagesCubit>()
                    .clearSendMessageFailure();
              }
            },
            child:
                BlocBuilder<
                  CustomerSupportMessagesCubit,
                  CustomerSupportMessagesState
                >(
                  builder: (context, state) {
                    if (state.isLoadingMessages && !state.hasMessagesData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.messagesErrorMessage != null &&
                        !state.hasMessagesData) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.messagesErrorMessage!),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context
                                  .read<CustomerSupportMessagesCubit>()
                                  .fetchMessages(refresh: true),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    final currentUsername = context
                        .read<CurrentUserCubit>()
                        .state
                        .username;

                    // Map loaded messages
                    final List<SupportMessage> supportMessages = state.messages
                        .map((m) {
                          return SupportMessage(
                            id: m.id,
                            text: m.content,
                            isUser: m.sender.username == currentUsername,
                            timestamp: m.sentAt ?? DateTime.now(),
                            status: MessageStatus.sent,
                          );
                        })
                        .toList();

                    // Map pending messages
                    final List<SupportMessage> pendingMessages = state
                        .pendingMessages
                        .map((m) {
                          return SupportMessage(
                            id: m.id,
                            text: m.content,
                            isUser: m.sender.username == currentUsername,
                            timestamp: m.sentAt ?? DateTime.now(),
                            status:
                                state.messageStatuses[m.id] ??
                                MessageStatus.sending,
                          );
                        })
                        .toList();

                    // Merge pending (newest) first, then loaded messages
                    final List<SupportMessage> combinedMessages = [
                      ...pendingMessages,
                      ...supportMessages,
                    ];

                    // Build display items with dividers
                    final displayItems = _buildDisplayItems(combinedMessages);

                    return SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                reverse: true,
                                itemCount:
                                    displayItems.length +
                                    (state.isLoadingMoreMessages ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == displayItems.length) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  }

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
                                context
                                    .read<CustomerSupportMessagesCubit>()
                                    .sendMessage(text);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
    );
  }
}
