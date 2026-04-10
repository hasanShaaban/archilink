import 'dart:convert';

import 'package:archilink/core/services/notification/display/notificatio_display_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationDisplayServiceImpl implements NotificationDisplayService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  @override
  Future<void> init() async {
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSetting = DarwinInitializationSettings();

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidSetting,
        iOS: iosSetting,
      ),
    );
  }

  @override
  Future<void> show(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _plugin.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel',
          'General Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }
}
