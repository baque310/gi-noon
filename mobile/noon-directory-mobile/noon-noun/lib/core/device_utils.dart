import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DeviceUtils {
  static void hideKeyboard() {
    FocusScope.of(Get.context!).requestScopeFocus();
  }

  static Future<void> stopDeviceOrientation() {
    return SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static double get keyboardHeight =>
      MediaQuery.of(Get.context!).viewInsets.bottom;
}
