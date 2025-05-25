import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3010/api';
    } else if (Platform.isAndroid) {
      // Android emulator uses 10.0.2.2 to access host machine
      return 'http://10.0.2.2:3010/api';
    } else if (Platform.isIOS) {
      // iOS simulator can use localhost, but real device needs LAN IP
      return 'http://localhost:3010/api'; // Change to your LAN IP for real device
    } else {
      // Fallback for other platforms
      return 'http://localhost:3010/api';
    }
  }
}
