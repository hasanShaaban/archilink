import 'package:archilink/core/services/notification/data_source/fcm_data_source.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMDataSourceImpl extends FCMDataSource {
  final FirebaseMessaging _messageing = FirebaseMessaging.instance;
  @override
  Future<String?> getToken() async {
    return await _messageing.getToken();
  }

  @override
  Future<void> requestPremision() async {
    await _messageing.requestPermission(alert: true, badge: true, sound: true);
  }

  @override
  Stream<String> get tokenRefresh => _messageing.onTokenRefresh;

  @override
  Future<RemoteMessage?> getInitialMessage() => _messageing.getInitialMessage();

  @override
  Stream<RemoteMessage> get onForegroundMessage => FirebaseMessaging.onMessage;
}
