import 'package:archilink/core/utils/device_helper.dart';

class NetworkConfig {
  static const String emulatorBaseUrl = 'http://10.0.2.2:8000/api/v1/';
  static const String physicalBaseUrl = 'http://127.0.0.1:8000/api/v1/';


  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static const Map<String, String> defaultHeaders = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };
}
