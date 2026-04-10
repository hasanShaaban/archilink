import 'package:firebase_messaging/firebase_messaging.dart';

abstract class FCMDataSource {
  Future<String?> getToken();
  Stream<String> get tokenRefresh;
  Future<void> requestPremision();

  Stream<RemoteMessage> get onForegroundMessage;
  Future<RemoteMessage?> getInitialMessage();
}
