// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/constant/app_strings.dart';
import 'package:noon/core/device_utils.dart';
import 'package:noon/core/failures.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/class_model.dart';
import 'package:noon/models/degrees_model.dart';
import 'package:noon/models/exam_data_model.dart';
import 'package:noon/models/exam_model.dart';
import 'package:noon/models/exam_section_model.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/models/stage_model.dart';
import 'package:noon/models/student_model.dart';
import 'package:noon/models/teacher_subject_model.dart';
import 'package:noon/view/widget/alert_dialogs.dart';
import '../core/localization/language.dart';
import 'global_controller.dart';

enum StudentSortOption {
  alphabetical,
  noGrades,
  scoreHighToLow,
  scoreLowToHigh,
}

class TeacherDegreesController extends GetxController {
  RxBool loading = false.obs;
  final ApiService _apiService = ApiService();
  final box = Hive.box(AppStrings.boxKey);

  var lastSnackbarTime = DateTime.now().subtract(const Duration(seconds: 5));

  void showSnackbarOnce(String title, String message) {
    if (DateTime.now().difference(lastSnackbarTime).inSeconds > 5) {
      Get.snackbar(title, message);
      lastSnackbarTime = DateTime.now();
    }
  }

  //stage المرحلئ
  RxList<Stage> stages = <Stage>[].obs;
  Rxn<Stage> stageValue = Rxn<Stage>(null);

  //class الصف
  RxList<ClassInfo> classes = <ClassInfo>[].obs;
  Rxn<ClassInfo> classValue = Rxn<ClassInfo>(null);

  //section الشعبة
  RxList<Section> sections = <Section>[].obs;
  Rxn<Section> sectionValue = Rxn<Section>(null);

  //subject المادة
  RxList<TeacherSubject> subjects = <TeacherSubject>[].obs;
  Rxn<TeacherSubject> subjectValue = Rxn<TeacherSubject>(null);

  /// 🔹 تحسين عرض المواد:
  /// في حال عدم اختيار شعبة، يقوم النظام بدمج المواد المتكررة بناءً على نوعها (StageSubjectId)
  /// ليظهر للمعلم قائمة نظيفة وفريدة من المواد التي يدرسها.
  List<TeacherSubject> get filteredSubjects {
    if (sectionId.value == null) {
      // Return a deduplicated list of subjects when no section is selected
      final Map<String, TeacherSubject> uniqueSubjects = {};
      for (var sub in subjects) {
        final ssId = sub.stageSubjectId;
        if (ssId != null) {
          uniqueSubjects.putIfAbsent(ssId, () => sub);
        }
      }
      return uniqueSubjects.values.toList();
    }

    return subjects.where((sub) {
      final subSectionId = sub.section?.id;
      if (subSectionId != null) {
        return sectionId.value == subSectionId;
      }
      return false;
    }).toList();
  }

  //Exam الامتحان
  Rxn<String> sectionId = Rxn<String>(null);
  RxList<ExamSectionModel> exams = <ExamSectionModel>[].obs;
  Rxn<ExamSectionModel> examValue = Rxn<ExamSectionModel>(null);

  //degrees الدرجات
  RxList<DegreesModel> examResult = <DegreesModel>[].obs;
  RxString examResultIdSelected = ''.obs;
  RxString examSectionIdSelected = ''.obs;

  //الدرجات للطالب student degrees
  Rx<ExamModel> studentExamResults = ExamModel().obs;
  RxList<ExamDataModel> studentExamsData = <ExamDataModel>[].obs;
  RxList<String> studentExams = <String>[].obs;
  Rxn<String> studentExamValue = Rxn<String>(null);
  RxList<StudentModel> studentNotHaveDegrees = <StudentModel>[].obs;
  Rxn<String> studentId = Rxn<String>(null);
  Rxn<int> index = Rxn<int>(null);

  final degreeController = TextEditingController();

  // === Inline editing: track score changes per student ===
  final RxMap<String, int> editedScores = <String, int>{}.obs;
  RxBool isSavingAll = false.obs;

  /// Returns true if there are unsaved changes
  bool get hasUnsavedChanges => editedScores.isNotEmpty;

  /// Update a single student's score in the local map (no API call yet)
  void setInlineScore(String degreeId, int score) {
    editedScores[degreeId] = score;
  }

  /// Save ALL edited scores at once
  Future<void> saveAllDegrees() async {
    if (editedScores.isEmpty) return;

    isSavingAll(true);
    try {
      // Separate new students from existing ones
      final List<Map<String, dynamic>> newResults = [];
      final List<MapEntry<String, int>> updateResults = [];

      for (final entry in editedScores.entries) {
        if (entry.key.startsWith("new_")) {
          final realStudentId = entry.key.replaceFirst("new_", "");
          newResults.add({
            "score": entry.value,
            "notes": "",
            "studentId": realStudentId,
            "examSectionId": examSectionIdSelected.value,
          });
        } else {
          updateResults.add(entry);
        }
      }

      // Batch create new results
      if (newResults.isNotEmpty) {
        await _apiService.post(
          url: ApiUrls.teacherExamResultUrl,
          body: {"ExamResults": newResults},
        );
      }

      // Update existing results one by one (API doesn't support batch update)
      for (final entry in updateResults) {
        await _apiService.patch(
          url: "${ApiUrls.teacherExamResultUrl}/${entry.key}",
          body: {"score": entry.value},
        );
      }

      editedScores.clear();

      Get.snackbar(
        AppLanguage.success.tr,
        AppLanguage.degreeUpdatedSuccessfullyStr.tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Refresh data
      await getTeacherResultExams(examSectionIdSelected.value);
      DeviceUtils.hideKeyboard();
    } catch (e) {
      dprint("Error in saveAllDegrees: $e");
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is dio.DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      isSavingAll(false);
    }
  }

  double get average {
    if (studentExamsData.isEmpty) return 0.0;
    final total = studentExamsData.fold(
      0,
      (sum, item) => sum + item.score.toInt(),
    );
    return total / studentExamsData.length;
  }

  void updateDegreeController(String newValue) {
    final score = int.tryParse(newValue) ?? 0;
    degreeController.text = score.toString();
  }

  ScrollController scrollController = ScrollController();
  RxBool isShowKeyboard = false.obs;

  final controller = Get.find<GlobalController>();

  void openKeyboard(BuildContext context, FocusNode focusNode) {
    focusNode.requestFocus();
    Future.delayed(const Duration(milliseconds: 300), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    });
    update();
  }

  void showKeyboard() {
    if (View.of(Get.context!).viewInsets.bottom > 0.0) {
      isShowKeyboard.value = true;
    } else {
      isShowKeyboard.value = false;
    }

    update();
  }

  RxString searchQuery = "".obs;

  Rx<StudentSortOption> selectedSortOption = StudentSortOption.alphabetical.obs;

  List<DegreesModel> get filteredExamResults {
    List<DegreesModel> results = List.from(examResult);

    // Filter by Search Query
    if (searchQuery.value.isNotEmpty) {
      results = results.where((element) {
        return (element.student?.fullName.toLowerCase() ?? "").contains(
          searchQuery.value.toLowerCase(),
        );
      }).toList();
    }

    // Apply Sorting/Filtering based on selection
    switch (selectedSortOption.value) {
      case StudentSortOption.alphabetical:
        results.sort(
          (a, b) =>
              (a.student?.fullName ?? "").compareTo(b.student?.fullName ?? ""),
        );
        break;
      case StudentSortOption.noGrades:
        // Filter only those that are 'new' (not yet saved to server)
        results = results
            .where((element) => element.id.startsWith("new_"))
            .toList();
        break;
      case StudentSortOption.scoreHighToLow:
        results.sort((a, b) => b.score.compareTo(a.score));
        break;
      case StudentSortOption.scoreLowToHigh:
        results.sort((a, b) => a.score.compareTo(b.score));
        break;
    }

    return results;
  }

  @override
  void onInit() {
    super.onInit();
    if (!controller.isTeacher) {
      getStudentDegrees();
    } else {
      getTeacherStage();
    }
  }

  var examResults = <Map<String, dynamic>>[].obs;
  var selectedStudents = <String>[].obs;

  void toggleSelection(String studentId) {
    if (selectedStudents.contains(studentId)) {
      selectedStudents.remove(studentId);
    } else {
      selectedStudents.add(studentId);
    }
  }

  void clearSelection() {
    selectedStudents.clear();
  }

  void addStudentDegreesMap(int score, String note) {
    if (selectedStudents.isEmpty) {
      return;
    }

    for (var studentId in selectedStudents) {
      examResults.add({
        "score": score,
        "notes": note,
        "studentId": studentId,
        "examSectionId": examSectionIdSelected.value,
      });
    }
    selectedStudents.clear();
  }

  Future getStudentDegrees() async {
    dprint("Get students exam results ........");
    loading(true);
    try {
      final res = await _apiService.get(
        url: controller.isParent
            ? '${ApiUrls.parentExamResultUrl}/${controller.selectedStudentIdForParent.value!}'
            : ApiUrls.studentExamResultUrl,
      );
      final Map<String, dynamic> rawData = res.data['data'];

      if (rawData.isNotEmpty) {
        final Map<String, List<Map<String, dynamic>>> formattedData = rawData
            .map(
              (key, value) =>
                  MapEntry(key, List<Map<String, dynamic>>.from(value)),
            );

        final jsonString = jsonEncode({'sections': formattedData});

        studentExamResults.value = ExamModel.fromJson(jsonString);
        studentExams.addAll(studentExamResults.value.sections.keys);
        studentExamsData.addAll(
          studentExamResults.value.sections.values.expand((list) => list),
        );
        studentExamValue.value = studentExams.first;
      }
    } catch (e) {
      dprint("Error in Get student exams results ...");
      dprint(e.toString());
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is dio.DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      loading(false);
    }
  }

  Future getTeacherStage() async {
    dprint("Get teacher stage ........");

    loading(true);
    try {
      final res = await _apiService.get(url: ApiUrls.teacherStageUrl);
      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }
      stages.value = List.from(
        res.data.map((s) => Stage.fromJson(jsonEncode(s))),
      );
    } catch (e) {
      dprint("Error in Get stage ...");
      dprint(e.toString());
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is dio.DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
      dprint(error);
    } finally {
      loading(false);
    }
  }

  Future getTeacherClass(String? stageId) async {
    loading(true);
    try {
      final res = await _apiService.get(
        url: '${ApiUrls.teacherClassUrl}/$stageId',
      );
      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }
      classes.value = List.from(
        res.data.map((s) => ClassInfo.fromJson(jsonEncode(s))),
      );
    } catch (e) {
      dprint("Error in Get class ...");
      dprint(e.toString());
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is dio.DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
      dprint(error);
    } finally {
      loading(false);
    }
  }

  Future getTeacherSection(String? classId) async {
    loading(true);
    try {
      final res = await _apiService.get(
        url: '${ApiUrls.teacherSectionUrl}/$classId',
      );
      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }
      sections.value = List.from(
        res.data.map((s) => Section.fromJson(jsonEncode(s))),
      );
    } catch (e) {
      dprint("Error in Get section ...");
      dprint(e.toString());
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is dio.DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
      dprint(error);
    } finally {
      loading(false);
    }
  }

  Future getTeacherSubject(String? classId) async {
    loading(true);
    try {
      final res = await _apiService.get(
        url: '${ApiUrls.teacherOwnSubjectUrl}/$classId',
      );
      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }
      subjects.value = List.from(
        res.data.map((s) => TeacherSubject.fromJson(jsonEncode(s))),
      );
    } catch (e) {
      dprint("Error in Get subject ...");
      dprint(e.toString());
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is dio.DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
      dprint(error);
    } finally {
      loading(false);
    }
  }

  Future getTeacherExams(String? subjectId) async {
    loading(true);
    try {
      final res = await _apiService.get(
        url: '${ApiUrls.teacherExamsSectionUrl}/${sectionId.value}/$subjectId',
      );
      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }
      exams.value = List.from(
        res.data.map((s) => ExamSectionModel.fromJson(jsonEncode(s))),
      );
    } catch (e) {
      dprint("Error in Get exams ...");
      dprint(e.toString());
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is dio.DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
      dprint(error);
    } finally {
      loading(false);
    }
  }

  Future getTeacherResultExams(String? examSectionId) async {
    dprint("Get getTeacherResultExams request ...");
    loading(true);
    try {
      final res = await _apiService.get(
        url: ApiUrls.teacherExamResultUrl,
        queryParameters: {
          "skip": "1",
          "take": "5000",
          "examSectionId": examSectionId,
        },
      );

      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }

      final currentResults = List<DegreesModel>.from(
        res.data['data'].map((s) => DegreesModel.fromJson(jsonEncode(s))),
      );

      final resStudents = await _apiService.get(
        url: ApiUrls.studentNotHaveDegreesUrl,
        queryParameters: {"examSectionId": examSectionId},
      );

      final noDegreeStudents = List<StudentModel>.from(
        resStudents.data.map((e) => StudentModel.fromJson(jsonEncode(e))),
      );

      // Update observable
      studentNotHaveDegrees.value = noDegreeStudents;

      final pendingResults = noDegreeStudents.map((student) {
        return DegreesModel(
          (b) => b
            ..id = "new_${student.id}"
            ..score = 0
            ..notes = ""
            ..examSectionId = examSectionId
            ..student.replace(student),
        );
      }).toList();

      examResult.value = [...currentResults, ...pendingResults];
      examResult.value = [...currentResults, ...pendingResults];
    } catch (e) {
      dprint("Error in Get result exams ...");
      dprint(e.toString());
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is dio.DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
      dprint(error);
    } finally {
      loading(false);
    }
  }

  Future updateDegreeById() async {
    dprint("update degree request ...");
    try {
      loading(true);
      final currentScore = int.parse(degreeController.text);
      final currentId = examResultIdSelected.value;
      late dio.Response<dynamic> res;

      if (currentId.startsWith("new_")) {
        final realStudentId = currentId.replaceFirst("new_", "");
        var data = {
          "ExamResults": [
            {
              "score": currentScore,
              "notes": "",
              "studentId": realStudentId,
              "examSectionId": examSectionIdSelected.value,
            },
          ],
        };
        res = await _apiService.post(
          url: ApiUrls.teacherExamResultUrl,
          body: data,
        );
      } else {
        var data = {"score": currentScore};
        res = await _apiService.patch(
          url: "${ApiUrls.teacherExamResultUrl}/$currentId",
          body: data,
        );
        if (res.data == null) {
          throw Exception();
        }
      }

      if (res.statusCode == 201 || res.statusCode == 200) {
        Get.snackbar(
          AppLanguage.success.tr,
          AppLanguage.degreeUpdatedSuccessfullyStr.tr,
        );
      }
      await getTeacherResultExams(examSectionIdSelected.value);
      DeviceUtils.hideKeyboard();
    } catch (e) {
      dprint("Error in update degree ...");
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is dio.DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      loading(false);
    }
  }

  Future getStudentNotHaveDegress() async {
    loading(true);
    try {
      final res = await _apiService.get(
        url: ApiUrls.studentNotHaveDegreesUrl,
        queryParameters: {"examSectionId": examSectionIdSelected.value},
      );

      studentNotHaveDegrees.value = List<StudentModel>.from(
        res.data.map((e) => StudentModel.fromJson(jsonEncode(e))),
      );
    } catch (e) {
      dprint("Error in Get student not have degrees request ...");
      dprint(e.toString());
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is dio.DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      loading(false);
    }
  }

  Future addStudentDegrees(int score, String note) async {
    loading(true);

    var data;
    if (examResults.isEmpty) {
      data = {
        "ExamResults": [
          {
            "score": score,
            "notes": note,
            "studentId": studentId.value,
            "examSectionId": examSectionIdSelected.value,
          },
        ],
      };
    } else {
      data = {"ExamResults": examResults};
    }

    try {
      await _apiService.post(url: ApiUrls.teacherExamResultUrl, body: data);
      examResults.clear();
      Get.back();
      await getStudentNotHaveDegress();
      await getTeacherResultExams(examSectionIdSelected.value);
    } catch (e) {
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is dio.DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      loading(false);
    }
  }

  @override
  void onClose() {
    degreeController.dispose();
    super.onClose();
  }
}
