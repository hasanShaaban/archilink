
// import 'package:flutter/material.dart';
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

// class PusherClient {
//   PusherClient._();
//   static final instance = PusherClient._();

//   final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();

//   bool _initailized = false;
//   String? _socketId;
//   String? get socketId => _socketId;

//   Future<void> init({required String token}) async {
//     if (_initailized) return;
//     await _pusher.init(
//       useTLS: false,
//       apiKey: 'jxwpfroqsx4mu4lyl0ke',
//       cluster: '',
//       authEndpoint: 'http://10.0.2.2:8000/broadcasting/auth',
//       authParams: {
//         'headers': {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       },
//       enabledTransports: ['ws'],
//       logToConsole: true,
//       onConnectionStateChange: (currentState, previousState) async {
//         if (currentState == 'CONNECTED') {
//           _socketId = await _pusher.getSocketId();
//         }
//         if (currentState == 'DISCONNECTED') {
//           _socketId = null;
//         }
//         debugPrint('Pusher: $previousState → $currentState');
//       },
//       onError: (message, code, error) {
//         debugPrint('Pusher error [$code]: $message — $error');
//       },
//       onSubscriptionError: (message, error) {
//         debugPrint('Subscription error: $message — $error');
//       },
//     );

//     await _pusher.connect();
//     _initailized = true;
//   }

//   Future<void> disconnect() async {
//     await _pusher.disconnect();
//     _initailized = false;
//   }

//   PusherChannelsFlutter get pusher => _pusher;
// }
