class NetworkConfig {
  // ─── HTTP API ───────────────────────────────────────────────────────────────
  static const String emulatorBaseUrl = 'http://10.0.2.2:8000/api/v1/';
  static const String physicalBaseUrl = 'http://127.0.0.1:8000/api/v1/';

  // ─── WebSocket (Laravel Reverb) ─────────────────────────────────────────────
  // Android emulator cannot reach 127.0.0.1 (that's the emulator's own loopback).
  // It reaches the host machine via the special alias 10.0.2.2.
  static const String reverbEmulatorHost = '10.0.2.2';
  static const String reverbPhysicalHost = '10.210.48.104';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static const Map<String, String> defaultHeaders = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };
}
