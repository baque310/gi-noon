import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/controllers/profile_controller.dart';
import 'package:noon/controllers/student_controller.dart';
import 'package:noon/core/enum.dart' hide FileType;
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/models/attachment_model.dart';
import 'package:noon/models/homework_model.dart';
import '../core/constant/api_urls.dart';
import '../core/constant/screens_urls.dart';
import '../core/failures.dart';
import '../core/function.dart';
import '../core/localization/language.dart';
import '../data/api_services.dart';
import '../models/class_model.dart';
import '../models/homework_subject_model.dart';
import '../models/section_model.dart';
import '../models/stage_model.dart';
import '../models/teacher_subject_model.dart';
import '../view/widget/alert_dialogs.dart';
import '../core/constant/app_text_style.dart';
import '../core/constant/app_colors.dart';
import '../view/widget/loading_button.dart';
import 'package:image_picker/image_picker.dart';

typedef FileOrUrl = dynamic;

class HomeworkController extends GetxController {
  final studentController = Get.put(StudentController());

  RxBool loading = false.obs;
  RxBool isWaiting = false.obs;
  RxList<String> completedHomeworkIds = <String>[].obs;

  var lastSnackbarTime = DateTime.now().subtract(const Duration(seconds: 5));

  void showSnackbarOnce(String title, String message) {
    if (DateTime.now().difference(lastSnackbarTime).inSeconds > 5) {
      Get.snackbar(title, message);
      lastSnackbarTime = DateTime.now();
    }
  }

  // bool? isTeacher;

  //pagination sections
  final _subjectsPagingController = PagingController<int, HomeworkSubjectModel>(
    firstPageKey: 1,
  );
  final _teacherHomeworksPagingController =
      PagingController<int, HomeworkModel>(firstPageKey: 1);

  PagingController get pagingController => controller.isTeacher
      ? _teacherHomeworksPagingController
      : _subjectsPagingController;

  static const _pageSize = 15;
  final _apiService = ApiService();

  final titleController = TextEditingController();
  final descController = TextEditingController();

  var title = ''.obs;
  var description = ''.obs;

  //stage المرحلئ
  RxList<Stage> stages = <Stage>[].obs;
  Rxn<Stage> stageValue = Rxn<Stage>(null);

  //class الصف
  RxList<ClassInfo> classes = <ClassInfo>[].obs;
  Rxn<ClassInfo> classValue = Rxn<ClassInfo>(null);

  //section الشعبة
  RxList<Section> sections = <Section>[].obs;
  // Rxn<Section> sectionValue = Rxn<Section>(null); // Deprecated
  RxList<Section> selectedSections = <Section>[].obs;
  // Section? oldSectionValue; // Deprecated - tracked via list comparison if needed

  //subject المادة
  RxList<TeacherSubject> subjects = <TeacherSubject>[].obs;
  Rxn<TeacherSubject> subjectValue = Rxn<TeacherSubject>(null);

  /// 🔹 منطق الفلترة الذكي:
  /// قمت بتعديل هذا الجزء ليقوم بجلب المواد "المشتركة" فقط بين الشعب المختارة.
  /// إذا اختار المعلم (A و B)، سيقوم النظام بمقارنة المواد المشتركة وإظهارها (بدون تكرار)
  /// لضمان أن الواجب يُضاف لمادة يدرسها المعلم في كل الشعب المحددة.
  List<TeacherSubject> get filteredSubjects {
    if (selectedSections.isEmpty) return [];

    final selectedSectionIds = selectedSections.map((s) => s.id!).toSet();

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
      if (selectedSectionIds.every((id) => subSectionIds.contains(id))) {
        // Return a single representative TeacherSubject object for this subject
        commonSubjects.add(entries.first);
      }
    }

    return commonSubjects;
  }

  // Search Filters
  Rxn<Stage> searchStageValue = Rxn<Stage>(null);
  Rxn<ClassInfo> searchClassValue = Rxn<ClassInfo>(null);
  Rxn<Section> searchSectionValue = Rxn<Section>(null);
  Rxn<TeacherSubject> searchSubjectValue = Rxn<TeacherSubject>(null);
  RxString searchDate = ''.obs;

  //
  RxString selectedDate = 'تحديد تاريخ'.obs;

  //validation add homework
  RxBool get isFormValid =>
      ((title.isNotEmpty && title.value.trim() != '') &&
              (description.isNotEmpty && description.value.trim() != '') &&
              (subjectValue.value != null && selectedSections.isNotEmpty) &&
              selectedDate.value != 'تحديد تاريخ' &&
              studentController.selectedStudentsIds.isNotEmpty)
          .obs;

  //validation update homework
  RxBool get isFormValidEdit =>
      ((title.isNotEmpty && title.value.trim() != '') &&
              (description.isNotEmpty && description.value.trim() != '') &&
              (subjectValue.value != null && selectedSections.isNotEmpty) &&
              selectedDate.value != 'تحديد تاريخ' &&
              studentController.selectedStudentsIds.isNotEmpty)
          .obs;

  RxnString homeworkId = RxnString(null);
  RxnString sectionId = RxnString(null);

  final files = RxList<FileOrUrl>([]);

  final attachmentsIdsToRemoveFromServer = <String>[];

  final controller = Get.find<GlobalController>();
  final profileController = Get.find<ProfileController>();

  @override
  void onInit() {
    if (Get.find<GlobalController>().accountType == AccountType.teacher) {
      getTeacherStage();
    }
    pagingController.addPageRequestListener((pageKey) {
      getHomeworks(pageKey);
    });
    super.onInit();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  void pickDate() async {
    DateTime? pickedDate = await pickDateMethode();

    if (pickedDate != null) {
      selectedDate.value =
          '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
    }
  }

  void pickSearchDate() async {
    DateTime? pickedDate = await pickDateMethode();

    if (pickedDate != null) {
      searchDate.value =
          '${pickedDate.year}-${(pickedDate.month).toString().padLeft(2, '0')}-${(pickedDate.day).toString().padLeft(2, '0')}';
    } else {
      searchDate.value = '';
    }
  }

  Future getHomeworks(int pageKey) async {
    dprint("Get Homeworks ...");
    loading(true);
    try {
      final String url;
      if (controller.isStudent) {
        url = ApiUrls.studentHomeworksUrl;
      } else if (controller.isTeacher) {
        url = ApiUrls.teacherHomeworksUrl;
      } else {
        url =
            '${ApiUrls.parentHomeworksUrl}/${controller.selectedStudentIdForParent.value}';
      }

      double pageCount = (pageKey - 1) / _pageSize + 1;

      final Map<String, dynamic> queryParams = {
        "skip": pageCount,
        "take": _pageSize,
      };

      if (controller.isTeacher) {
        final res = await _apiService.get(
          url: url,
          queryParameters: {"skip": 1, "take": 1},
        );
        final hw = List<HomeworkModel>.from(
          res.data['data'].map((e) => HomeworkModel.fromJson(jsonEncode(e))),
        );

        if (searchDate.value.isNotEmpty) {
          queryParams['date'] = searchDate.value;
        }
        if (searchSectionValue.value != null) {
          queryParams['sectionId'] = searchSectionValue.value!.id;
        }
        if (searchSubjectValue.value != null) {
          queryParams['teacherSubjectId'] = searchSubjectValue.value!.id;
        }
        if (searchClassValue.value != null) {
          queryParams['schoolClassId'] = searchClassValue.value!.id;
        }
        if (hw.isNotEmpty) {
          queryParams['schoolYearId'] = hw.first.schoolYearId;
        }
      }

      final res = await _apiService.get(url: url, queryParameters: queryParams);

      late final List items;
      if (controller.isTeacher) {
        items = List<HomeworkModel>.from(
          res.data['data'].map((e) => HomeworkModel.fromJson(jsonEncode(e))),
        );
      } else {
        items = List<HomeworkSubjectModel>.from(
          res.data['data'].map(
            (e) => HomeworkSubjectModel.fromJson(jsonEncode(e)),
          ),
        );
      }

      final bool isLastPage = items.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(items);
      } else {
        final nextPageKey = pageKey + items.length;
        pagingController.appendPage(items, nextPageKey);
      }
    } catch (e) {
      dprint("Error in Get Homework ...");
      dprint(e.toString());
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      pagingController.error = error;
    } finally {
      loading(false);
    }
  }

  Future<HomeworkModel?> getHomeworkById(String id) async {
    try {
      final String url;
      if (controller.isStudent) {
        url = '${ApiUrls.studentHomeworksUrl}/$id';
      } else if (controller.isTeacher) {
        url = '${ApiUrls.teacherHomeworksUrl}/$id';
      } else {
        url =
            '${ApiUrls.parentHomeworksUrl}/$id/${controller.selectedStudentIdForParent.value}';
      }

      final res = await _apiService.get(url: url);
      dynamic data = res.data['data'] ?? res.data;

      if (data is List) {
        if (data.isEmpty) return null;
        data = data.first;
      }

      if (data == null || (data is Map && data.isEmpty)) return null;

      return HomeworkModel.fromJson(jsonEncode(data));
    } catch (e) {
      dprint("Error in Get Homework By Id ...");
      dprint(e.toString());
      rethrow;
    }
  }

  Future<List<HomeworkSubjectModel>> getHomeworksForTodayForStudent() async {
    dprint("Getting Homeworks for today ...");
    loading(true);
    try {
      final String url;
      if (controller.isStudent) {
        url = ApiUrls.studentHomeworksUrl;
      } else if (controller.isTeacher) {
        url = ApiUrls.teacherHomeworksUrl;
      } else {
        url =
            '${ApiUrls.parentHomeworksUrl}/${controller.selectedStudentIdForParent.value}';
      }

      final res = await _apiService.get(
        url: url,
        queryParameters: {
          "take": 50,
          "date": DateTime.now().formatDateToYearMonthDay,
          // "date": "2025-09-27",
        },
      );

      final items = List<HomeworkSubjectModel>.from(
        res.data['data'].map(
          (e) => HomeworkSubjectModel.fromJson(jsonEncode(e)),
        ),
      );
      return items;
    } catch (e) {
      dprint("Error in Get Homework ...");
      dprint(e.toString());
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      return Future.error(error);
    } finally {
      loading(false);
    }
  }

  Future addHomework() async {
    dprint("add new homework request ...");

    loading(true);
    try {
      final List<MultipartFile> attachments = [];
      if (files.isNotEmpty) {
        for (File p in files) {
          final file = await MultipartFile.fromFile(p.path);
          attachments.add(file);
        }
      }
      final formData = FormData.fromMap({
        "title": title.value,
        "content": description.value,
        "dueDate": selectedDate.value,
        "teacherSubjectId": subjectValue.value!.id,
        if (attachments.isNotEmpty) "attachments": attachments,
        "studentIds": studentController.selectedStudentsIds,
      });
      await _apiService.post(url: ApiUrls.teacherHomeworksUrl, body: formData);
      successDialog(
        title: AppLanguage.homeworkAddedSuccess.tr,
        press: () {
          clearPreviseData();
          Get.back(); // close dialog
          Get.back(); // close add homework screen
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

  Future editHomework() async {
    dprint("edit homework request ...");
    loading(true);
    try {
      final body = {
        "title": title.value,
        "content": description.value,
        "dueDate": selectedDate.value,
        "teacherSubjectId": subjectValue.value!.id,
        "studentIds": studentController.selectedStudentsIds,
      };

      // if there are any attachments to remove from server
      if (attachmentsIdsToRemoveFromServer.isNotEmpty) {
        await deleteHomeworkAttachments();
      }

      await _apiService.patch(
        url: '${ApiUrls.teacherHomeworksUrl}/${homeworkId.value}',
        body: body,
      );

      successDialog(
        title: AppLanguage.homeworkEditedSuccess.tr,
        press: () {
          clearPreviseData();
          Get.back(); // close dialog
          Get.back(); // close edit homework screen
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

  Future deleteHomework(String id) async {
    dprint("delete  homework request ...");

    loading(true);
    try {
      await _apiService.delete(url: "${ApiUrls.teacherHomeworksUrl}/$id");

      Get.snackbar(
        AppLanguage.tureOperationStr.tr,
        AppLanguage.deleteSuccessStr.tr,
      );
      pagingController.refresh();
    } catch (e) {
      dprint("Error in delete homework request ...");
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

  Future markHomeworkAsCompleted(String id) async {
    dprint("Mark homework as completed request ...");
    loading(true);
    try {
      final String url;
      if (controller.isParent) {
        url = '${ApiUrls.parentHomeworksUrl}/$id/status/Completed/${controller.selectedStudentIdForParent.value}';
      } else {
        url = '${ApiUrls.studentHomeworksUrl}/$id/status/Completed';
      }
      
      await _apiService.patch(url: url);
      
      completedHomeworkIds.add(id);
      
      Get.back(); // Close bottom sheet
      
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.green300.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.green300.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.green300,
                    size: 42,
                  ),
                ),
                const SizedBox(height: 20),
                // Title
                Text(
                  "أحسنت! 🎉",
                  style: AppTextStyles.bold22.copyWith(
                    color: AppColors.green300,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                // Subtitle
                Text(
                  "تم إكمال الواجب بنجاح",
                  style: AppTextStyles.medium14.copyWith(
                    color: const Color(0xff7A7A7A),
                    height: 1.7,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                // OK button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // close dialog
                      pagingController.refresh();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green300,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "حسناً",
                      style: AppTextStyles.bold16.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
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
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      dprint(error);
    } finally {
      loading(false);
    }
  }

  Future getTeacherClass(String? stageId) async {
    dprint("Get class ........");

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
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      dprint(error);
    } finally {
      loading(false);
    }
  }

  Future getTeacherSection(String? classId) async {
    dprint("Get section ........");

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
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      dprint(error);
    } finally {
      loading(false);
    }
  }

  Future getTeacherSubject(String? classId) async {
    dprint("Get subjects ........");

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
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      dprint(error);
    } finally {
      loading(false);
    }
  }

  /// This method is used to fetch the list of students based on the selected section ,stage, class
  /// This method is used to fetch the list of students based on the selected section ,stage, class
  Future<void> getStudents() async {
    if (selectedSections.isEmpty) {
      Get.toNamed(
        ScreensUrls.sectionStudentsScreenUrl,
        arguments: {'isSelectionMode': true},
      );
      return;
    }

    final sectionIds = selectedSections.map((s) => s.id!).toList();
    await studentController.getStudents(sectionIds: sectionIds);
    Get.toNamed(
      ScreensUrls.sectionStudentsScreenUrl,
      arguments: {'isSelectionMode': true},
    );
  }

  Future<void> deleteHomeworkAttachments() async {
    try {
      await _apiService.delete(
        url: ApiUrls.teacherHomeworkAttachmentsUrl,
        body: {'attachmentIds': attachmentsIdsToRemoveFromServer},
      );
      attachmentsIdsToRemoveFromServer.clear();
    } catch (e) {
      rethrow;
    }
  }

  void showFilePickerBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: .vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const .symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: .center,
              children: [
                LoadingButton(
                  onPressed: () async {
                    Get.back();
                    await _pickImage(ImageSource.camera);
                  },
                  text: AppLanguage.cameraStr.tr,
                  bgColor: AppColors.mainColor,
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () async {
                    Get.back();
                    await _pickImage(ImageSource.gallery);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: .circular(14)),
                    side: const BorderSide(color: AppColors.mainColor),
                    fixedSize: Size(Get.width, 48),
                  ),
                  child: Text(
                    AppLanguage.pickImage.tr,
                    style: AppTextStyles.bold14.copyWith(
                      color: AppColors.mainColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () async {
                    Get.back();
                    await pickFiles();
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: .circular(14)),
                    side: const BorderSide(color: AppColors.mainColor),
                    fixedSize: Size(Get.width, 48),
                  ),
                  child: Text(
                    AppLanguage.pickFile.tr,
                    style: AppTextStyles.bold14.copyWith(
                      color: AppColors.mainColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      if (source == ImageSource.gallery) {
        final picked = await picker.pickMultiImage();
        if (picked.isNotEmpty) {
          files.insertAll(0, picked.map((e) => File(e.path)).toList());
        }
      } else {
        final picked = await picker.pickImage(source: source);
        if (picked != null) {
          files.insert(0, File(picked.path));
        }
      }
    } catch (e) {
      dprint('_pickImage error: $e');
    }
  }

  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null) {
      files.insertAll(0, result.paths.map((path) => File(path!)).toList());
    }
  }

  void removeFileFromList(int index) {
    // If the file is a URL, mark it for removal from the server
    if (files[index] is String) {
      final url = files[index] as String;
      for (final HomeworkSubjectModel subject in pagingController.itemList!) {
        if (subject.homeworks == null) continue;
        for (final HomeworkModel homework in subject.homeworks!) {
          final attachment = homework.attachments.firstWhere(
            (att) => att.url == url,
            orElse: () => AttachmentModel((b) {
              b.id = '';
              b.url = '';
            }),
          );

          if (attachment.url.isNotEmpty) {
            attachmentsIdsToRemoveFromServer.add(attachment.id);
          }
        }
      }
    }
    files.removeAt(index);
  }

  List<String> attachmentsUrls(List<AttachmentModel> attachments) {
    return attachments.map((e) => e.url).toList();
  }

  void clearPreviseData() {
    stageValue.value = null;
    stages.clear();
    classes.clear();
    classValue(null);
    sections.clear();
    selectedSections.clear();
    subjects.clear();
    subjectValue(null);
    selectedDate('تحديد تاريخ');
    titleController.clear();
    descController.clear();
    title('');
    description('');
    files.clear();
    studentController.selectedStudentsIds.clear();
    studentController.students.clear();
    studentController.searchController.clear();
    studentController.searchQuery.value = '';
    getTeacherStage();
  }
}
