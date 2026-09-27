import 'dart:async';
import 'dart:developer';

import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:flutter/foundation.dart';

void connectToPusher() async {
  final token = sl<CurrentUserCubit>().state.token;
  log('REVERB TEST: Current User Token: $token');
  log('REVERB TEST: initalizing Client...');

  const testOptions = PusherChannelsOptions.fromHost(
    scheme: 'ws',
    host: '10.0.2.2',
    key: 'jxwpfroqsx4mu4lyl0ke',
    shouldSupplyMetadataQueries: true,
    metadata: PusherChannelsOptionsMetadata.byDefault(),
    port: 8080,
  );

  log('REVERB TEST: Options created : ${testOptions.uri.toString()}');

  final client = PusherChannelsClient.websocket(
    options: testOptions,
    connectionErrorHandler: (e, trace, refresh) async {
      refresh();
    },
  );

  client.onConnectionEstablished.listen(
    onError: (e) {
      log('-------------Reverb connection error');
    },
    onDone: () {
      log('-------------Reverb connected');
    },

    (event) {
      debugPrint("REVERB TEST: Connected to Reverb");
    },
  );

  await client.connect();

  PrivateChannel myPrivateChannel = client.privateChannel(
    "private-user.1",
    authorizationDelegate:
        EndpointAuthorizableChannelTokenAuthorizationDelegate.forPrivateChannel(
          authorizationEndpoint: Uri.parse(
            'http://10.0.2.2:8000/broadcasting/auth',
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
  );

  StreamSubscription<ChannelReadEvent> somePrivateChannelEventSubs =
      myPrivateChannel.bind('message.deleted').listen((event) {
        log('Event from the private channel fired!');
        log('Event: ${event.data}');
      });

  StreamSubscription<ChannelReadEvent> allEvents = myPrivateChannel
      .bindToAll()
      .listen((event) {
        log('Event from the private channel fired!');
        log('Event: ${event.data}');
      });

  myPrivateChannel.subscribe();

  final StreamSubscription connectionSub = client.onConnectionEstablished
      .listen((_) {
        log('REVERB TEST: Connection established');
        myPrivateChannel.subscribe();
      });

  myPrivateChannel.whenSubscriptionSucceeded().listen((event) {
    log('REVERB TEST: Subscription Succeeded ${event.channelName}');
    log('REVERB TEST: Event ${event.data}');
  });
  log('REVERB TEST: ${client.socketId}');
  log(allEvents.toString());
}
