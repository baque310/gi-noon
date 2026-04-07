import 'package:flutter/services.dart';

class PermissionsHelper {
  static const MethodChannel _channel = MethodChannel('permissions_helper');

  static Future<bool> requestDownloadsAccess() async {
    try {
      final bool res =
          await _channel.invokeMethod<bool>('requestDownloadsAccess') ?? false;
      return res;
    } on PlatformException {
      return false;
    }
  }
}
