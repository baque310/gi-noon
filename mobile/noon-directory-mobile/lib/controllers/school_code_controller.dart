import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/constant/app_strings.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/core/print_value.dart';

class SchoolCodeController extends GetxController {
  final box = Hive.box(AppStrings.boxKey);
  final codeController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;

  // School data after successful verification
  final RxString schoolName = ''.obs;
  final RxString schoolLogo = ''.obs;
  final RxString schoolId = ''.obs;
  final RxBool isVerified = false.obs;

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

  /// Verify school code via public API
  Future<void> verifySchoolCode() async {
    final code = codeController.text.trim().toUpperCase();

    if (code.isEmpty) {
      isError.value = true;
      errorMessage.value = 'الرجاء إدخال رمز المدرسة';
      return;
    }

    if (code.length < 6) {
      isError.value = true;
      errorMessage.value = 'رمز المدرسة يجب أن يكون 6 أحرف على الأقل';
      return;
    }

    isLoading.value = true;
    isError.value = false;
    errorMessage.value = '';

    try {
      final response = await ApiService().get(
        url: '${ApiUrls.verifySchoolCodeUrl}/$code',
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        print('🟢 [SCHOOL] Full API response: $data');
        print('🟢 [SCHOOL] Logo from API: ${data['logo']}');
        schoolName.value = data['name'] ?? '';
        schoolLogo.value = data['logo'] ?? '';
        schoolId.value = data['id']?.toString() ?? '';
        isVerified.value = true;
        print('🟢 [SCHOOL] Saved logo value: ${schoolLogo.value}');

        // Save school info to local storage
        await _saveSchoolData(code);
        print('🟢 [SCHOOL] Logo in Hive after save: ${box.get(AppStrings.schoolLogoKey)}');

        // Navigate to login
        Get.offAllNamed(ScreensUrls.loginUrl);
      }
    } catch (e) {
      dprint('School code verification error: $e');
      isError.value = true;

      // Handle different error cases
      if (e.toString().contains('404') || e.toString().contains('Not Found')) {
        errorMessage.value = 'رمز المدرسة غير صحيح، تأكد من الرمز وحاول مرة أخرى';
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection')) {
        errorMessage.value = 'لا يوجد اتصال بالإنترنت، حاول مرة أخرى';
      } else {
        errorMessage.value = 'حدث خطأ، حاول مرة أخرى لاحقاً';
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Save school data locally
  Future<void> _saveSchoolData(String code) async {
    await box.put(AppStrings.schoolCodeKey, code);
    await box.put(AppStrings.schoolNameKey, schoolName.value);
    await box.put(AppStrings.schoolLogoKey, schoolLogo.value);
    await box.put(AppStrings.schoolIdKey, schoolId.value);
    await box.put(AppStrings.isGuestModeKey, false);
  }

  /// Enter as guest (skip school code)
  void enterAsGuest() {
    box.put(AppStrings.isGuestModeKey, true);
    // Clear any previous school data
    box.delete(AppStrings.schoolCodeKey);
    box.delete(AppStrings.schoolNameKey);
    box.delete(AppStrings.schoolLogoKey);
    box.delete(AppStrings.schoolIdKey);

    Get.offAllNamed(ScreensUrls.guestHomeUrl);
  }

  /// Check if user has a saved school code
  static bool hasSavedSchoolCode() {
    final box = Hive.box(AppStrings.boxKey);
    return box.get(AppStrings.schoolCodeKey) != null;
  }

  /// Check if user is in guest mode
  static bool isGuest() {
    final box = Hive.box(AppStrings.boxKey);
    return box.get(AppStrings.isGuestModeKey) == true;
  }
}
