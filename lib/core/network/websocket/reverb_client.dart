import 'dart:developer';

import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:flutter/foundation.dart';

class ReverbClient {
  ReverbClient._();
  static final instance = ReverbClient._();

  PusherChannelsClient? _client;
  String? _socketId;
  String? _authHost;

  String? get socketId => _socketId;
  bool _initialized = false;
  String? _token;

  Future<void> init({
    required String token,
    required String host,
    required String authHost,
  }) async {
    if (_initialized) return;
    _token = token;
    _authHost = authHost;

    final options = PusherChannelsOptions.fromHost(
      scheme: 'ws',
      host: host,
      key: 'jxwpfroqsx4mu4lyl0ke',
      port: 8080,
      shouldSupplyMetadataQueries: true,
      metadata: PusherChannelsOptionsMetadata.byDefault(),
    );

    _client = PusherChannelsClient.websocket(
      options: options,
      connectionErrorHandler: (exception, trace, refresh) {
        debugPrint('[Reverb] Connection error: $exception');
        refresh();
      },
    );

    // Capture socket_id whenever the connection is (re-)established.
    // init() is non-blocking on purpose — a connection failure must never
    // hang the login flow. Subscriptions are handled reactively inside
    // ChatWebsocketRemoteDataSourceImpl via its own onConnectionEstablished
    // listener.
    _client!.onConnectionEstablished.listen((_) {
      _socketId = _client!.socketId;
      log('[Reverb] Connection established — socket_id: $_socketId');
    });

    // connect() initiates the WebSocket handshake asynchronously.
    // The client retries on failure via connectionErrorHandler → refresh().
    _client!.connect();

    _initialized = true;
    log('[Reverb] Client initialised — host: $host, waiting for connection...');
  }

  PrivateChannel privateChannel(String channelName) {
    assert(_client != null, 'ReverbClient not initialised — call init() first');
    assert(_token != null, 'Token is null');
    assert(_authHost != null, 'authHost is null');

    return _client!.privateChannel(
      channelName,
      authorizationDelegate:
          EndpointAuthorizableChannelTokenAuthorizationDelegate.forPrivateChannel(
            authorizationEndpoint: Uri.parse(
              'http://$_authHost:8000/broadcasting/auth',
            ),
            headers: {
              'Authorization': 'Bearer $_token',
              'Accept': 'application/json',
            },
            onAuthFailed: (exception, trace) {
              debugPrint('[Reverb] Auth failed for $channelName: $exception');
            },
          ),
    );
  }

  void disconnect() {
    _client?.dispose();
    _client = null;
    _socketId = null;
    _initialized = false;
    _token = null;
    _authHost = null;
  }

  PusherChannelsClient get client => _client!;
}
