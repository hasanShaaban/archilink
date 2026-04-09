abstract class FCMDataSource {
  Future<String?> getToken();
  Stream<String> get tokenRefresh;
  Future<void> requestPremision();
}