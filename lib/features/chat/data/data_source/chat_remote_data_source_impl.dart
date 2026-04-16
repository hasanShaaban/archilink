import 'dart:async';
import 'dart:convert';

import 'package:archilink/core/network/websocket/pusher_client.dart';
import 'package:archilink/features/Chat/data/model/message_model.dart';
import 'package:archilink/features/Chat/domain/data_source/chat_remote_data_source.dart';
import 'package:archilink/features/Chat/domain/repo/chat_repo.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final PusherClient _pusherClient;
  final Map<int, StreamController<ChatSocketEvent>> _controllers = {};

  ChatRemoteDataSourceImpl(this._pusherClient);

  @override
  Stream<ChatSocketEvent> subscribeToChannel(int conversationId) {
    if (_controllers.containsKey(conversationId)) {
      return _controllers[conversationId]!.stream;
    }
    final controller = StreamController<ChatSocketEvent>.broadcast();
    _controllers[conversationId] = controller;
    _pusherClient.pusher.subscribe(
      channelName: 'private-chat.$conversationId',
      onEvent: (PusherEvent event) {
        _handleEvent(event, controller);
      },
    );
    return controller.stream;
  }

  void _handleEvent(
    PusherEvent event,
    StreamController<ChatSocketEvent> controller,
  ) {
    if (controller.isClosed) return;

    final data = jsonDecode(event.data ?? '{}') as Map<String, dynamic>;

    switch (event.eventName) {
      case 'message.sent':
        controller.add(MessageSentEvent(MessageModel.fromJson(data)));

      case 'message.deleted':
        controller.add(MessageDeletedEvent(data['message_id'] as int));

      case 'messages.delivered':
        controller.add(MessagesDeliveredEvent(data['conversation_id'] as int));

      case 'messages.seen':
        controller.add(MessagesSeenEvent(data['conversation_id'] as int));
    }
  }

  @override
  Future<void> unsubscribeFromChannel(int conversationId) async {
    await _pusherClient.pusher.unsubscribe(
      channelName: 'private-chat.$conversationId',
    );
    await _controllers[conversationId]?.close();
    _controllers.remove(conversationId);
  }
}
