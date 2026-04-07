import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/controllers/login_controller.dart';
import 'package:noon/core/constant/app_strings.dart';
import 'package:noon/core/constant/screens_urls.dart';

class SplashController extends GetxController {
  final box = Hive.box(AppStrings.boxKey);

  final controller = Get.find<LoginController>();
  late final String? userId;
  late final String? isDefaultPass;
  late final bool? isTeacher;

  @override
  void onInit() {
    userId = box.get(AppStrings.userIdKey);
    isDefaultPass = box.get(AppStrings.isDefaultPassKey);
    getUserInfo();
    super.onInit();
  }

  Future<void> getUserInfo() async {
    Future.delayed(const Duration(seconds: 2), () async {
      final hasSeenOnboarding =
          box.get(AppStrings.hasSeenOnboardingKey) ?? false;
      final hasSchoolCode = box.get(AppStrings.schoolCodeKey) != null;
      final isGuestMode = box.get(AppStrings.isGuestModeKey) == true;

      if (!hasSeenOnboarding) {
        // First time: show onboarding
        Get.offAllNamed(ScreensUrls.onboardingUrl);
      } else if (userId != null &&
          controller.isLoggedIn &&
          isDefaultPass!.toLowerCase() == 'true') {
        // Logged in but needs to change default password
        Get.offAllNamed(ScreensUrls.changePassUrl);
      } else if (userId != null &&
          controller.isLoggedIn &&
          isDefaultPass!.toLowerCase() == 'false') {
        // Fully logged in
        Get.offAllNamed(
          Get.find<GlobalController>().isParent
              ? ScreensUrls.selectChildScreenUrl
              : ScreensUrls.homeUrl,
        );
      } else if (hasSchoolCode) {
        // Has school code but not logged in → go to login
        Get.offAllNamed(ScreensUrls.loginUrl);
      } else if (isGuestMode) {
        Get.offAllNamed(ScreensUrls.guestHomeUrl);
      } else {
        // Seen onboarding but no school code → show school code screen
        Get.offAllNamed(ScreensUrls.schoolCodeUrl);
      }
    });
  }
}
