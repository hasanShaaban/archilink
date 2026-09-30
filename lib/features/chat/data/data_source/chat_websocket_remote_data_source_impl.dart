import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:archilink/core/network/websocket/reverb_client.dart';
import 'package:archilink/features/Chat/data/model/chat_model/message_model.dart';
import 'package:archilink/features/Chat/data/model/chat_model/reaction_model.dart';
import 'package:archilink/features/Chat/domain/data_source/chat_websocket_remote_data_source.dart';
import 'package:archilink/features/Chat/domain/repo/chat_websocket_repo.dart';

class ChatWebsocketRemoteDataSourceImpl
    implements ChatWebsocketRemoteDataSource {
  final ReverbClient _reverbClient;

  StreamController<ChatSocketEvent>? _controller;
  final List<StreamSubscription> _subscriptions = [];
  int? _connectedUserId;

  ChatWebsocketRemoteDataSourceImpl(this._reverbClient);

  @override
  Stream<ChatSocketEvent> connect(int currentUserId) {
    // Guard: reuse the existing stream if already connected for this user.
    if (_connectedUserId == currentUserId && _controller != null) {
      log(
        '[Reverb] Already connected to private-user.$currentUserId — reusing stream',
      );
      return _controller!.stream;
    }

    // Account switch: tear down the previous user's channel first.
    if (_connectedUserId != null && _connectedUserId != currentUserId) {
      disconnect();
    }

    _connectedUserId = currentUserId;
    final controller = StreamController<ChatSocketEvent>.broadcast();
    _controller = controller;

    final channel = _reverbClient.privateChannel('private-user.$currentUserId');

    _subscriptions.addAll([
      channel.bind('pusher:subscription_succeeded').listen((_) {
        log('[Reverb] Subscribed to private-user.$currentUserId');
      }),
      channel.bind('pusher:subscription_error').listen((event) {
        log(
          '[Reverb] Subscription error on private-user.$currentUserId | data: ${event.data}',
        );
      }),

      channel.bind('message.added').listen((event) {
        log('[Reverb] message.added RAW: ${event.data}');
        if (controller.isClosed) return;
        final data = _decode(event.data);
        final messageData = (data['message'] as Map<String, dynamic>?) ?? data;
        controller.add(MessageAddedEvent(MessageModel.fromJson(messageData)));
      }),

      channel.bind('message.sent').listen((event) {
        log('[Reverb] message.sent RAW: ${event.data}');
        if (controller.isClosed) return;
        final data = _decode(event.data);
        final messageData = (data['message'] as Map<String, dynamic>?) ?? data;
        controller.add(MessageAddedEvent(MessageModel.fromJson(messageData)));
      }),

      channel.bind('message.deleted').listen((event) {
        log('[Reverb] message.deleted RAW: ${event.data}');
        if (controller.isClosed) return;
        final data = _decode(event.data);
        controller.add(
          MessageDeletedEvent(
            chatId: data['chat_id'] as int,
            messageId: data['message_id'] as int,
          ),
        );
      }),

      channel.bind('message.seen').listen((event) {
        log('[Reverb] messages.seen RAW: ${event.data}');
        if (controller.isClosed) return;
        final data = _decode(event.data);
        controller.add(
          MessagesSeenEvent(
            userId: data['user_id'] as int,
            chatId: data['chat_id'] as int,
            readOutboxMaxId: data['read_outbox_max_id'] as int,
          ),
        );
      }),

      channel.bind('message.reaction.added').listen((event) {
        log('[Reverb] message.reaction.added RAW: ${event.data}');
        if (controller.isClosed) return;
        try {
          final data = _decode(event.data);
          final Map<String, dynamic> reactionData;
          if (data['reaction'] is Map<String, dynamic>) {
            reactionData = data['reaction'] as Map<String, dynamic>;
          } else if (data['data'] is Map<String, dynamic>) {
            reactionData = data['data'] as Map<String, dynamic>;
          } else {
            reactionData = data;
          }

          final chatIdRaw = data['chat_id'] ??
              data['chatId'] ??
              reactionData['chat_id'] ??
              reactionData['chatId'];
          final chatId = int.tryParse(chatIdRaw?.toString() ?? '') ?? 0;

          final msgIdRaw = reactionData['message_id'] ??
              reactionData['messageId'] ??
              data['message_id'] ??
              data['messageId'];
          final messageId = int.tryParse(msgIdRaw?.toString() ?? '') ?? 0;

          final reactionModel = ReactionModel.fromJson(reactionData);

          log(
            '[Reverb] Parsed reaction.added: chatId=$chatId, messageId=$messageId, emoji=${reactionModel.reaction}, user=${reactionModel.userId}',
          );

          controller.add(
            MessageReactionAddedEvent(
              chatId: chatId,
              messageId: messageId,
              reaction: reactionModel,
            ),
          );
        } catch (e, st) {
          log('[Reverb] Error parsing message.reaction.added: $e\n$st');
        }
      }),

      channel.bind('message.reaction.removed').listen((event) {
        log('[Reverb] message.reaction.removed RAW: ${event.data}');
        if (controller.isClosed) return;
        try {
          final data = _decode(event.data);
          final inner = (data['data'] is Map<String, dynamic>)
              ? data['data'] as Map<String, dynamic>
              : (data['reaction'] is Map<String, dynamic>
                  ? data['reaction'] as Map<String, dynamic>
                  : data);

          final chatIdRaw = data['chat_id'] ??
              data['chatId'] ??
              inner['chat_id'] ??
              inner['chatId'];
          final chatId = int.tryParse(chatIdRaw?.toString() ?? '') ?? 0;

          final msgIdRaw = inner['message_id'] ??
              inner['messageId'] ??
              data['message_id'] ??
              data['messageId'];
          final messageId = int.tryParse(msgIdRaw?.toString() ?? '') ?? 0;

          final userIdRaw = inner['user_id'] ??
              inner['userId'] ??
              data['user_id'] ??
              data['userId'];
          final userId = int.tryParse(userIdRaw?.toString() ?? '') ?? 0;

          log(
            '[Reverb] Parsed reaction.removed: chatId=$chatId, messageId=$messageId, user=$userId',
          );

          controller.add(
            MessageReactionRemovedEvent(
              chatId: chatId,
              messageId: messageId,
              userId: userId,
            ),
          );
        } catch (e, st) {
          log('[Reverb] Error parsing message.reaction.removed: $e\n$st');
        }
      }),

      // Re-subscribe on reconnect (e.g. after a network drop).
      _reverbClient.client.onConnectionEstablished.listen((_) {
        log(
          '[Reverb] Reconnected — resubscribing to private-user.$currentUserId',
        );
        channel.subscribeIfNotUnsubscribed();
      }),
    ]);

    // Initial subscribe in case the socket is already connected.
    channel.subscribeIfNotUnsubscribed();

    return controller.stream;
  }

  @override
  Future<void> disconnect() async {
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    _subscriptions.clear();
    await _controller?.close();
    _controller = null;
    _connectedUserId = null;
    log('[Reverb] Disconnected from user channel');
  }

  Map<String, dynamic> _decode(dynamic data) {
    if (data is String) return jsonDecode(data) as Map<String, dynamic>;
    if (data is Map<String, dynamic>) return data;
    return {};
  }
}
