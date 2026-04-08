

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import '../core/constant/app_strings.dart';

class GlobalController extends GetxController {
  static GlobalController get to => Get.find();
  final box = Hive.box(AppStrings.boxKey);
  Locale _locale = const Locale('ar');

  final selectedLanguageIndex = 0.obs;

  @override
  void onInit() {
    final savedLanguageCode = box.get('locale');
    if (savedLanguageCode != null) {
      _locale = Locale(savedLanguageCode);
    } else {
      _locale = deviceLocale;
    }
    selectedLanguageIndex.value = _locale.languageCode == 'ar' ? 0 : 1;
    super.onInit();
  }

  Locale get locale => _locale;

  Locale get deviceLocale {
    return const Locale('ar');
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
}
