import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' hide MultipartFile, FormData;
import 'package:dio/dio.dart' as dio show MultipartFile, FormData;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/failures.dart';
import 'package:noon/core/function.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/class_model.dart';
import 'package:noon/models/exam_model.dart';
import 'package:noon/models/exam_data_model.dart';
import 'package:noon/models/exam_section_model.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/models/serializers.dart';
import 'package:noon/models/stage_model.dart';
import 'package:noon/models/teacher_subject_model.dart';
import 'package:noon/view/widget/alert_dialogs.dart';

class TeacherExamsController extends GetxController {
  final ApiService _api = ApiService();

  final exams = <ExamModel>[].obs;
  final allExams = <ExamDataModel>[].obs;
  final filteredExams = <ExamDataModel>[].obs;
  final examTypeFilter = Rxn<String>(null);

  final loading = false.obs; // للتحميل الشامل
  final isFetchingDropdowns =
      false.obs; // 🔹 مخصص فقط لجلب البيانات من دون إعادة تحميل واجهة التطبيق
  var lastSnackbarTime = DateTime.now().subtract(const Duration(seconds: 5));

  void showSnackbarOnce(String title, String message) {
    if (DateTime.now().difference(lastSnackbarTime).inSeconds > 5) {
      Get.snackbar(title, message);
      lastSnackbarTime = DateTime.now();
    }
  }

  final stages = <Stage>[].obs;
  final stageValue = Rxn<Stage>(null);

  final classes = <ClassInfo>[].obs;
  final classValue = Rxn<ClassInfo>(null);

  final sections = <Section>[].obs;
  final sectionValue = Rxn<Section>(null);
  final selectedSectionIds = <String>[].obs;

  final subjects = <TeacherSubject>[].obs;
  final subjectValue = Rxn<TeacherSubject>(null);

  /// 🔹 معالجة مشكلة التكرار والتقاطع:
  /// تم تحسين هذا الجزء ليفلتر المواد ويظهر فقط تلك "المشتركة" بين جميع الشعب المحددة.
  /// إذا تم اختيار أكثر من شعبة، ستظهر المادة مرة واحدة فقط بشرط أن يكون الأستاذ مسؤولاً عنها في كل تلك الشعب.
  List<TeacherSubject> get filteredSubjects {
    if (selectedSectionIds.isEmpty) return [];

    final selectedIds = selectedSectionIds.toSet();

    // Group subjects by their shared StageSubjectId to identify common subjects across sections
    final Map<String, List<TeacherSubject>> groupedByStageSubjectId = {};
    for (var sub in subjects) {
      final ssId = sub.stageSubjectId;
      if (ssId != null) {
        groupedByStageSubjectId.putIfAbsent(ssId, () => []).add(sub);
      }
    }

    final List<TeacherSubject> commonSubjects = [];
    for (var entries in groupedByStageSubjectId.values) {
      final subSectionIds = entries.map((e) => e.section?.id).toSet();

      // Only include the subject if it exists in ALL currently selected sections
      if (selectedIds.every((id) => subSectionIds.contains(id))) {
        // Return a single representative TeacherSubject object for this subject
        commonSubjects.add(entries.first);
      }
    }

    return commonSubjects;
  }

  // 🔹 التعديل الجوهري: فلترة المواد المعروضة بناءً على 'الشعبة' المحددة حصراً لتجنب ظهور مواد لشعب أخرى.
  List<TeacherSubject> get filteredSubjectsForFilter {
    if (sectionValue.value == null) {
      // Return a deduplicated list of subjects when no section is selected for searching
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
        return sectionValue.value?.id == subSectionId;
      }
      return false;
    }).toList();
  }

  final selectedDate = AppLanguage.selectDateStr.tr.obs;

  final contentController = TextEditingController();
  final scoreController = TextEditingController();
  final examTypeNameController = TextEditingController();

  final examTypes = <ExamType>[].obs;
  final selectedExamType = Rxn<ExamType>(null);

  final isFormValid = false.obs;

  final pdfFile = Rxn<File>(null);

  @override
  void onInit() {
    super.onInit();
    getTeacherStage();
    getExamTypes();
    fetchExams();
    contentController.addListener(_onFormTextChanged);
    scoreController.addListener(_onFormTextChanged);
  }

  Future pickDate() async {
    final d = await pickDateMethode();
    if (d != null) {
      selectedDate.value = '${d.year}-${d.month}-${d.day}';
    }
  }

  Future<void> pickPdfFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: .custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        pdfFile.value = File(result.files.single.path!);
      }
    } catch (e) {
      Get.snackbar(
        AppLanguage.errorStr.tr,
        AppLanguage.unexpectedErrorStr.tr,
        backgroundColor: AppColors.redColor,
        colorText: Colors.white,
      );
    }
  }

  void removePdfFile() {
    pdfFile.value = null;
  }

  void _onFormTextChanged() {
    updateFormValidity();
  }

  void toggleSectionSelection(String id) {
    if (selectedSectionIds.contains(id)) {
      selectedSectionIds.remove(id);
    } else {
      selectedSectionIds.add(id);
    }
    selectedSectionIds.refresh();
    if (subjectValue.value != null &&
        !filteredSubjects.contains(subjectValue.value)) {
      subjectValue.value = null;
    }
    updateFormValidity();
  }

  void setSectionChecked(String id, bool checked) {
    final isSelected = selectedSectionIds.contains(id);
    if (checked && !isSelected) {
      selectedSectionIds.add(id);
      selectedSectionIds.refresh();
    } else if (!checked && isSelected) {
      selectedSectionIds.remove(id);
      selectedSectionIds.refresh();
    }
    if (subjectValue.value != null &&
        !filteredSubjects.contains(subjectValue.value)) {
      subjectValue.value = null;
    }
    updateFormValidity();
  }

  Future getTeacherStage() async {
    isFetchingDropdowns(true);
    try {
      final res = await _api.get(url: ApiUrls.teacherStageUrl);
      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }
      stages.value = List.from(
        res.data.map((e) => Stage.fromJson(jsonEncode(e))),
      );
    } catch (e) {
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      isFetchingDropdowns(false);
    }
  }

  Future getTeacherClass(String? stageId) async {
    isFetchingDropdowns(true);
    try {
      final res = await _api.get(url: '${ApiUrls.teacherClassUrl}/$stageId');
      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }
      classes.value = List.from(
        res.data.map((e) => ClassInfo.fromJson(jsonEncode(e))),
      );
    } catch (e) {
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      isFetchingDropdowns(false);
    }
  }

  Future getTeacherSection(String? classId) async {
    isFetchingDropdowns(true);
    try {
      final res = await _api.get(url: '${ApiUrls.teacherSectionUrl}/$classId');
      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }
      sections.value = List.from(
        res.data.map((e) => Section.fromJson(jsonEncode(e))),
      );
    } catch (e) {
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      isFetchingDropdowns(false);
    }
  }

  Future getTeacherSubject(String? classId) async {
    isFetchingDropdowns(true);
    try {
      final res = await _api.get(
        url: '${ApiUrls.teacherOwnSubjectUrl}/$classId',
      );
      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }
      subjects.value = List.from(
        res.data.map((e) => TeacherSubject.fromJson(jsonEncode(e))),
      );
    } catch (e) {
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      isFetchingDropdowns(false);
    }
  }

  Future getExamTypes() async {
    isFetchingDropdowns(true);
    try {
      final res = await _api.get(url: ApiUrls.teacherExamTypeUrl);
      if (res.statusCode != 200 && res.statusCode != 201) {
        throw Exception();
      }
      examTypes.value = List.from(
        res.data['data'].map(
          (e) => serializers.deserializeWith(ExamType.serializer, e),
        ),
      );
    } catch (e) {
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      isFetchingDropdowns(false);
    }
  }

  Future<void> fetchExams() async {
    try {
      loading.value = true;
      final response = await _api.get(url: ApiUrls.teacherExamsUrl);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] as Map<String, dynamic>;

        final List<ExamDataModel> examsList = [];
        data.forEach((examTypeName, examsArray) {
          if (examsArray is List) {
            for (var examJson in examsArray) {
              if (examJson is Map) {
                // 🔹 التعديل الذكي الأخير:
                // بما أن الخادم (API) يُرجع نوع الامتحان فقط ضمن مفتاح الأب (examTypeName) ولا يُضمّنه داخلياً
                // قمنا بحقنه برمجياً داخل الكائن JSON ليتسنى لدالة الفلترة التعرف عليه وتطبيقه.
                if (examJson['examSections'] != null &&
                    examJson['examSections'] is List) {
                  for (var section in (examJson['examSections'] as List)) {
                    if (section is Map) {
                      section['Exam'] ??= {};
                      section['Exam']['ExamType'] ??= {};
                      section['Exam']['ExamType']['name'] = examTypeName;
                    }
                  }
                }
              }

              final exam = serializers.deserializeWith(
                ExamDataModel.serializer,
                examJson,
              );
              if (exam != null) {
                examsList.add(exam);
              }
            }
          }
        });

        allExams.value = examsList;
        applyFilters();
      }
    } catch (e) {
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      loading.value = false;
    }
  }

  void applyFilters() {
    filteredExams.value = allExams.where((exam) {
      if (examTypeFilter.value != null && examTypeFilter.value!.isNotEmpty) {
        // 🔹 1. فلترة دقيقة لنوع الامتحان بالاعتماد على القيم المحقونة من السيرفر
        final examSection = exam.examSections.firstOrNull;
        final examTypeName = examSection?.exam?.examType?.name;
        if (examTypeName?.trim().toLowerCase() !=
            examTypeFilter.value?.trim().toLowerCase()) {
          return false;
        }
      }

      if (stageValue.value != null) {
        // 🔹 2. فلترة المرحلة
        final examStageId = exam.stageSubject.stage?.id?.toString();
        final selectedStageId = stageValue.value?.id?.toString();
        if (examStageId != selectedStageId) {
          return false;
        }
      }

      if (classValue.value != null) {
        final examClassId = exam.stageSubject.classDetail?.id?.toString();
        final selectedClassId = classValue.value?.id?.toString();
        if (examClassId != selectedClassId) {
          return false;
        }
      }

      if (subjectValue.value != null) {
        // Since StageSubject (from teacher_subject_model) only has subject and stage getters,
        // we match using the subject ID.
        final selectedSubjectId = subjectValue.value?.stageSubject?.subject?.id
            ?.toString();

        final examSubjectId = exam.stageSubject.subject?.id?.toString();

        if (examSubjectId != selectedSubjectId && selectedSubjectId != null) {
          return false;
        }
      }

      if (sectionValue.value != null) {
        // An exam can be assigned to multiple sections, check if it contains the selected section
        bool matchesSection = exam.examSections.any(
          (sec) =>
              sec.section?.id?.toString() == sectionValue.value?.id?.toString(),
        );
        if (!matchesSection) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void onExamTypeFilterChanged(String? value) {
    examTypeFilter.value = value;
    applyFilters();
  }

  void onStageChanged(Stage? value, {bool triggerFilter = true}) {
    stageValue.value = value;
    classValue.value = null;
    sectionValue.value = null;
    subjectValue.value = null;
    classes.clear();
    sections.clear();
    subjects.clear();
    if (value?.id != null) {
      getTeacherClass(value!.id);
    }
    if (triggerFilter) applyFilters();
  }

  void onClassChanged(ClassInfo? value, {bool triggerFilter = true}) {
    classValue.value = value;
    sectionValue.value = null;
    subjectValue.value = null;
    sections.clear();
    subjects.clear();
    if (value?.id != null) {
      getTeacherSection(value?.id);
      getTeacherSubject(value?.id);
    }
    if (triggerFilter) applyFilters();
  }

  void onSectionChanged(Section? value, {bool triggerFilter = true}) {
    sectionValue.value = value;
    subjectValue.value = null;
    if (triggerFilter) applyFilters();
  }

  void onSubjectChanged(TeacherSubject? value) {
    subjectValue.value = value;
    applyFilters();
  }

  void clearFilters() {
    stageValue.value = null;
    classValue.value = null;
    subjectValue.value = null;
    examTypeFilter.value = null;
    classes.clear();
    subjects.clear();
    applyFilters();
  }

  Future<void> deleteExam(String examId) async {
    try {
      loading.value = true;
      final response = await _api.delete(
        url: '${ApiUrls.teacherExamsUrl}/$examId',
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        allExams.removeWhere((exam) => exam.id == examId);
        applyFilters();

        Get.snackbar(
          AppLanguage.success.tr,
          AppLanguage.processSucceededStr.tr,
        );
      }
    } catch (e) {
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> updateExam(String examId, Map<String, dynamic> data) async {
    try {
      loading.value = true;
      final response = await _api.patch(
        url: '${ApiUrls.teacherExamsUrl}/$examId',
        body: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchExams();

        Get.snackbar(
          AppLanguage.success.tr,
          AppLanguage.processSucceededStr.tr,
        );
      }
    } catch (e) {
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      loading.value = false;
    }
  }

  Future createExamType() async {
    if (examTypeNameController.text.trim().isEmpty) return;
    loading(true);
    try {
      final res = await _api.post(
        url: ApiUrls.teacherExamTypeUrl,
        body: {"name": examTypeNameController.text.trim()},
      );
      dynamic data = res.data;
      String? id;
      if (data is Map && data['id'] is String) {
        id = data['id'];
      } else if (data is Map &&
          data['data'] is Map &&
          data['data']['id'] is String) {
        id = data['data']['id'];
      }
      if (id == null) {
        throw Exception();
      }
      await getExamTypes();
      final newItem = examTypes.firstWhereOrNull((e) => e.id == id);
      if (newItem != null) {
        selectedExamType.value = newItem;
      }
      examTypeNameController.clear();
      Get.back();
    } catch (e) {
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
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

  Future createExam() async {
    if (subjectValue.value == null || selectedExamType.value == null) return;
    loading(true);
    try {
      dio.MultipartFile? pdfMultipartFile;
      if (pdfFile.value != null) {
        pdfMultipartFile = await dio.MultipartFile.fromFile(
          pdfFile.value!.path,
          filename: pdfFile.value!.path.split('/').last,
        );
      }

      final formData = dio.FormData.fromMap({
        "content": contentController.text.trim(),
        "score": int.tryParse(scoreController.text.trim()) ?? 0,
        "stageSubjectId": subjectValue.value!.stageSubjectId,

        // Removed erroneous assignment of `subSubjectId` from `subject.id`.
        // A Subject ID was violating the Sub-Subject Foreign Key constraint.
        "examTypeId": selectedExamType.value!.id,
        "ExamSection": selectedSectionIds
            .map((sid) => {"examDate": selectedDate.value, "sectionId": sid})
            .toList(),
        if (pdfMultipartFile != null) "url": pdfMultipartFile,
      });

      await _api.post(url: ApiUrls.teacherExamsUrl, body: formData);
      successDialog(
        title: AppLanguage.processSucceededStr.tr,
        press: () {
          clearForm();
          Get.back(); // close dialog
          Get.back(); // close create exam screen
        },
      );
    } catch (e) {
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
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

  void clearForm() {
    contentController.clear();
    scoreController.clear();
    examTypeNameController.clear();
    selectedExamType.value = null;
    selectedDate('تحديد تاريخ');
    selectedSectionIds.clear();
    stageValue.value = null;
    stages.clear();
    classes.clear();
    classValue(null);
    sections.clear();
    sectionValue(null);
    subjects.clear();
    subjectValue(null);
    pdfFile.value = null;
    updateFormValidity();
    getTeacherStage();
  }

  @override
  void onClose() {
    contentController.dispose();
    scoreController.dispose();
    examTypeNameController.dispose();
    super.onClose();
  }

  void updateFormValidity() {
    isFormValid.value =
        stageValue.value != null &&
        classValue.value != null &&
        subjectValue.value != null &&
        selectedExamType.value != null &&
        selectedSectionIds.isNotEmpty &&
        contentController.text.trim().isNotEmpty &&
        scoreController.text.trim().isNotEmpty;
  }
}
