import 'dart:async';
import 'dart:convert';
import 'package:archilink/core/network/websocket/reverb_client.dart';
import 'package:archilink/features/Chat/data/model/message_model.dart';
import 'package:archilink/features/Chat/domain/data_source/chat_websocket_remote_data_source.dart';
import 'package:archilink/features/Chat/domain/repo/chat_websocket_repo.dart';

class ChatWebsocketRemoteDataSourceImpl
    implements ChatWebsocketRemoteDataSource {
  final ReverbClient _reverbClient;
  final Map<int, StreamController<ChatSocketEvent>> _controllers = {};
  final Map<int, List<StreamSubscription>> _subscriptions = {};

  ChatWebsocketRemoteDataSourceImpl(this._reverbClient);
  @override
  Stream<ChatSocketEvent> subscribeToChannel(int conversationId) {
    if (_controllers.containsKey(conversationId)) {
      return _controllers[conversationId]!.stream;
    }
    final controller = StreamController<ChatSocketEvent>();
    _controllers[conversationId] = controller;

    final channel = _reverbClient.privateChannel(
      'private-chat.$conversationId',
    );

    _reverbClient.client.onConnectionEstablished.listen((_) {
      channel.subscribe();
    });

    if (_reverbClient.socketId != null) {
      channel.subscribe();
    }

    final subs = <StreamSubscription>[
      channel.bind('message.sent').listen((event) {
        if (controller.isClosed) return;
        final data = _decode(event.data);
        controller.add(MessageSentEvent(MessageModel.fromJson(data)));
      }),
      channel.bind('message.deleted').listen((event) {
        if (controller.isClosed) return;
        final data = _decode(event.data);
        controller.add(MessageDeletedEvent(data['message_id'] as int));
      }),

      channel.bind('messages.delivered').listen((event) {
        if (controller.isClosed) return;
        final data = _decode(event.data);
        controller.add(MessagesDeliveredEvent(data['conversation_id'] as int));
      }),

      channel.bind('messages.seen').listen((event) {
        if (controller.isClosed) return;
        final data = _decode(event.data);
        controller.add(MessagesSeenEvent(data['conversation_id'] as int));
      }),
    ];

    _subscriptions[conversationId] = subs;
    return controller.stream;
  }

  @override
  Future<void> unsubscribeFromChannel(int conversationId) async {
    final subs = _subscriptions.remove(conversationId);
    if (subs != null) {
      for (final sub in subs) {
        await sub.cancel();
      }
    }
    await _controllers[conversationId]?.close();
    _controllers.remove(conversationId);
  }

  Map<String, dynamic> _decode(dynamic data) {
    if (data is String) return jsonDecode(data) as Map<String, dynamic>;
    if (data is Map<String, dynamic>) return data;
    return {};
  }
}
