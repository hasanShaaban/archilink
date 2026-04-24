import 'dart:developer';

import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:flutter/material.dart';

class ReverbClient {
  ReverbClient._();
  static final instance = ReverbClient._();

  PusherChannelsClient? _client;
  String? _socketId;

  String? get socketId => _socketId;
  bool _initialized = false;
  String? _token;

  Future<void> init({required String token}) async {
    if (_initialized) return;
    _token = token;

    const options = PusherChannelsOptions.fromHost(
      scheme: 'ws',
      host: '10.95.129.92',
      key: 'jxwpfroqsx4mu4lyl0ke',
      port: 8080,
      shouldSupplyMetadataQueries: true,
      metadata: PusherChannelsOptionsMetadata.byDefault(),
    );

    _client = PusherChannelsClient.websocket(
      options: options,
      connectionErrorHandler: (exception, trace, refresh) {
        debugPrint('Pusher error: $exception');
        refresh();
      },
    );

    _client!.onConnectionEstablished.listen(
      onError: (e) {
        debugPrint('Reverb connection error : $e');
      },
      onDone: () {
        debugPrint('Reverb connection established — socket_id: $_socketId');
      },
      (ondata) {
        debugPrint('Reverb connected — socket_id:');
      },
    );
    log('ReverbClient initialized with token: $token');

    await _client!.connect();
    _socketId = _client!.socketId;
    _initialized = true;
    log('ReverbClient connected with socket_id: $_socketId');
  }

  PrivateChannel privateChannel(String channelName) {
    assert(_client != null, 'PusherClient not initialized');
    assert(_token != null, 'Token is null');

    return _client!.privateChannel(
      channelName,
      authorizationDelegate:
          EndpointAuthorizableChannelTokenAuthorizationDelegate.forPrivateChannel(
            authorizationEndpoint: Uri.parse(
              'http://10.95.129.92:8000/broadcasting/auth',
            ),
            headers: {
              'Authorization': 'Bearer $_token',
              'Accept': 'application/json',
            },
          ),
    );
  }

  void disconnect() {
    _client?.dispose();
    _client = null;
    _socketId = null;
    _initialized = false;
  }

  PusherChannelsClient get client => _client!;
}
