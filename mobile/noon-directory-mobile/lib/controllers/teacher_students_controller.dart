import 'dart:convert';
import 'package:get/get.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/stage_model.dart';
import 'package:noon/models/class_model.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/controllers/student_controller.dart';
import 'package:flutter/material.dart';

class TeacherStudentsController extends GetxController {
  final ApiService _api = ApiService();
  final loading = false.obs;

  RxList<Stage> stages = <Stage>[].obs;
  RxList<ClassInfo> classes = <ClassInfo>[].obs;
  RxList<Section> sections = <Section>[].obs;

  Rx<Stage?> selectedStage = Rx<Stage?>(null);
  Rx<ClassInfo?> selectedClass = Rx<ClassInfo?>(null);
  Rx<Section?> selectedSection = Rx<Section?>(null);

  @override
  void onInit() {
    super.onInit();
    getTeacherStage();
  }

  Future<void> getTeacherStage() async {
    loading(true);
    try {
      final response = await _api.get(url: ApiUrls.teacherStageUrl);
      stages.value = List<Stage>.from(
        response.data.map((e) => Stage.fromJson(jsonEncode(e))),
      );
    } catch (_) {
      Get.snackbar(AppLanguage.errorStr.tr, AppLanguage.unexpectedErrorStr.tr);
    } finally {
      loading(false);
    }
  }

  Future<void> getTeacherClass(String stageId) async {
    loading(true);
    try {
      final response = await _api.get(
        url: '${ApiUrls.teacherClassUrl}/$stageId',
      );
      classes.value = List<ClassInfo>.from(
        response.data.map((e) => ClassInfo.fromJson(jsonEncode(e))),
      );
    } catch (_) {
      Get.snackbar(AppLanguage.errorStr.tr, AppLanguage.unexpectedErrorStr.tr);
    } finally {
      loading(false);
    }
  }

  Future<void> getTeacherSection(String classId) async {
    loading(true);
    try {
      final response = await _api.get(
        url: '${ApiUrls.teacherSectionUrl}/$classId',
      );
      sections.value = List<Section>.from(
        response.data.map((e) => Section.fromJson(jsonEncode(e))),
      );
    } catch (_) {
      Get.snackbar(AppLanguage.errorStr.tr, AppLanguage.unexpectedErrorStr.tr);
    } finally {
      loading(false);
    }
  }

  void setStage(Stage? value) {
    selectedStage.value = value;
    selectedClass.value = null;
    selectedSection.value = null;
    classes.clear();
    sections.clear();
    if (value?.id != null) getTeacherClass(value!.id!);
  }

  void setClass(ClassInfo? value) {
    selectedClass.value = value;
    selectedSection.value = null;
    sections.clear();
    if (value?.id != null) getTeacherSection(value!.id!);
  }

  void setSection(Section? value) {
    selectedSection.value = value;
  }

  void showSnackbarOnce(String title, String message) {
    if (!Get.isSnackbarOpen) {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
        colorText: Colors.redAccent,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void navigateToStudents() async {
    if (selectedSection.value?.id == null) {
      Get.snackbar(
        AppLanguage.warning.tr,
        "يرجى اختيار الشعبة أولاً",
        backgroundColor: Colors.orange.withValues(alpha: 0.1),
      );
      return;
    }

    final studentController = Get.isRegistered<StudentController>()
        ? Get.find<StudentController>()
        : Get.put(StudentController());

    loading(true);
    await studentController.getStudents(
      sectionIds: [selectedSection.value!.id!],
    );
    loading(false);
    Get.toNamed(ScreensUrls.sectionStudentsScreenUrl);
  }
}
