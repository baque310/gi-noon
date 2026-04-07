import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/failures.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/behaviors/behavior.dart';
import 'package:noon/models/behaviors/behavior_section.dart';
import 'package:noon/models/behaviors/behavior_type.dart';
import 'package:noon/models/class_model.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/models/stage_model.dart';
import 'package:noon/models/student_enrollment_model.dart';
import 'package:noon/models/teacher_subject_model.dart';
import 'package:noon/models/teaching_staff_model.dart';
import 'package:noon/view/widget/alert_dialogs.dart';
import 'package:s_extensions/s_extensions.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/models/behaviors/behavior_draft.dart';

class BehaviorController extends GetxController {
  var lastSnackbarTime = DateTime.now() - 5.sec;

  final loading = false.obs;
  final selectAll = false.obs;

  final stages = <Stage>[].obs;
  final classes = <ClassInfo>[].obs;
  final sections = <Section>[].obs;
  final subjects = <TeacherSubject>[].obs;
  final allSections = <Section>[];
  final allSubjects = <TeacherSubject>[];
  final studentSubjects = <TeacherSubject>[].obs;
  final students = <StudentEnrollmentModel>[].obs;
  final behaviors = <BehaviorModel>[].obs;

  final selectedStage = Rxn<Stage>(null);
  final selectedClass = Rxn<ClassInfo>(null);
  final selectedSection = Rxn<Section>(null);
  final selectedSubject = Rxn<TeacherSubject>(null);
  final selectedStudentSubject = Rxn<TeacherSubject>(null);

  final sectionId = Rxn<String>(null);
  final searchQuery = ''.obs;

  final _apiService = ApiService();

  final selectedStudents = <StudentEnrollmentModel>{}.obs;

  static DateTime _getSunday() {
    final now = DateTime.now();
    final daysToSubtract = now.weekday == 7 ? 0 : now.weekday;
    return DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: daysToSubtract));
  }

  late final startDate = _getSunday().obs;
  late final endDate = _getSunday().add(const Duration(days: 6)).obs;

  final behaviorSections = <BehaviorSectionModel>[].obs;
  final behaviorTypes = <BehaviorTypeModel>[].obs;
  final sectionRatings =
      <String, int>{}.obs; // behaviorSectionId -> selected type index
  final behaviorDrafts = <String, BehaviorDraft>{}.obs;
  final currentStudentId = RxnString(null); // null means "All Students"
  final notesController = TextEditingController();
  final sheetLoading = false.obs;

  final gController = Get.find<GlobalController>();

  @override
  void onInit() {
    super.onInit();
    if (gController.isTeacher) getTeacherStage();
    if (gController.isStudent || gController.isParent) fetchStudentSubjects();
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  Future<void> fetchStudentSubjects() async {
    bool isStudent = gController.isStudent;
    dprint("Fetching student subjects ...");
    loading.value = true;
    try {
      final res = await _apiService.get(
        url: isStudent
            ? ApiUrls.teachingStaffUrl
            : '${ApiUrls.teachingStaffForParentUrl}/${gController.selectedStudentIdForParent.value}',
        queryParameters: {'skip': 1, 'take': 200},
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data['data'];

        studentSubjects.value = List<TeacherSubject>.from(
          (data as List).expand(
            (e) => TeachingStaffModel.fromMap(e).teacherSubject ?? [],
          ),
        );
      }

      dprint("Total student subjects found: ${studentSubjects.length}");
    } catch (e) {
      dprint("Error fetching student subjects: $e");
    } finally {
      loading.value = false;
    }
  }

  void toggleSelectedSubject(TeacherSubject? v) {
    selectedStudentSubject.value = v;
    getStudentBehavior();
  }

  Future<void> getStudentBehavior() async {
    bool isStudent = gController.isStudent;
    dprint("Get student behavior ...");
    loading.value = true;
    try {
      final body = <String, dynamic>{
        'skip': 1,
        'take': 20,
        // Removed fromDate and toDate so parents/students see all latest behaviors
        'teacherSubjectId': selectedStudentSubject.value?.id,
      };

      final res = await _apiService.get(
        url: isStudent
            ? ApiUrls.studentBehaviorsUrl
            : '${ApiUrls.parentBehaviorsUrl}/${gController.selectedStudentIdForParent.value}',
        queryParameters: body,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data['data'] is Map
            ? res.data['data']['data']
            : res.data['data'];

        final list = List<BehaviorModel>.from(
          data.map((e) => BehaviorModel.fromJson(e)),
        );
        list.sort((a, b) => b.fromDate.compareTo(a.fromDate));
        behaviors.value = list;
      } else {
        dprint("Error in Get student behavior ...");
        dprint(res.data);
        String error = AppLanguage.unexpectedErrorStr.tr;
        if (res.data is Map) {
          error = res.data['message'] ?? error;
        }
        showExceptionAlertDialog(
          title: AppLanguage.errorStr.tr,
          exception: error,
        );
      }
    } catch (e) {
      dprint("Error in Get student behavior ...");
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
      loading.value = false;
    }
  }

  Future<void> selectDateRange() async {
    final picked = await showDateRangePicker(
      context: Get.context!,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      saveText: AppLanguage.saveStr.tr,
      initialDateRange: DateTimeRange(
        start: startDate.value,
        end: endDate.value,
      ),
      builder: (context, child) {
        return Theme(
          data: BuildContextExt(context).theme.copyWith(
            appBarTheme: BuildContextExt(context).theme.appBarTheme.copyWith(
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                textStyle: AppTextStyles.bold16,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      startDate.value = picked.start;
      endDate.value = picked.end;
      await getTeacherStudents(selectedSection.value?.id);
    }
  }

  void toggleStudent(StudentEnrollmentModel student) {
    if (selectedStudents.contains(student)) {
      selectedStudents.remove(student);
      selectAll.value = false;
    } else {
      selectedStudents.add(student);
      if (selectedStudents.length == filteredStudents.length) {
        selectAll.value = true;
      }
    }
  }

  void toggleSelectAll() {
    selectAll.value = !selectAll.value;
    if (selectAll.value) {
      selectedStudents.addAll(filteredStudents);
    } else {
      selectedStudents.clear();
    }
  }

  bool hasBehavior(String enrollmentId) {
    return behaviors.any((b) => b.studentEnrollmentId == enrollmentId);
  }

  Future getTeacherStudents(String? sectionId) async {
    dprint("Get teacher student enrollment ...");
    loading.value = true;
    selectedStudents.clear();
    selectAll.value = false;
    try {
      final res = await _apiService.get(
        url: '${ApiUrls.teacherStudentEnrollmentUrl}/$sectionId',
      );

      if (res.statusCode == 200) {
        students.value = List<StudentEnrollmentModel>.from(
          res.data.map((s) => StudentEnrollmentModel.fromJson(jsonEncode(s))),
        );
        await fetchBehaviors();
      } else {
        dprint("Error in Get teacher student enrollment ...");
        dprint(res.data);
        String error = AppLanguage.unexpectedErrorStr.tr;
        if (res.data is Map) {
          error = res.data['message'] ?? error;
        }
        showExceptionAlertDialog(
          title: AppLanguage.errorStr.tr,
          exception: error,
        );
      }
    } catch (e) {
      dprint("Error in Get teacher student enrollment ...");
      dprint(e.toString());
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is dio.DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      dprint(error);
    } finally {
      loading.value = false;
    }
  }

  List<StudentEnrollmentModel> get filteredStudents {
    if (searchQuery.value.isEmpty) {
      return students;
    }

    return students
        .where(
          (s) => s.student.fullName.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ),
        )
        .toList();
  }

  Future fetchBehaviors() async {
    dprint("Fetching behaviors ...");
    try {
      behaviors.clear();
      int page = 1;
      bool hasMore = true;
      while (hasMore) {
        final queryParams = {
          'skip': page,
          'take': 20,
          'sortBy': 'createdAt',
          'sortDirection': 'asc',
          'teacherSubjectId': selectedSubject.value?.id,
          'sectionId': selectedSection.value?.id,
          'fromDate': startDate.value.formatYearMonthDay,
          'toDate': endDate.value.formatYearMonthDay,
        };

        final res = await _apiService.get(
          url: ApiUrls.teacherBehaviorsUrl,
          queryParameters: queryParams,
        );

        if (res.statusCode == 200 || res.statusCode == 201) {
          final list = List<BehaviorModel>.from(
            res.data['data'].map((s) => BehaviorModel.fromJson(s)),
          );
          behaviors.addAll(list);
          if (list.length < 100) {
            hasMore = false;
          } else {
            page++;
          }
        } else {
          hasMore = false;
        }
      }
    } catch (e) {
      dprint("Error fetching behaviors: $e");
    }
  }

  Future getTeacherSubject(String? classId) async {
    loading(true);
    try {
      final res = await _apiService.get(
        url: '${ApiUrls.teacherOwnSubjectUrl}/$classId',
      );

      final list = List<TeacherSubject>.from(
        res.data.map((s) => TeacherSubject.fromJson(jsonEncode(s))),
      );
      allSubjects
        ..clear()
        ..addAll(list);
      subjects.value = list;
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

  Future getTeacherSection(String? classId) async {
    loading(true);
    try {
      final res = await _apiService.get(
        url: '${ApiUrls.teacherSectionUrl}/$classId',
      );
      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }
      final list = List<Section>.from(
        res.data.map((s) => Section.fromJson(jsonEncode(s))),
      );
      allSections
        ..clear()
        ..addAll(list);
      sections.value = list;
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

  Future getTeacherClass(String stageId) async {
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

  Future getTeacherStage() async {
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
      dprint("Error in Get stage ......");
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

  void setSubject(TeacherSubject? s) {
    selectedSubject.value = s;
    if (s != null && s.section != null) {
      final matchedSection = allSections
          .where((sec) => sec.id == s.section!.id)
          .toList();
      sections.value = matchedSection;
      if (matchedSection.length == 1) {
        selectedSection.value = matchedSection.first;
        sectionId.value = matchedSection.first.id;
      } else if (selectedSection.value != null &&
          selectedSection.value!.id != s.section!.id) {
        selectedSection.value = null;
        sectionId.value = null;
      }
    } else {
      selectedSection.value = null;
      sectionId.value = null;
      sections.value = List.from(allSections);
    }
  }

  void setSection(Section? s) {
    selectedSection.value = s;
    sectionId.value = s?.id;
    if (s != null) {
      selectedSubject.value = null;
      subjects.value = allSubjects
          .where((sub) => sub.section?.id == s.id)
          .toList();
    } else {
      subjects.value = List.from(allSubjects);
    }
  }

  void setClass(ClassInfo? c) {
    selectedClass.value = c;
  }

  void setStage(Stage? s) {
    selectedStage.value = s;
  }

  void showSnackbarOnce(String title, String message) {
    if (DateTime.now().difference(lastSnackbarTime).inMilliseconds >= 5000) {
      Get.snackbar(title, message);
      lastSnackbarTime = DateTime.now();
    }
  }

  void resetBehaviorSheet() {
    sectionRatings.clear();
    behaviorDrafts.clear();
    currentStudentId.value = null;
    for (final section in behaviorSections) {
      sectionRatings[section.id] = 0;
    }
    notesController.clear();
  }

  void setCurrentStudent(String? studentId) {
    currentStudentId.value = studentId;
    if (studentId == null) {
      // If switching to "All", maybe clear notes or show common notes?
      // For simplicity, let's clear notes controller to avoid confusion,
      // or set it to the first student's notes if all are same?
      // Let's keep it simple: clear if mixed, or show empty.
      // But if we want batch edit, we might want to start fresh or keep previous batch value.
      // Let's just clear for now to avoid complexity of "mixed" state content.
      notesController.text = '';
    } else {
      final draft = behaviorDrafts[studentId];
      if (draft != null) {
        notesController.text = draft.notes;
      }
    }
  }

  void updateRating(String sectionId, int index) {
    if (currentStudentId.value == null) {
      // Batch update all
      for (final draft in behaviorDrafts.values) {
        draft.ratings[sectionId] = index;
      }
      // Update UI state leader to reflect change
      sectionRatings[sectionId] = index;
    } else {
      // Update single student
      final draft = behaviorDrafts[currentStudentId.value];
      if (draft != null) {
        draft.ratings[sectionId] = index;
        behaviorDrafts.refresh(); // Trigger observable update
      }
    }
  }

  void updateNotes(String text) {
    if (currentStudentId.value == null) {
      // Batch update all
      for (final draft in behaviorDrafts.values) {
        draft.notes = text;
      }
    } else {
      // Update single student
      final draft = behaviorDrafts[currentStudentId.value];
      if (draft != null) {
        draft.notes = text;
      }
    }
  }

  int getRating(String sectionId) {
    if (currentStudentId.value == null) {
      return sectionRatings[sectionId] ?? 0;
    } else {
      final draft = behaviorDrafts[currentStudentId.value];
      return draft?.ratings[sectionId] ?? 0;
    }
  }

  Future<void> fetchBehaviorSections() async {
    try {
      final res = await _apiService.get(url: ApiUrls.teacherBehaviorSectionUrl);
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data is List ? res.data : (res.data['data'] ?? []);
        behaviorSections.value = List<BehaviorSectionModel>.from(
          data.map((s) => BehaviorSectionModel.fromJson(s)),
        );
      }
    } catch (e) {
      dprint("Error fetching behavior sections: $e");
    }
  }

  Future<void> fetchBehaviorTypes() async {
    try {
      final res = await _apiService.get(
        url: ApiUrls.teacherBehaviorTypeUrl,
        queryParameters: {'sortBy': 'order', 'sortDirection': 'asc'},
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data is List ? res.data : (res.data['data'] ?? []);
        behaviorTypes.value = List<BehaviorTypeModel>.from(
          data.map((t) => BehaviorTypeModel.fromJson(t)),
        );
      }
    } catch (e) {
      dprint("Error fetching behavior types: $e");
    }
  }

  Future<void> loadBehaviorSheetData() async {
    sheetLoading.value = true;
    await Future.wait([fetchBehaviorSections(), fetchBehaviorTypes()]);
    resetBehaviorSheet();

    // Initialize drafts for all selected students
    for (final student in selectedStudents) {
      final draft = BehaviorDraft(ratings: {});
      // Pre-fill default ratings (0)
      for (final section in behaviorSections) {
        draft.ratings[section.id] = 0;
      }

      // Check if existing behavior exists
      final existingBehavior = behaviors.firstWhereOrNull(
        (b) => b.studentEnrollmentId == student.id,
      );

      if (existingBehavior != null) {
        if (existingBehavior.evaluationItems.isNotEmpty) {
          for (final item in existingBehavior.evaluationItems) {
            final typeIndex = behaviorTypes.indexWhere(
              (t) => t.id == item.behaviorTypeId,
            );
            if (typeIndex != -1) {
              draft.ratings[item.behaviorSectionId] = typeIndex;
            }
          }
        }
        draft.notes = existingBehavior.notes;
      }
      behaviorDrafts[student.id] = draft;
    }

    // If only one student is selected, select them automatically
    if (selectedStudents.length == 1) {
      setCurrentStudent(selectedStudents.first.id);
    } else {
      // If multiple, stay on "All" (null), reset visually to 0
      notesController.clear();
      // Reset generic ratings for "All" view
      for (final section in behaviorSections) {
        sectionRatings[section.id] = 0;
      }
    }

    sheetLoading.value = false;
  }

  Future<void> submitBehavior() async {
    if (selectedStudents.isEmpty) return;

    loading.value = true;
    try {
      final notes = notesController.text.trim();

      final body = {
        'teacherSubjectId': selectedSubject.value?.id,
        'fromDate': startDate.value.formatYearMonthDay,
        'toDate': endDate.value.formatYearMonthDay,
        "notes": notes,
        'students': selectedStudents.map((e) {
          final draft = behaviorDrafts[e.id];
          final studentNotes = draft?.notes ?? '';
          final studentRatings = draft?.ratings ?? {};

          return {
            'studentEnrollmentId': e.id,
            'items': studentRatings.entries
                .where((e) => e.value >= 0 && e.value < behaviorTypes.length)
                .map(
                  (e) => {
                    'behaviorSectionId': e.key,
                    'behaviorTypeId': behaviorTypes[e.value].id,
                  },
                )
                .toList(),
            if (studentNotes.isNotEmpty) 'notes': studentNotes,
          };
        }).toList(),
      };

      final res = await _apiService.post(
        url: ApiUrls.teacherBehaviorsUrl,
        body: body,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.back();
        Get.snackbar("", AppLanguage.tureOperationStr.tr);
        resetBehaviorSheet();
        selectedStudents.clear();
        selectAll.value = false;
        await getTeacherStudents(selectedSection.value?.id);
      } else {
        String error = AppLanguage.unexpectedErrorStr.tr;
        if (res.data is Map) {
          error = res.data['message'] ?? error;
        }
        showExceptionAlertDialog(
          title: AppLanguage.errorStr.tr,
          exception: error,
        );
      }
    } catch (e) {
      dprint("Error in submit behavior ...");
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
      loading.value = false;
    }
  }
}
