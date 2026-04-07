import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/splash_controller.dart';
import 'package:noon/core/constant/app_assets.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          AppAssets.appLogoImgJpg,
          // height: getDynamicHeight(100),
          // width: getDynamicHeight(100),
        ),
      ),
    );
  }
}
