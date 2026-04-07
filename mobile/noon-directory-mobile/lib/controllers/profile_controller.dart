import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/constant/app_strings.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/core/failures.dart';
import 'package:noon/core/image_helper.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/user_model.dart';
import 'package:noon/view/widget/alert_dialogs.dart';

import '../core/function.dart';
import '../core/localization/language.dart';

class ProfileController extends GetxController with StateMixin<UserModel> {
  final ApiService apiService = ApiService();

  final RxBool loading = false.obs;
  final RxString errorMessage = ''.obs;
  final String userIdKey = AppStrings.userIdKey;
  Rx<UserModel?> user = Rx<UserModel?>(null);
  Rx<File?> image = Rx<File?>(null);
  final box = Hive.box(AppStrings.boxKey);
  RxString selectedGender = ''.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var email = ''.obs;
  var phone = ''.obs;
  RxString selectedDate = ''.obs;
  final notificationCount = 0.obs;
  final unreadMessagesCount = 0.obs;
  final gController = Get.find<GlobalController>();

  @override
  void onInit() {
    getUser();
    super.onInit();
  }

  Future getUser() async {
    try {
      change(null, status: RxStatus.loading());
      loading(true);
      final res = await apiService.get(url: ApiUrls.userProfileUrl);

      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }

      user.value = UserModel.fromMap(res.data['user']);

      _setUserId();

      try {
        if (gController.isStudent) {
          await gController.setStudentClassId(
            user.value?.student?.studentEnrollment?.first.classInfo?.id,
          );
        }
      } catch (_) {}

      notificationCount.value = res.data['isNotSeen'] ?? 0;
      unreadMessagesCount.value = res.data['unreadMessagesCount'] ?? 0;

      updateEditProfileInputs();

      change(user.value, status: RxStatus.success());
    } catch (e, stackTrace) {
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      dprint("Error in getUser: $e");
      dprint("Stack trace: $stackTrace");
      change(null, status: RxStatus.error(error));
    } finally {
      loading(false);
    }
  }

  void updateEditProfileInputs() {
    if (gController.isTeacher) {
      //teacher email
      email(user.value?.teacher?.email);
      emailController.text = user.value?.teacher?.email ?? '';
      //teacher phone number
      phone(user.value?.teacher?.phone1);
      phoneController.text = user.value?.teacher?.phone1 ?? '';
      //teacher bith date
      selectedDate(user.value?.teacher?.birth?.formatDateToYearMonthDay);
      //teacher gender
      selectedGender(user.value!.teacher!.gender!.toLowerCase());
    } else if (gController.isStudent) {
      //Student email
      email(user.value?.student?.email);
      emailController.text = user.value?.student?.email ?? '';
      //Student phone
      phone(user.value?.student?.phone1);
      phoneController.text = user.value?.student?.phone1 ?? '';
      //Student bith date
      selectedDate(user.value?.student?.birth?.formatDateToYearMonthDay);
    } else {
      //Parent email
      email(user.value?.parent?.email);
      emailController.text = user.value?.parent?.email ?? '';
      //Parent phone
      phone(user.value?.parent?.phone1);
      phoneController.text = user.value?.parent?.phone1 ?? '';
      //Parent bith date
      selectedDate(user.value?.parent?.birth?.formatDateToYearMonthDay);
    }
  }

  bool get hasChanges {
    if (user.value == null) return false;
    if (gController.isTeacher) {
      return phone.value != user.value!.teacher?.phone1 ||
          selectedDate.value !=
              user.value!.teacher?.birth?.formatDateToYearMonthDay;
    } else if (gController.isStudent) {
      return phone.value != user.value!.student?.phone1 ||
          selectedDate.value !=
              user.value!.student?.birth?.formatDateToYearMonthDay;
    } else {
      return phone.value != user.value!.parent?.phone1 ||
          selectedDate.value !=
              user.value!.parent?.birth?.formatDateToYearMonthDay;
    }
  }

  void pickDate() async {
    DateTime? pickedDate = await pickDateMethode();
    if (pickedDate != null) {
      selectedDate.value =
          '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
    }
  }

  Future getImage(ImageSource media) async {
    Get.back();
    final imageFile = await ImageHelper.getImage(media);
    if (imageFile != null) {
      image.value = imageFile;
      //  isEditAccountData(true);
    }
    if (image.value != null) {
      await updateUserById(justImg: true);
    }
  }

  Future<bool> updateUserById({bool justImg = false}) async {
    try {
      loading(true);

      String? fileName = image.value?.path.split('/').last;
      String? url;
      dio.FormData data;
      if (justImg) {
        data = dio.FormData.fromMap({
          if (image.value != null)
            "photo": await dio.MultipartFile.fromFile(
              image.value!.path,
              filename: fileName,
            ),
        });
      } else {
        data = dio.FormData.fromMap({
          // "fullName": name.value,
          "phone1": phone.value,
          "birth": selectedDate.value,
          if (email.value != '') "email": email.value,
          if (Get.find<GlobalController>().isTeacher)
            "Gender": capitalizeFirstLetter(selectedGender.value),
          if (image.value != null)
            "photo": await dio.MultipartFile.fromFile(
              image.value!.path,
              filename: fileName,
            ),
        });
      }

      if (gController.isTeacher) {
        url = ApiUrls.updateTeacherProfileUrl;
      } else if (gController.isStudent) {
        url = ApiUrls.updateStudentProfileUrl;
      } else {
        url = ApiUrls.updateParentProfileUrl;
      }

      final res = await apiService.patch(url: url, body: data);

      if (res.data == null) {
        throw Exception();
      }
      if (!justImg) {
        Get.back(); // Close the edit dialog before showing the snackbar
      }
      Get.snackbar(
        AppLanguage.tureOperationStr.tr,
        AppLanguage.updateInfoStr.tr,
      );
      await getUser();
      return true;
    } catch (e) {
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is dio.DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
      return false;
    } finally {
      loading(false);
    }
  }

  void _setUserId() async {
    if (user.value?.id != null) {
      gController.setUserId(user.value?.id);
    }
  }
}
