import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/constant/app_strings.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/core/enum.dart';
import 'package:noon/core/failures.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/user_model.dart';
import 'package:noon/view/widget/alert_dialogs.dart';

import '../core/device_utils.dart';
import '../core/localization/language.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordController2 = TextEditingController();
  final ApiService _apiService = ApiService();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final _box = Hive.box(AppStrings.boxKey);
  final String userIdKey = AppStrings.userIdKey;
  final String tokenKey = AppStrings.tokenKey;
  final String isDefaultPassKey = AppStrings.isDefaultPassKey;
  final String refreshKey = AppStrings.refreshToken;
  final String isRegisteredKey = AppStrings.isRegisteredKey;

  // final String isTeacherKey = AppStrings.isTeacherKey;
  Rx<UserModel?> user = Rx<UserModel?>(null);

  final RxBool isPasswordVisible = true.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  final RxString schoolLogo = ''.obs;
  final RxString schoolName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    schoolLogo.value = _box.get(AppStrings.schoolLogoKey) ?? '';
    schoolName.value = _box.get(AppStrings.schoolNameKey) ?? '';
    print('🔵 [LOGIN] Logo from Hive: "${schoolLogo.value}"');
    print('🔵 [LOGIN] Name from Hive: "${schoolName.value}"');
    if (schoolLogo.value.isNotEmpty) {
      final url = schoolLogo.value.startsWith('http')
          ? schoolLogo.value
          : '${ApiUrls.filesUrl}/${schoolLogo.value}';
      print('🔵 [LOGIN] Full logo URL: $url');
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool get isLoggedIn {
    final String? token = _box.get(AppStrings.tokenKey);
    final String? pass = _box.get(AppStrings.isDefaultPassKey);
    return (token != null && pass.toString().toLowerCase() == 'false');
  }

  Future<void> login() async {
    isLoading(true);
    if (!formKey.currentState!.validate()) {
      isLoading(false);
      return;
    }
    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();
    var data = {
      'username': username,
      'password': password,
      'client_token': _box.get(AppStrings.firebaseTokenKey),
    };

    try {
      final res = await _apiService.post(url: ApiUrls.login, body: data);

      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }
      final resData = res.data;
      user.value = UserModel.fromMap(resData['user']);

      // final bool isTeacher = res.data['user']['Student'] != null ? false : true;

      if (user.value?.student != null &&
          user.value!.student!.studentEnrollment!.isEmpty) {
        Get.toNamed(ScreensUrls.notRegisteredUrl);
        return;
      }
      await saveUserData(
        resData['user']?['id'],
        resData['token_refresh'],
        resData['token_access'],
        resData['user']?['isDefaultPass'],
        _getAccountType(res.data['user']),
      );

      if (user.value?.isDefaultPass == false) {
        Get.offAllNamed(
          Get.find<GlobalController>().isParent
              ? ScreensUrls.selectChildScreenUrl
              : ScreensUrls.homeUrl,
        );
      } else {
        Get.offAllNamed(ScreensUrls.changePassUrl);
      }
    } catch (e) {
      dprint("Error in login ...");
      dprint(e.toString());
      String error = AppLanguage.unexpectedErrorStr.tr;
      int? statusCode;

      if (e is DioException) {
        statusCode = e.response?.statusCode;

        error = ServerFailure.fromDioError(e).message;
      }
      if (error == 'Access denied' && statusCode == 400) {
        showExceptionAlertDialog(
          title: AppLanguage.errorStr.tr,
          exception: AppLanguage.usernameOrPassNotValid.tr,
        );
      } else {
        showExceptionAlertDialog(
          title: AppLanguage.errorStr.tr,
          exception: error,
        );
      }
    } finally {
      isLoading(false);
      DeviceUtils.hideKeyboard;
    }
  }

  Future saveUserData(
    String? userId,
    String? refreshToken,
    String? tokenAccess,
    String? isDefaultPass,
    // bool? isTeacher,
    AccountType accountType,
  ) async {
    await _box.put(userIdKey, userId);
    await _box.put(refreshKey, refreshToken);
    await _box.put(tokenKey, tokenAccess);
    await _box.put(isDefaultPassKey, isDefaultPass);
    await _box.put(AppStrings.accountTypeKey, accountType.name);
  }

  Future logout() async {
    isLoading(true);
    try {
      dprint("Start logout ...");
      final res = await _apiService.post(url: ApiUrls.logout);

      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }
      dprint("Logout complete successfully ...");
    } catch (e) {
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      dprint("Error in logout ...");
      dprint(error);
    } finally {
      // Always finish logout (clear local data) even if API call fails
      finishLogoutProcess();
      isLoading(false);
    }
  }

  Future<void> updatePassword() async {
    isLoading(true);
    if (!formKey2.currentState!.validate()) {
      isLoading(false);
      return;
    }

    final String password = passwordController2.text.trim();
    var data = {"currentPassword": "1111", 'newPassword': password};

    try {
      final res = await _apiService.patch(
        url: ApiUrls.updatePassUrl,
        body: data,
      );

      final resData = res.data;

      user.value = UserModel.fromMap(resData['user']);

      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }

      // final bool isTeacher = res.data['user']['Student'] != null ? false : true;

      await saveUserData(
        resData['user']?['id'],
        resData['token_refresh'],
        resData['token_access'],
        resData['user']?['isDefaultPass'],
        _getAccountType(resData['user']),
      );

      Get.offAllNamed(
        Get.find<GlobalController>().isParent
            ? ScreensUrls.selectChildScreenUrl
            : ScreensUrls.homeUrl,
      );
    } catch (e) {
      dprint("Error in update password ...");
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      isLoading(false);
    }
  }

  void finishLogoutProcess() async {
    await _box.delete(AppStrings.userIdKey);
    await _box.delete(AppStrings.tokenKey);
    await _box.delete(AppStrings.refreshToken);
    await _box.delete(AppStrings.isDefaultPassKey);
    await _box.delete(AppStrings.accountTypeKey);
    
    // Clear school selection when logging out
    await _box.delete(AppStrings.schoolCodeKey);
    await _box.delete(AppStrings.schoolLogoKey);
    await _box.delete(AppStrings.schoolNameKey);
    await _box.delete(AppStrings.schoolIdKey);
    await _box.delete(AppStrings.isGuestModeKey);
    
    isLoading(false);
    Get.offAllNamed(ScreensUrls.schoolCodeUrl);
  }

  AccountType _getAccountType(Map<String, dynamic> user) {
    AccountType accountType;
    if (user['Student'] != null) {
      accountType = AccountType.student;
    } else if (user['Teacher'] != null) {
      accountType = AccountType.teacher;
    } else {
      accountType = AccountType.parent;
    }
    Get.find<GlobalController>().setAccountType(accountType);
    return accountType;
  }
}
