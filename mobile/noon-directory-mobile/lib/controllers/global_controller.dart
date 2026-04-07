import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/enum.dart';
import 'package:noon/core/localization/language.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constant/app_strings.dart';

class GlobalController extends GetxController {
  // وصول عالمي للـ Controller من أي مكان في التطبيق
  static GlobalController get to => Get.find();
  final box = Hive.box(AppStrings.boxKey);
  Locale _locale = const Locale('ar');

  final selectedLanguageIndex = 0.obs;

  String? _accountType;

  String? userId;
  final selectedStudentIdForParent = Rxn<String>();

  String? classId;
  String? selectedStudentClassIdForParent;

  @override
  void onInit() {
    _accountType = box.get(AppStrings.accountTypeKey);
    userId = box.get(AppStrings.userIdKey);
    final savedLanguageCode = box.get('locale');
    if (savedLanguageCode != null) {
      _locale = Locale(savedLanguageCode);
    } else {
      _locale = deviceLocale;
    }
    selectedLanguageIndex.value = _locale.languageCode == 'ar' ? 0 : 1;
    super.onInit();
  }

  void setUserId(String? newUserId) {
    final storedUserId = box.get(AppStrings.userIdKey);

    if (newUserId != null && newUserId == storedUserId) {
      userId = newUserId;
    } else if (storedUserId != null) {
      userId = storedUserId;
    }
  }

  Locale get locale => _locale;

  Locale get deviceLocale {
    return Platform.localeName.contains('en')
        ? const Locale('en')
        : const Locale('ar');
  }

  void setLanguage() {
    final selectedLocale = Locale(
      selectedLanguageIndex.value == 0 ? 'ar' : 'en',
    );
    Get.updateLocale(selectedLocale);
    _locale = selectedLocale;
    _saveLanguage(selectedLocale);
    update();
  }

  void _saveLanguage(Locale locale) async {
    await box.put('locale', locale.languageCode);
  }

  bool get isLtr => _locale.languageCode == 'en';

  void setAccountType(AccountType type) {
    _accountType = type.name;
  }

  AccountType? get accountType => _convertToAccountType;

  bool get isTeacher {
    return _accountType == AccountType.teacher.name;
  }

  bool get isStudent {
    return _accountType == AccountType.student.name;
  }

  bool get isParent {
    return _accountType == AccountType.parent.name;
  }

  AccountType? get _convertToAccountType {
    if (_accountType == null) {
      return null; // Default to parent if not set
    }
    return AccountType.values.firstWhere(
      (e) => e.toString().split('.').last == _accountType,
    );
  }

  Future<void> checkForUpdate() async {
    if (kDebugMode) return;

    final info = await InAppUpdate.checkForUpdate();
    if (info.updateAvailability == UpdateAvailability.updateAvailable) {
      Get.bottomSheet(
        backgroundColor: AppColors.neutralBackground,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        ),
        SafeArea(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            width: getDynamicWidth(350),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLanguage.updateAvailable.tr,
                  style: AppTextStyles.bold18,
                ),
                const SizedBox(height: 16.0),

                SvgPicture.asset(
                  AppAssets.icUpdateApp,
                  height: 140.0,
                  width: 140,
                ),
                const SizedBox(height: 16.0),

                Text(
                  AppLanguage.updateAvailableDescription.tr,
                  style: AppTextStyles.regular14,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    onPressed: () async {
                      // ? TODO: change package name and app store id
                      final url = Uri.parse(
                        Platform.isAndroid
                            ? 'https://play.google.com/store/apps/details?id=com.noon.teacher'
                            : 'https://apps.apple.com/us/app/noon/id1649832524',
                      );

                      final launched = await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );

                      if (!launched) {
                        Get.snackbar(
                          'خطأ',
                          'تعذر فتح المتجر. الرجاء المحاولة مرة أخرى.',
                        );
                      }
                    },
                    child: Text(AppLanguage.updateNow.tr),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<void> setSelectedStudentForParent({
    required String? studentId,
    required String? classId,
  }) async {
    selectedStudentIdForParent.value = studentId;
    selectedStudentClassIdForParent = classId;
  }

  Future<void> setStudentClassId(String? classId) async {
    this.classId = classId;
  }
}
