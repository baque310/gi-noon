import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:noon/core/constant/app_colors.dart';

void initEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..loadingStyle = EasyLoadingStyle.custom
    ..radius = 10.0
    ..backgroundColor = Colors.white
    ..indicatorColor = AppColors.mainColor
    ..indicatorWidget = const SizedBox(
      height: 48,
      width: 48,
      child: Center(child: CircularProgressIndicator()),
    )
    ..textColor = Colors.black87
    ..maskColor = Colors.black.withAlpha(125)
    ..userInteractions = false
    ..dismissOnTap = false
    ..maskType = EasyLoadingMaskType.custom;
}
