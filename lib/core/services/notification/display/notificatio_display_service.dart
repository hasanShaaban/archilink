import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationDisplayService {
  Future<void> init();
  Future<void> show(RemoteMessage message);
}