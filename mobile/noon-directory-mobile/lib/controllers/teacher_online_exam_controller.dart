import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/failures.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/class_model.dart';
import 'package:noon/models/exam_section_model.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/models/serializers.dart';
import 'package:noon/models/stage_model.dart';
import 'package:noon/models/teacher_subject_model.dart';
import 'package:noon/view/widget/alert_dialogs.dart';

class TeacherOnlineExamController extends GetxController {
  final ApiService _api = ApiService();

  // ====== States ======
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final isFetchingDropdowns = false.obs;

  // ====== Exam List ======
  final exams = <Map<String, dynamic>>[].obs;
  final totalCount = 0.obs;
  final currentPage = 1.obs;
  final hasMore = true.obs;

  // ====== Filters (for list/archive) ======
  final stages = <Stage>[].obs;
  final stageValue = Rxn<Stage>(null);
  final classes = <ClassInfo>[].obs;
  final classValue = Rxn<ClassInfo>(null);
  final sections = <Section>[].obs;
  final sectionValue = Rxn<Section>(null);
  final subjects = <TeacherSubject>[].obs;
  final subjectValue = Rxn<TeacherSubject>(null);

  // ====== Create Exam Form ======
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final durationController = TextEditingController();
  final totalMarksController = TextEditingController();
  final passingMarksController = TextEditingController();

  final selectedExamType = 'MCQ'.obs; // MCQ or PAPER
  final shuffleQuestions = false.obs;
  final showResultImmediately = true.obs;

  final startDate = Rxn<DateTime>(null);
  final endDate = Rxn<DateTime>(null);

  // ====== Exam Type from Dashboard ======
  final examTypes = <ExamType>[].obs;
  final selectedDashboardExamType = Rxn<ExamType>(null);

  // ====== Teacher Subject Selection ======
  final createStages = <Stage>[].obs;
  final createStageValue = Rxn<Stage>(null);
  final createClasses = <ClassInfo>[].obs;
  final createClassValue = Rxn<ClassInfo>(null);
  final createSections = <Section>[].obs;
  final createSelectedSectionIds = <String>[].obs;
  final createSubjects = <TeacherSubject>[].obs;
  final createSubjectValue = Rxn<TeacherSubject>(null);

  // ====== MCQ Questions ======
  final mcqQuestions = <Map<String, dynamic>>[].obs;

  // ====== PDF Attachment ======
  final pdfFile = Rxn<File>(null);
  final attachmentFiles = <File>[].obs;

  // ====== Students ======
  final students = <Map<String, dynamic>>[].obs;
  final selectedStudentIds = <String>[].obs;
  final isSelectAllStudents = false.obs;

  // ====== Form Validity ======
  final isFormValid = false.obs;
  final currentStep = 0.obs;

  // ====== Exam Details ======
  final currentExam = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    fetchExamTypes();
    fetchStages();
    fetchCreateStages();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    durationController.dispose();
    totalMarksController.dispose();
    passingMarksController.dispose();
    super.onClose();
  }

  // ============================================
  // Fetch Exam Types from Dashboard
  // ============================================
  Future<void> fetchExamTypes() async {
    isFetchingDropdowns.value = true;
    try {
      final res = await _api.get(url: ApiUrls.teacherExamTypeUrl);
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data;
        if (data is Map && data['data'] is List) {
          final List rawList = data['data'] as List;
          final onlineTypes = rawList.where((e) => e['examMode'] == 'إلكتروني' || e['examMode'] == 'الكتروني').toList();
          examTypes.value = List.from(
            onlineTypes.map((e) {
               final map = Map<String, dynamic>.from(e);
               map.remove('examMode'); // Prevent built_value crash if not defined
               return serializers.deserializeWith(ExamType.serializer, map);
            }),
          );
        }
      }
    } catch (e) {
      dprint('Error fetching exam types: $e');
    } finally {
      isFetchingDropdowns.value = false;
    }
  }

  // ============================================
  // Fetch Online Exams for Teacher
  // ============================================
  Future<void> fetchExams({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      hasMore.value = true;
      exams.clear();
    }

    if (!hasMore.value) return;
    isLoading.value = true;

    try {
      final queryParams = <String, dynamic>{
        'skip': currentPage.value.toString(),
        'take': '20',
      };

      if (subjectValue.value?.id != null) {
        queryParams['teacherSubjectId'] = subjectValue.value!.id;
      }

      final res = await _api.get(
        url: ApiUrls.teacherOnlineExamsUrl,
        queryParameters: queryParams,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data;
        List<Map<String, dynamic>> newExams = [];

        if (data is Map && data['data'] is List) {
          newExams = List<Map<String, dynamic>>.from(data['data']);
          totalCount.value = data['totalCount'] ?? 0;
        } else if (data is List) {
          newExams = List<Map<String, dynamic>>.from(data);
        }

        if (refresh) {
          exams.value = newExams;
        } else {
          exams.addAll(newExams);
        }

        if (newExams.length < 20) {
          hasMore.value = false;
        } else {
          currentPage.value++;
        }
      }
    } catch (e) {
      dprint('Error fetching teacher online exams: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================
  // Fetch Exam Details
  // ============================================
  Future<void> fetchExamById(String id) async {
    isLoading.value = true;
    try {
      final res = await _api.get(url: '${ApiUrls.teacherOnlineExamsUrl}/$id');
      if (res.data is Map) {
        currentExam.value = Map<String, dynamic>.from(res.data);
      }
    } catch (e) {
      dprint('Error fetching exam details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================
  // Fetch Stages/Classes/Sections/Subjects (for filters)
  // ============================================
  Future<void> fetchStages() async {
    try {
      final res = await _api.get(url: ApiUrls.teacherStageUrl);
      if (res.statusCode == 200 || res.statusCode == 201) {
        stages.value = List.from(
          res.data.map((e) => Stage.fromJson(jsonEncode(e))),
        );
      }
    } catch (e) {
      dprint('Error fetching stages: $e');
    }
  }

  Future<void> fetchClasses(String stageId) async {
    isFetchingDropdowns.value = true;
    try {
      final res = await _api.get(url: '${ApiUrls.teacherClassUrl}/$stageId');
      if (res.statusCode == 200 || res.statusCode == 201) {
        classes.value = List.from(
          res.data.map((e) => ClassInfo.fromJson(jsonEncode(e))),
        );
      }
    } catch (e) {
      dprint('Error fetching classes: $e');
    } finally {
      isFetchingDropdowns.value = false;
    }
  }

  Future<void> fetchSections(String classId) async {
    isFetchingDropdowns.value = true;
    try {
      final res = await _api.get(url: '${ApiUrls.teacherSectionUrl}/$classId');
      if (res.statusCode == 200 || res.statusCode == 201) {
        sections.value = List.from(
          res.data.map((e) => Section.fromJson(jsonEncode(e))),
        );
      }
    } catch (e) {
      dprint('Error fetching sections: $e');
    } finally {
      isFetchingDropdowns.value = false;
    }
  }

  Future<void> fetchSubjects(String classId) async {
    isFetchingDropdowns.value = true;
    try {
      final res = await _api.get(
        url: '${ApiUrls.teacherOwnSubjectUrl}/$classId',
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        subjects.value = List.from(
          res.data.map((e) => TeacherSubject.fromJson(jsonEncode(e))),
        );
      }
    } catch (e) {
      dprint('Error fetching subjects: $e');
    } finally {
      isFetchingDropdowns.value = false;
    }
  }

  // ============================================
  // Create Exam Form - Stages/Classes/Sections/Subjects
  // ============================================
  Future<void> fetchCreateStages() async {
    try {
      final res = await _api.get(url: ApiUrls.teacherStageUrl);
      if (res.statusCode == 200 || res.statusCode == 201) {
        createStages.value = List.from(
          res.data.map((e) => Stage.fromJson(jsonEncode(e))),
        );
      }
    } catch (e) {
      dprint('Error fetching create stages: $e');
    }
  }

  Future<void> fetchCreateClasses(String stageId) async {
    isFetchingDropdowns.value = true;
    try {
      final res = await _api.get(url: '${ApiUrls.teacherClassUrl}/$stageId');
      if (res.statusCode == 200 || res.statusCode == 201) {
        createClasses.value = List.from(
          res.data.map((e) => ClassInfo.fromJson(jsonEncode(e))),
        );
      }
    } catch (e) {
      dprint('Error: $e');
    } finally {
      isFetchingDropdowns.value = false;
    }
  }

  Future<void> fetchCreateSections(String classId) async {
    isFetchingDropdowns.value = true;
    try {
      final res = await _api.get(url: '${ApiUrls.teacherSectionUrl}/$classId');
      if (res.statusCode == 200 || res.statusCode == 201) {
        createSections.value = List.from(
          res.data.map((e) => Section.fromJson(jsonEncode(e))),
        );
      }
    } catch (e) {
      dprint('Error: $e');
    } finally {
      isFetchingDropdowns.value = false;
    }
  }

  Future<void> fetchCreateSubjects(String classId) async {
    isFetchingDropdowns.value = true;
    try {
      final res = await _api.get(
        url: '${ApiUrls.teacherOwnSubjectUrl}/$classId',
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        createSubjects.value = List.from(
          res.data.map((e) => TeacherSubject.fromJson(jsonEncode(e))),
        );
      }
    } catch (e) {
      dprint('Error: $e');
    } finally {
      isFetchingDropdowns.value = false;
    }
  }

  // ============================================
  // Fetch Students for selected sections
  // ============================================
  Future<void> fetchStudentsForSections() async {
    if (createSelectedSectionIds.isEmpty) {
      students.clear();
      selectedStudentIds.clear();
      return;
    }

    isLoading.value = true;
    try {
      final allStudents = <Map<String, dynamic>>[];

      for (final sectionId in createSelectedSectionIds) {
        final res = await _api.get(
          url: ApiUrls.studentsList,
          queryParameters: {'sectionId': sectionId},
        );
        if (res.statusCode == 200 || res.statusCode == 201) {
          final data = res.data;
          if (data is List) {
            for (var s in data) {
              if (s is Map<String, dynamic>) {
                final studentId = s['Student']?['id'] ?? s['studentId'] ?? s['id'];
                if (studentId != null && !allStudents.any((e) => (e['Student']?['id'] ?? e['id']) == studentId)) {
                  allStudents.add(Map<String, dynamic>.from(s));
                }
              }
            }
          }
        }
      }

      students.value = allStudents;
      // Auto-select all students
      selectedStudentIds.value = allStudents.map((s) {
        return (s['Student']?['id'] ?? s['studentId'] ?? s['id']).toString();
      }).toList();
      isSelectAllStudents.value = true;
    } catch (e) {
      dprint('Error fetching students: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================
  // Toggle student selection
  // ============================================
  void toggleStudent(String studentId) {
    if (selectedStudentIds.contains(studentId)) {
      selectedStudentIds.remove(studentId);
    } else {
      selectedStudentIds.add(studentId);
    }
    isSelectAllStudents.value = selectedStudentIds.length == students.length;
  }

  void toggleAllStudents() {
    if (isSelectAllStudents.value) {
      selectedStudentIds.clear();
      isSelectAllStudents.value = false;
    } else {
      selectedStudentIds.value = students.map((s) {
        return (s['Student']?['id'] ?? s['studentId'] ?? s['id']).toString();
      }).toList();
      isSelectAllStudents.value = true;
    }
  }

  // ============================================
  // MCQ Question Management
  // ============================================
  void addMCQQuestion() {
    mcqQuestions.add({
      'questionText': '',
      'marks': 0,
      'optionA': '',
      'optionB': '',
      'optionC': '',
      'optionD': '',
      'correctAnswer': 'A',
      'imageUrl': null,
    });
  }

  void removeMCQQuestion(int index) {
    if (index >= 0 && index < mcqQuestions.length) {
      mcqQuestions.removeAt(index);
    }
  }

  void updateMCQQuestion(int index, String field, dynamic value) {
    if (index >= 0 && index < mcqQuestions.length) {
      mcqQuestions[index][field] = value;
      mcqQuestions.refresh();
    }
  }

  // ============================================
  // File Picking
  // ============================================
  Future<void> pickPdfFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      );
      if (result != null && result.files.single.path != null) {
        pdfFile.value = File(result.files.single.path!);
      }
    } catch (e) {
      dprint('Error picking file: $e');
    }
  }

  Future<void> pickAttachmentFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'doc', 'docx'],
        allowMultiple: true,
      );
      if (result != null) {
        attachmentFiles.addAll(
          result.files.where((f) => f.path != null).map((f) => File(f.path!)),
        );
      }
    } catch (e) {
      dprint('Error picking files: $e');
    }
  }

  void removeAttachmentFile(int index) {
    if (index >= 0 && index < attachmentFiles.length) {
      attachmentFiles.removeAt(index);
    }
  }

  // ============================================
  // Date Picking
  // ============================================
  Future<void> pickStartDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        startDate.value = DateTime(
          date.year, date.month, date.day, time.hour, time.minute,
        );
      }
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? (startDate.value ?? DateTime.now()),
      firstDate: startDate.value ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        endDate.value = DateTime(
          date.year, date.month, date.day, time.hour, time.minute,
        );
      }
    }
  }

  // ============================================
  // Filter handlers
  // ============================================
  void onStageChanged(Stage? value) {
    stageValue.value = value;
    classValue.value = null;
    sectionValue.value = null;
    subjectValue.value = null;
    classes.clear();
    sections.clear();
    subjects.clear();
    if (value?.id != null) fetchClasses(value!.id!);
  }

  void onClassChanged(ClassInfo? value) {
    classValue.value = value;
    sectionValue.value = null;
    subjectValue.value = null;
    sections.clear();
    subjects.clear();
    if (value?.id != null) {
      fetchSections(value!.id!);
      fetchSubjects(value.id!);
    }
  }

  void onSectionChanged(Section? value) {
    sectionValue.value = value;
  }

  void onSubjectChanged(TeacherSubject? value) {
    subjectValue.value = value;
  }

  // ============================================
  // Create form handlers
  // ============================================
  void onCreateStageChanged(Stage? value) {
    createStageValue.value = value;
    createClassValue.value = null;
    createSubjectValue.value = null;
    createClasses.clear();
    createSections.clear();
    createSubjects.clear();
    createSelectedSectionIds.clear();
    students.clear();
    selectedStudentIds.clear();
    if (value?.id != null) fetchCreateClasses(value!.id!);
  }

  void onCreateClassChanged(ClassInfo? value) {
    createClassValue.value = value;
    createSubjectValue.value = null;
    createSections.clear();
    createSubjects.clear();
    createSelectedSectionIds.clear();
    students.clear();
    selectedStudentIds.clear();
    if (value?.id != null) {
      fetchCreateSections(value!.id!);
      fetchCreateSubjects(value.id!);
    }
  }

  void toggleCreateSection(String sectionId) {
    if (createSelectedSectionIds.contains(sectionId)) {
      createSelectedSectionIds.remove(sectionId);
    } else {
      createSelectedSectionIds.add(sectionId);
    }
    createSelectedSectionIds.refresh();
    // Fetch students when sections change
    fetchStudentsForSections();
  }

  // ============================================
  // Create Online Exam
  // ============================================
  Future<void> createOnlineExam() async {
    if (createSubjectValue.value == null || selectedStudentIds.isEmpty || selectedDashboardExamType.value == null) {
      Get.snackbar(
        'تنبيه',
        'يرجى ملء جميع الحقول المطلوبة واختيار الطلاب',
        backgroundColor: AppColors.warningColor,
        colorText: Colors.white,
      );
      return;
    }

    isSubmitting.value = true;
    try {
      final formData = FormData.fromMap({
        'title': selectedDashboardExamType.value?.name ?? '',
        'description': descriptionController.text.trim(),
        'examType': selectedExamType.value,
        'duration': int.tryParse(durationController.text.trim()) ?? 60,
        'startDate': startDate.value?.toIso8601String() ?? DateTime.now().toIso8601String(),
        'endDate': endDate.value?.toIso8601String() ?? DateTime.now().add(const Duration(hours: 2)).toIso8601String(),
        'totalMarks': int.tryParse(totalMarksController.text.trim()) ?? 100,
        'passingMarks': int.tryParse(passingMarksController.text.trim()) ?? 50,
        'shuffleQuestions': shuffleQuestions.value ? 'TRUE' : 'FALSE',
        'showResultImmediately': showResultImmediately.value ? 'TRUE' : 'FALSE',
        'teacherSubjectId': createSubjectValue.value!.id,
        'studentIds': jsonEncode(selectedStudentIds.toList()),
      });

      // Add MCQ questions if exam type is MCQ
      if (selectedExamType.value == 'MCQ' && mcqQuestions.isNotEmpty) {
        final questionsJson = mcqQuestions.map((q) => {
          'questionText': q['questionText'],
          'marks': q['marks'],
          'optionA': q['optionA'],
          'optionB': q['optionB'],
          'optionC': q['optionC'],
          'optionD': q['optionD'],
          'correctAnswer': q['correctAnswer'],
        }).toList();
        formData.fields.add(MapEntry('questions', jsonEncode(questionsJson)));
      }

      // Add attachment files
      for (final file in attachmentFiles) {
        formData.files.add(MapEntry(
          'attachments',
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split(Platform.pathSeparator).last,
          ),
        ));
      }

      // Add PDF if exists
      if (pdfFile.value != null) {
        formData.files.add(MapEntry(
          'attachments',
          await MultipartFile.fromFile(
            pdfFile.value!.path,
            filename: pdfFile.value!.path.split(Platform.pathSeparator).last,
          ),
        ));
      }

      final res = await _api.post(
        url: ApiUrls.teacherOnlineExamsUrl,
        body: formData,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        successDialog(
          title: 'تم إنشاء الامتحان بنجاح',
          press: () {
            clearCreateForm();
            Get.back(); // close dialog
            Get.back(); // close create screen
            fetchExams(refresh: true);
          },
        );
      }
    } catch (e) {
      String error = 'حدث خطأ غير متوقع';
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
        final responseData = e.response?.data;
        if (responseData is Map && responseData['message'] != null) {
          error = responseData['message'].toString();
        }
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // ============================================
  // Delete Online Exam
  // ============================================
  Future<void> deleteExam(String examId) async {
    try {
      isLoading.value = true;
      final res = await _api.delete(
        url: '${ApiUrls.teacherOnlineExamsUrl}/$examId',
      );
      if (res.statusCode == 200 || res.statusCode == 204) {
        exams.removeWhere((e) => e['id'] == examId);
        Get.snackbar(
          AppLanguage.success.tr,
          'تم حذف الامتحان بنجاح',
          backgroundColor: AppColors.green400,
          colorText: Colors.white,
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
      isLoading.value = false;
    }
  }

  // ============================================
  // Grade Student Answer (Paper type)
  // ============================================
  Future<void> gradeAnswer(String answerId, double score, String feedback) async {
    try {
      isSubmitting.value = true;
      final res = await _api.patch(
        url: '${ApiUrls.teacherOnlineExamsUrl}/grade/$answerId',
        body: {
          'score': score,
          'feedback': feedback,
        },
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.snackbar(
          AppLanguage.success.tr,
          'تم تصحيح الإجابة بنجاح',
          backgroundColor: AppColors.green400,
          colorText: Colors.white,
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
      isSubmitting.value = false;
    }
  }

  // ============================================
  // Clear Form
  // ============================================
  void clearCreateForm() {
    titleController.clear();
    descriptionController.clear();
    durationController.clear();
    totalMarksController.clear();
    passingMarksController.clear();
    selectedExamType.value = 'MCQ';
    shuffleQuestions.value = false;
    showResultImmediately.value = true;
    startDate.value = null;
    endDate.value = null;
    createStageValue.value = null;
    createClassValue.value = null;
    createSubjectValue.value = null;
    createClasses.clear();
    createSections.clear();
    createSubjects.clear();
    createSelectedSectionIds.clear();
    mcqQuestions.clear();
    pdfFile.value = null;
    attachmentFiles.clear();
    students.clear();
    selectedStudentIds.clear();
    isSelectAllStudents.value = false;
    currentStep.value = 0;
    selectedDashboardExamType.value = null;
  }

  // ============================================
  // Helpers
  // ============================================
  String getExamStatus(Map<String, dynamic> exam) {
    final now = DateTime.now();
    final start = DateTime.tryParse(exam['startDate'] ?? '') ?? now;
    final end = DateTime.tryParse(exam['endDate'] ?? '') ?? now;
    if (now.isBefore(start)) return 'upcoming';
    if (now.isAfter(end)) return 'ended';
    return 'active';
  }

  int getSubmittedCount(Map<String, dynamic> exam) {
    final students = exam['OnlineExamStudent'] as List?;
    if (students == null) return 0;
    return students.where((s) {
      final status = s['status'];
      return status == 'SUBMITTED' || status == 'GRADED';
    }).length;
  }

  int getTotalStudents(Map<String, dynamic> exam) {
    return (exam['OnlineExamStudent'] as List?)?.length ?? 0;
  }

  int getQuestionCount(Map<String, dynamic> exam) {
    return (exam['OnlineExamQuestion'] as List?)?.length ?? 0;
  }
}
