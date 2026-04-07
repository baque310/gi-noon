import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/controllers/student_controller.dart';
import 'package:noon/core/enum.dart' hide FileType;
import 'package:noon/core/function.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/models/lesson_attachment_model.dart';
import 'package:noon/models/lesson_model.dart';
import 'package:noon/models/lesson_subject_model.dart';
import '../core/constant/api_urls.dart';
import '../core/constant/screens_urls.dart';
import '../core/failures.dart';
import '../core/image_helper.dart';
import '../core/localization/language.dart';
import '../data/api_services.dart';
import '../models/class_model.dart';
import '../models/section_model.dart';
import '../models/stage_model.dart';
import '../models/teacher_subject_model.dart';
import '../view/widget/alert_dialogs.dart';
import 'global_controller.dart';
import '../view/widget/loading_button.dart';
import '../core/constant/app_text_style.dart';
import '../core/constant/app_colors.dart';
import 'package:file_picker/file_picker.dart';

class HomeworkCompletedController extends GetxController {
  final studentController = Get.put(StudentController());

  RxBool loading = false.obs;
  RxBool isWaiting = false.obs;

  // bool? isTeacher;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

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
  Rxn<Section> sectionValue = Rxn<Section>(null);
  RxList<Section> selectedSections = <Section>[].obs;
  Section? oldSectionValue;

  //subject المادة
  RxList<TeacherSubject> subjects = <TeacherSubject>[].obs;
  Rxn<TeacherSubject> subjectValue = Rxn<TeacherSubject>(null);

  /// 🔹 تطوير منطق العرض:
  /// تم تحديث الفلترة لتعرض فقط المواد "المشتركة" والمربوطة بالاستاذ في جميع الشعب المختارة.
  /// تم حل مشكلة التكرار عبر تجميع المواد حسب (StageSubjectId) وإظهار القيم الفريدة فقط.
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

  // Search Filter Variables
  Rxn<Stage> searchStageValue = Rxn<Stage>(null);
  Rxn<ClassInfo> searchClassValue = Rxn<ClassInfo>(null);
  Rxn<Section> searchSectionValue = Rxn<Section>(null);
  Rxn<TeacherSubject> searchSubjectValue = Rxn<TeacherSubject>(null);
  RxString searchDate = ''.obs;

  void showSnackbarOnce({
    required String title,
    required String message,
    Color? colorText,
  }) {
    if (Get.isSnackbarOpen) return;
    Get.snackbar(title, message, colorText: colorText);
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

  //pagination sections
  final _subjectsPagingController = PagingController<int, LessonSubjectModel>(
    firstPageKey: 1,
  );
  final _teacherLessonsPagingController = PagingController<int, LessonModel>(
    firstPageKey: 1,
  );

  PagingController get pagingController => controller.isTeacher
      ? _teacherLessonsPagingController
      : _subjectsPagingController;

  static const _pageSize = 8;
  final ApiService _apiService = ApiService();

  //validation add homework
  RxBool get isFormValid =>
      ((title.isNotEmpty && title.value.trim() != '') &&
              (description.isNotEmpty && description.value.trim() != '') &&
              (subjectValue.value != null && selectedSections.isNotEmpty) &&
              studentController.selectedStudentsIds.isNotEmpty)
          .obs;

  //validation update homework
  RxBool get isFormValidEdit =>
      ((title.isNotEmpty && title.value.trim() != '') &&
              (description.isNotEmpty && description.value.trim() != ''))
          .obs;

  RxnString lessonId = RxnString(null);

  @override
  void onInit() {
    super.onInit();
    if (Get.find<GlobalController>().accountType == AccountType.teacher) {
      getTeacherStage();
    }
    pagingController.addPageRequestListener((pageKey) {
      getHomeWorksCompleted(pageKey);
    });
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  RxList<dynamic> images = RxList<dynamic>();
  List<LessonAttachmentModel> imagesModels = [];

  Future<void> getImage(ImageSource media) async {
    if (media == ImageSource.gallery) {
      final picker = ImagePicker();
      final picked = await picker.pickMultiImage();
      if (picked.isNotEmpty) {
        images.insertAll(0, picked.map((e) => File(e.path)).toList());
      }
    } else {
      final imageFile = await ImageHelper.getImage(media);
      if (imageFile != null) {
        images.insert(0, imageFile);
      }
    }
  }

  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null) {
      images.insertAll(0, result.paths.map((path) => File(path!)).toList());
    }
  }

  void showFilePickerBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LoadingButton(
                  onPressed: () async {
                    Get.back();
                    await getImage(ImageSource.camera);
                  },
                  text: AppLanguage.cameraStr.tr,
                  bgColor: AppColors.mainColor,
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () async {
                    Get.back();
                    await getImage(ImageSource.gallery);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
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

  final controller = Get.find<GlobalController>();

  Future<void> getHomeWorksCompleted(int pageKey) async {
    dprint("Get lessons Completed ...");
    loading(true);
    try {
      final String url;
      if (controller.isTeacher) {
        url = ApiUrls.teacherLessonsUrl;
      } else if (controller.isStudent) {
        url = ApiUrls.studentLessonsUrl;
      } else {
        url =
            '${ApiUrls.studentLessonsFroParentUrl}/${controller.selectedStudentIdForParent.value}';
      }

      double pageCount = (pageKey - 1) / _pageSize + 1;

      Map<String, dynamic> queryParams = {"skip": pageCount, "take": _pageSize};

      if (controller.isTeacher) {
        final res = await _apiService.get(
          url: url,
          queryParameters: {"skip": 1, "take": 1},
        );
        final l = List<LessonModel>.from(
          res.data['data'].map((e) => LessonModel.fromJson(jsonEncode(e))),
        );

        if (searchDate.value.isNotEmpty) {
          queryParams['date'] = searchDate.value;
        }

        if (searchSubjectValue.value != null) {
          queryParams['teacherSubjectId'] =
              searchSubjectValue.value?.stageSubject?.subject?.id;
        }
        if (searchSectionValue.value != null) {
          queryParams['sectionId'] = searchSectionValue.value!.id!;
        }

        if (searchClassValue.value != null) {
          queryParams['schoolClassId'] = searchClassValue.value!.id;
        }
        if (l.isNotEmpty) {
          queryParams['schoolYearId'] = l.first.schoolYearId;
        }
      }

      final resWithFilter = await _apiService.get(
        url: url,
        queryParameters: queryParams,
      );
      dprint("Fetching lessons with params: $queryParams");

      late final List items;
      if (controller.isTeacher) {
        items = List<LessonModel>.from(
          resWithFilter.data['data'].map(
            (e) => LessonModel.fromJson(jsonEncode(e)),
          ),
        );
      } else {
        items = List<LessonSubjectModel>.from(
          resWithFilter.data['data'].map(
            (e) => LessonSubjectModel.fromJson(jsonEncode(e)),
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
      dprint("Error in Get lessons Completed...");
      dprint(e.toString());
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is dio.DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      pagingController.error = error;
    } finally {
      loading(false);
    }
  }

  Future<List<LessonSubjectModel>> getLessonsForTodayForStudent() async {
    dprint("Getting Homeworks for today ...");
    loading(true);
    try {
      final String url;
      if (controller.isStudent) {
        url = ApiUrls.studentLessonsUrl;
      } else if (controller.isTeacher) {
        url = ApiUrls.teacherLessonsUrl;
      } else {
        url =
            '${ApiUrls.studentLessonsFroParentUrl}/${controller.selectedStudentIdForParent.value}';
      }

      final res = await _apiService.get(
        url: url,
        queryParameters: {
          "take": 50,
          "date": DateTime.now().formatDateToYearMonthDay,
        },
      );

      final items = List<LessonSubjectModel>.from(
        res.data['data'].map((e) => LessonSubjectModel.fromJson(jsonEncode(e))),
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

  Future<LessonModel?> getLessonById(String lessonId) async {
    dprint("Getting lesson by ID: $lessonId");
    isWaiting(true);
    try {
      final String url;
      if (controller.isStudent) {
        url = '${ApiUrls.studentLessonsUrl}/$lessonId';
      } else {
        url =
            '${ApiUrls.studentLessonsFroParentUrl}/${controller.selectedStudentIdForParent.value}/$lessonId';
      }

      final res = await _apiService.get(url: url);
      if (res.data != null) {
        return LessonModel.fromJson(jsonEncode(res.data));
      }

      return null;
    } catch (e) {
      dprint("Error in Get Lesson by ID ...");
      dprint(e.toString());
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      return Future.error(error);
    } finally {
      isWaiting(false);
    }
  }

  Future addLesson() async {
    dprint("add lesson request ...");

    loading(true);
    try {
      final data = dio.FormData.fromMap({
        "title": title.value,
        "content": description.value,
        "teacherSubjectId": subjectValue.value!.id,
        "studentIds": studentController.selectedStudentsIds,
      });

      if (images.isNotEmpty) {
        for (var imageFile in images) {
          if (imageFile is String) continue;
          String fileName = imageFile.path.split('/').last;
          data.files.add(
            MapEntry(
              "attachments",
              await dio.MultipartFile.fromFile(
                imageFile.path,
                filename: fileName,
              ),
            ),
          );
        }
      }

      await _apiService.post(url: ApiUrls.teacherLessonsUrl, body: data);
      successDialog(
        title: AppLanguage.lessonAddedSuccess.tr,
        press: () {
          clearPreviseData();
          Get.back(); // close dialog
          Get.back(); // close add lesson screen
        },
      );
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

  Future editLesson() async {
    dprint("edit lesson request ...");
    loading(true);
    try {
      await _apiService.patch(
        url: '${ApiUrls.teacherLessonsUrl}/${lessonId.value}',
        body: {"title": title.value, "content": description.value},
      );

      final files = dio.FormData.fromMap({});

      if (images.isNotEmpty) {
        for (var imageFile in images) {
          if (imageFile is String) continue;
          final fileName = imageFile.path.split('/').last;
          final path = imageFile.path;
          if (path.isURL) continue;

          files.files.add(
            MapEntry(
              "attachments",
              await dio.MultipartFile.fromFile(path, filename: fileName),
            ),
          );
        }
      }

      await _apiService.patch(
        url: '${ApiUrls.teacherLessonsUrl}/${lessonId.value}/attachments',
        body: files,
      );

      successDialog(
        title: AppLanguage.lessonEditedSuccess.tr,
        press: () {
          clearPreviseData();
          Get.back(); // close dialog
          Get.back(); // close edit lesson screen
        },
      );
    } catch (e, s) {
      dprint(e.toString());
      dprint(s.toString());
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

  Future<void> removeFileAt(int index) async {
    final file = images[index];

    if (file is String) {
      final fileNameFromUrl = file.split('/').last;
      try {
        await _apiService.delete(
          url: ApiUrls.teacherLessonsAttachmentsUrl,
          body: {
            "attachmentIds": [
              imagesModels
                  .firstWhere((e) => e.url.split('/').last == fileNameFromUrl)
                  .id,
            ],
          },
        );
      } catch (e) {
        dprint('Error removing file: $e');
      }
      imagesModels.removeWhere((e) => e.url.split('/').last == fileNameFromUrl);
    }

    images.removeAt(index);
  }

  Future deleteLesson(String id) async {
    dprint("delete  lesson request ...");

    loading(true);
    try {
      await _apiService.delete(url: "${ApiUrls.teacherLessonsUrl}/$id");

      Get.snackbar(
        AppLanguage.tureOperationStr.tr,
        AppLanguage.deleteSuccessStr.tr,
      );
      pagingController.refresh();
    } catch (e) {
      dprint("Error in delete lesson request ...");
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
      if (e is dio.DioException) {
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
      if (e is dio.DioException) {
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
      if (e is dio.DioException) {
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
      if (e is dio.DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      dprint(error);
    } finally {
      loading(false);
    }
  }

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

  void clearPreviseData() {
    stageValue.value = null;
    stages.clear();
    classes.clear();
    classValue(null);
    sections.clear();
    sectionValue(null);
    selectedSections.clear();
    subjects.clear();
    subjectValue(null);
    titleController.clear();
    descController.clear();
    title('');
    description('');
    images.clear();
    studentController.selectedStudentsIds.clear();
    studentController.students.clear();
    studentController.searchController.clear();
    studentController.searchQuery.value = '';
    getTeacherStage();
  }
}
