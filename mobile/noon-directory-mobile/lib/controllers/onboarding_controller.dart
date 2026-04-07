import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/controllers/login_controller.dart';
import 'package:noon/core/constant/app_strings.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/core/localization/language.dart';

class OnboardingController extends GetxController {
  final box = Hive.box(AppStrings.boxKey);
  late PageController pageController;
  final gController = Get.find<GlobalController>();
  final RxInt currentPage = 0.obs;
  late RxString selectedLanguage;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    selectedLanguage =
        (gController.selectedLanguageIndex.value == 0
                ? AppLanguage.arabic.tr
                : AppLanguage.english.tr)
            .obs;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void nextPage() {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void skipOnboarding() {
    completeOnboarding();
  }

  void completeOnboarding() {
    box.put(AppStrings.hasSeenOnboardingKey, true);

    final userId = box.get(AppStrings.userIdKey);
    final isDefaultPass = box.get(AppStrings.isDefaultPassKey);
    final loginController = Get.find<LoginController>();
    final hasSchoolCode = box.get(AppStrings.schoolCodeKey) != null;
    final isGuestMode = box.get(AppStrings.isGuestModeKey) == true;

    // If already logged in, go to home/changePass as before
    if (userId != null &&
        loginController.isLoggedIn &&
        isDefaultPass?.toLowerCase() == 'true') {
      Get.offAllNamed(ScreensUrls.changePassUrl);
    } else if (userId != null &&
        loginController.isLoggedIn &&
        isDefaultPass?.toLowerCase() == 'false') {
      Get.offAllNamed(
        Get.find<GlobalController>().isParent
            ? ScreensUrls.selectChildScreenUrl
            : ScreensUrls.homeUrl,
      );
    } else if (hasSchoolCode) {
      // Has school code saved, go directly to login
      Get.offAllNamed(ScreensUrls.loginUrl);
    } else if (isGuestMode) {
      Get.offAllNamed(ScreensUrls.guestHomeUrl);
    } else {
      // New user: show school code screen
      Get.offAllNamed(ScreensUrls.schoolCodeUrl);
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }
}

