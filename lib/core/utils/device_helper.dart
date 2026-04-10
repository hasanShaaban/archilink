import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoHelper {
  static Future<bool> isEmulator() async {
    if (!Platform.isAndroid) return false;
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    return !androidInfo.isPhysicalDevice;
  }
}
