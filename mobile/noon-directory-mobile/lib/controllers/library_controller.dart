import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/controllers/profile_controller.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/constant/app_strings.dart';
import 'package:noon/core/failures.dart';
import 'package:noon/core/image_helper.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/class_model.dart';
import 'package:noon/models/library_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/models/stage_model.dart';
import 'package:noon/view/widget/alert_dialogs.dart';
import '../core/localization/language.dart';

class LibraryController extends GetxController {
  final ApiService apiService = ApiService();
  RxBool isWaiting = false.obs;
  RxBool loading = false.obs;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  var title = ''.obs;
  var description = ''.obs;

  Rx<File?> image = Rx<File?>(null);
  Rx<File?> file = Rx<File?>(null);
  RxString id = ''.obs;

  RxList<Stage> stages = <Stage>[].obs;
  Rxn<Stage> stageValue = Rxn<Stage>(null);
  RxList<ClassInfo> classes = <ClassInfo>[].obs;
  Rxn<ClassInfo> classValue = Rxn<ClassInfo>(null);
  RxList<Section> sections = <Section>[].obs;
  Rxn<Section> sectionValue = Rxn<Section>(null);
  Rxn<String> sectionId = Rxn<String>(null);
  Rxn<String> classId = Rxn<String>(null);
  RxBool sendToAllSections = false.obs;

  RxBool get isFormValid =>
      ((title.isNotEmpty && title.value.trim() != '') &&
              (description.isNotEmpty && description.value.trim() != '') &&
              (file.value != null || image.value != null))
          .obs;

  final pagingController = PagingController<int, LibraryModel>(firstPageKey: 1);
  static const _pageSize = 8;
  final box = Hive.box(AppStrings.boxKey);
  bool isTeacher = false;
  final ApiService _apiService = ApiService();

  final RxList<String> downloadedFiles = <String>[].obs;
  final Box<String> _downloadedFilesBox = Hive.box<String>('downloaded_files');
  final RxList<String> downloadedFilesPaths = <String>[].obs;
  final Box<String> _downloadedFilesPathsBox = Hive.box<String>(
    'downloaded_files_paths',
  );

  var lastSnackbarTime = DateTime.now().subtract(const Duration(seconds: 5));

  @override
  void onInit() {
    super.onInit();

    isTeacher = Get.find<GlobalController>().isTeacher;

    downloadedFiles.addAll(_downloadedFilesBox.values);
    downloadedFilesPaths.addAll(_downloadedFilesPathsBox.values);

    pagingController.addPageRequestListener((pageKey) {
      getLibraries(pageKey);
    });

    getTeacherStage();
  }

  void showSnackbarOnce(String title, String message) {
    if (DateTime.now().difference(lastSnackbarTime).inSeconds > 5) {
      Get.snackbar(title, message);
      lastSnackbarTime = DateTime.now();
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
      if (e is DioException) {
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
      if (e is DioException) {
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

  Future<void> prefillEditSelections({
    String? classId,
    String? sectionId,
  }) async {
    if (sectionId != null && sectionId.isNotEmpty) {
      this.sectionId(sectionId);
    }

    if (classId != null && classId.isNotEmpty) {
      this.classId(classId);
    }

    if (stages.isEmpty) {
      await getTeacherStage();
    }

    classes.clear();
    sections.clear();
    classValue(null);
    sectionValue(null);

    for (final stg in stages) {
      final stageId = stg.id;
      if (stageId == null) continue;

      await getTeacherClass(stageId);

      ClassInfo? cls;
      try {
        cls = classes.firstWhere((c) => c.id == classId);
      } catch (_) {
        cls = null;
      }

      if (cls != null) {
        stageValue(stg);
        classValue(cls);
        this.classId(cls.id);

        await getTeacherSection(cls.id);

        if (sectionId != null && sectionId.isNotEmpty) {
          Section? sec;
          try {
            sec = sections.firstWhere((s) => s.id == sectionId);
          } catch (_) {
            sec = null;
          }
          if (sec != null) {
            sectionValue(sec);
            this.sectionId(sec.id);
          }
        }
        break;
      }
    }
  }

  void addDownloadedFile(String fileName, String path) {
    if (!downloadedFiles.contains(fileName)) {
      downloadedFiles.add(fileName);
      downloadedFilesPaths.add(path);
      _downloadedFilesBox.put(fileName, fileName);
      _downloadedFilesPathsBox.put(fileName, path);
      downloadedFiles.refresh();
    }
  }

  Future<void> removeDownloadedFile(String fileName) async {
    String? path;
    try {
      path = downloadedFilesPaths.firstWhere((p) => p.contains(fileName));
    } catch (_) {
      path = _downloadedFilesPathsBox.get(fileName);
    }

    if (path != null && path.isNotEmpty) {
      final f = File(path);
      if (await f.exists()) {
        try {
          await f.delete();
        } catch (_) {}
      }
    }

    downloadedFiles.remove(fileName);
    downloadedFilesPaths.removeWhere((p) => p.contains(fileName));
    _downloadedFilesBox.delete(fileName);
    _downloadedFilesPathsBox.delete(fileName);
    downloadedFiles.refresh();
    downloadedFilesPaths.refresh();

    Get.snackbar(
      AppLanguage.tureOperationStr.tr,
      AppLanguage.deleteSuccessStr.tr,
    );
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  RxInt loadingIndex = (-1).obs;

  Future getLibraries(int pageKey) async {
    loading(true);
    final user = Get.find<ProfileController>().user.value!;
    try {
      String? url;
      if (isTeacher) {
        url = ApiUrls.teacherLibraryUrl;
      } else {
        url = ApiUrls.studentLibraryUrl;
      }
      double pageCount = (pageKey - 1) / _pageSize + 1;
      final res = await _apiService.get(
        url: url,
        queryParameters: {"skip": pageCount, "take": _pageSize},
      );

      final items =
          List<LibraryModel>.from(
                res.data['data'].map(
                  (e) => LibraryModel.fromJson(jsonEncode(e)),
                ),
              )
              .where(
                (l) => isTeacher
                    ? l.authorId == user.teacher?.id
                    : (l.classId ==
                              user
                                  .student
                                  ?.studentEnrollment
                                  ?.first
                                  .classInfo
                                  ?.id ||
                          l.classId == null),
              )
              .toList();

      final bool isLastPage = items.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(items);
      } else {
        final nextPageKey = pageKey + items.length;
        pagingController.appendPage(items, nextPageKey);
      }
    } catch (e) {
      dprint("Error in Get Libraries ...");
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

  Future getImage(ImageSource media) async {
    Get.back();
    final imageFile = await ImageHelper.getImage(media);
    if (imageFile != null) {
      image.value = imageFile;
    }
  }

  Future getFile() async {
    Get.back();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      file.value = File(result.files.single.path!);
    }
  }

  Future postFile() async {
    loading(true);
    try {
      String? fileName;
      dio.FormData? data;

      if (image.value != null) {
        fileName = image.value!.path.split('/').last;

        data = dio.FormData.fromMap({
          "title": title.value,
          "description": description.value,
          "url": await dio.MultipartFile.fromFile(
            image.value!.path,
            filename: fileName,
          ),
          if (!sendToAllSections.value) "sectionId": sectionId.value,
          if (sendToAllSections.value) "classId": classId.value,
        });
      }

      if (file.value != null) {
        fileName = file.value!.path.split('/').last;

        data = dio.FormData.fromMap({
          "title": title.value,
          "description": description.value,
          "url": await dio.MultipartFile.fromFile(
            file.value!.path,
            filename: fileName,
          ),
          if (!sendToAllSections.value) "sectionId": sectionId.value,
          if (sendToAllSections.value) "classId": classId.value,
        });
      }

      await apiService.post(url: ApiUrls.teacherLibraryUrl, body: data);
      clearPreviseData();
      Get.back();
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

  Future patchFile() async {
    loading(true);
    try {
      String? fileName;
      dio.FormData data = dio.FormData();

      if (title.value.isNotEmpty) {
        data.fields.add(MapEntry("title", title.value));
      }

      if (description.value.isNotEmpty) {
        data.fields.add(MapEntry("description", description.value));
      }

      if (image.value != null) {
        fileName = image.value!.path.split('/').last;
        data.files.add(
          MapEntry(
            "url",
            await dio.MultipartFile.fromFile(
              image.value!.path,
              filename: fileName,
            ),
          ),
        );
      }

      if (file.value != null) {
        fileName = file.value!.path.split('/').last;
        data.files.add(
          MapEntry(
            "url",
            await dio.MultipartFile.fromFile(
              file.value!.path,
              filename: fileName,
            ),
          ),
        );
      }

      await apiService.patch(
        url: '${ApiUrls.teacherLibraryUrl}/$id',
        body: data,
      );

      clearPreviseData();
      Get.back();
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

  Future deleteLibraryItem(String id) async {
    dprint("delete library item request ...");

    loading(true);
    try {
      await _apiService.delete(url: "${ApiUrls.teacherLibraryUrl}/$id");

      Get.snackbar(
        AppLanguage.tureOperationStr.tr,
        AppLanguage.deleteSuccessStr.tr,
      );
      pagingController.refresh();
    } catch (e) {
      dprint("Error in delete library item request ...");
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

  void clearPreviseData() {
    image.value = null;
    file.value = null;
    titleController.clear();
    descController.clear();
    title('');
    description('');
  }
}
