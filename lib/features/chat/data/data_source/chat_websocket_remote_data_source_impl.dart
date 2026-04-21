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



// import 'dart:async';
// import 'dart:convert';

// import 'package:archilink/core/network/websocket/pusher_client.dart';
// import 'package:archilink/features/Chat/data/model/message_model.dart';
// import 'package:archilink/features/Chat/domain/data_source/chat_websocket_remote_data_source.dart';
// import 'package:archilink/features/Chat/domain/repo/chat_websocket_repo.dart';
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

// class ChatWebsocketRemoteDataSourceImpl implements ChatWebsocketRemoteDataSource {
//   final PusherClient _pusherClient;
//   final Map<int, StreamController<ChatSocketEvent>> _controllers = {};

//   ChatWebsocketRemoteDataSourceImpl(this._pusherClient);

//   @override
//   Stream<ChatSocketEvent> subscribeToChannel(int conversationId) {
//     if (_controllers.containsKey(conversationId)) {
//       return _controllers[conversationId]!.stream;
//     }
//     final controller = StreamController<ChatSocketEvent>.broadcast();
//     _controllers[conversationId] = controller;
//     _pusherClient.pusher.subscribe(
//       channelName: 'private-chat.$conversationId',
//       onEvent: (PusherEvent event) {
//         _handleEvent(event, controller);
//       },
//     );
//     return controller.stream;
//   }

//   void _handleEvent(
//     PusherEvent event,
//     StreamController<ChatSocketEvent> controller,
//   ) {
//     if (controller.isClosed) return;

//     final data = jsonDecode(event.data ?? '{}') as Map<String, dynamic>;

//     switch (event.eventName) {
//       case 'message.sent':
//         controller.add(MessageSentEvent(MessageModel.fromJson(data)));

//       case 'message.deleted':
//         controller.add(MessageDeletedEvent(data['message_id'] as int));

//       case 'messages.delivered':
//         controller.add(MessagesDeliveredEvent(data['conversation_id'] as int));

//       case 'messages.seen':
//         controller.add(MessagesSeenEvent(data['conversation_id'] as int));
//     }
//   }

//   @override
//   Future<void> unsubscribeFromChannel(int conversationId) async {
//     await _pusherClient.pusher.unsubscribe(
//       channelName: 'private-chat.$conversationId',
//     );
//     await _controllers[conversationId]?.close();
//     _controllers.remove(conversationId);
//   }
// }