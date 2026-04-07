import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/models/attendance_model.dart';
import 'package:noon/models/student_enrollment_model.dart';
import 'package:noon/models/teacher_section_schedule.dart';
import '../core/constant/api_urls.dart';
import '../core/constant/app_strings.dart';
import '../core/enum.dart';
import '../core/failures.dart';
import '../core/function.dart';
import '../core/localization/language.dart';
import '../data/api_services.dart';
import '../models/class_model.dart';
import '../models/section_model.dart';
import '../models/stage_model.dart';
import '../view/widget/alert_dialogs.dart';
import 'global_controller.dart';

class AttendancesController extends GetxController {
  final loading = false.obs;
  final ApiService _apiService = ApiService();
  final box = Hive.box(AppStrings.boxKey);

  var lastSnackbarTime = DateTime.now().subtract(const Duration(seconds: 5));

  void showSnackbarOnce(String title, String message) {
    if (DateTime.now().difference(lastSnackbarTime).inSeconds > 5) {
      Get.snackbar(title, message);
      lastSnackbarTime = DateTime.now();
    }
  }

  final attendances = <AttendanceModel>[].obs;

  final presentCount = Rxn<int>(null);
  final absentCount = Rxn<int>(null);
  final vacationCount = Rxn<int>(null);
  final sectionId = Rxn<String>(null);
  final sectionScheduleId = Rxn<String>(null);

  var selectedDate = 'تحديد تاريخ'.obs;

  //stage المرحلئ
  final stages = <Stage>[].obs;
  final stageValue = Rxn<Stage>(null);

  //class الصف
  final classes = <ClassInfo>[].obs;
  final classValue = Rxn<ClassInfo>(null);

  //section الشعبة
  final sections = <Section>[].obs;
  final sectionValue = Rxn<Section>(null);

  final studentEnrollments = <StudentEnrollmentModel>[].obs;

  //عرض وقت الدرس
  final dayValue = Rxn<TeacherSectionSchedule>(null);
  final teacherSectionScheduleList = <TeacherSectionSchedule>[].obs;

  final teacherAttendances = <AttendanceModel>[].obs;
  final students = <StudentEnrollmentModel>[].obs;

  var attendanceRecords = <Map<String, dynamic>>[].obs;

  void updateStudentStatus(String studentId, StudentStutus status) {
    final index = students.indexWhere((student) => student.id == studentId);

    if (index != -1) {
      final updatedStudent = students[index].rebuild((b) => b..status = status);
      students[index] = updatedStudent;
      final existingRecordIndex = attendanceRecords.indexWhere(
        (record) =>
            record['studentEnrollmentId'] == updatedStudent.id &&
            record['date'] == selectedDate.value,
      );
      if (existingRecordIndex != -1) {
        attendanceRecords[existingRecordIndex] = {
          "date": selectedDate.value,
          "Status": capitalizeFirstLetter(status.name.toString()),
          "studentEnrollmentId": updatedStudent.id,
          "sectionScheduleId": [sectionScheduleId.value],
        };
      } else {
        final record = {
          "date": selectedDate.value,
          "Status": capitalizeFirstLetter(status.name.toString()),
          "studentEnrollmentId": updatedStudent.id,
          "sectionScheduleId": [sectionScheduleId.value],
        };

        attendanceRecords.add(record);
      }
    }
  }

  final controller = Get.find<GlobalController>();

  @override
  void onInit() {
    super.onInit();
    getTeacherStage();
    selectedDate.value = DateTime.now().formatDateToYearMonthDay;
    getAttendances();
  }

  void pickDate() async {
    DateTime? pickedDate = await pickDateMethode();
    if (pickedDate != null) {
      selectedDate.value = pickedDate.formatDateToYearMonthDay;
      await getAttendances();
    }
  }

  Future<void> getAttendances() async {
    if (!controller.isTeacher) {
      await getStudentAttendances();
    } else {
      await getSectionSchedule();
    }
  }

  Future<void> getStudentAttendances() async {
    dprint("Get student attendances ........");
    loading(true);

    try {
      final res = await _apiService.get(
        url: controller.isStudent
            ? ApiUrls.studentAttendancesUrl
            : '${ApiUrls.studentAttendancesForParentUrl}/${controller.selectedStudentIdForParent.value}',
        queryParameters: {"date": selectedDate.value},
      );
      presentCount(res.data['presentCount']);
      absentCount(res.data['absentCount']);
      vacationCount(res.data['vacationCount']);
      attendances.value = List.from(
        res.data['data'].map((s) => AttendanceModel.fromJson(jsonEncode(s))),
      );
    } catch (e) {
      dprint("Error in Get student attendances results ...");
      dprint(e.toString());
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
    dprint("Get teacher class ........");
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

  Future getSectionSchedule() async {
    dprint("Get teacher section schedule ........");
    loading(true);
    try {
      Map<String, dynamic> arg = {
        "sectionId": sectionId.value,
        "date": selectedDate.value,
      };
      final res = await _apiService.get(
        url: ApiUrls.sectionScheduleUrl,
        queryParameters: arg,
      );
      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }
      teacherSectionScheduleList.value = List.from(
        res.data.map((s) => TeacherSectionSchedule.fromJson(jsonEncode(s))),
      );
    } catch (e) {
      dprint("Error in Get section schedule list  ...");
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

  Future getTeacherAttendances() async {
    dprint("Get teacher attendances ........");
    loading(true);
    try {
      final res = await _apiService.get(
        url: ApiUrls.teacherAttendancesUrl,
        queryParameters: {
          "date": selectedDate.value,
          "sectionScheduleId": sectionScheduleId.value,
        },
      );
      teacherAttendances.value = List.from(
        res.data['data'].map((s) => AttendanceModel.fromJson(jsonEncode(s))),
      );
    } catch (e) {
      dprint("Error in Get teacher attendances results ...");
      dprint(e.toString());
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

  Future getTeacherStudents() async {
    dprint("Get teacher student enrollment ........");
    loading(true);
    try {
      final res = await _apiService.get(
        url: '${ApiUrls.teacherStudentEnrollmentUrl}/${sectionId.value}',
      );

      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }

      students.value = List.from(
        res.data.map((s) => StudentEnrollmentModel.fromJson(jsonEncode(s))),
      );
    } catch (e) {
      dprint("Error in Get teacher student enrollment ...");
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

  Future addStudentStatus() async {
    dprint("add new student status ...");
    loading(true);
    try {
      await _apiService.post(
        url: ApiUrls.teacherAttendancesUrl,
        body: {"attendanceRecords": attendanceRecords},
      );
      await getTeacherAttendances();
      attendanceRecords.clear();
    } catch (e) {
      dprint("Error in add student status ...");
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
        if (error.contains(
          'A attendance with the same details already exists',
        )) {
          error = AppLanguage.studentStatusAlreadyExistsStr.tr;
        }
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      loading(false);
    }
  }

  Future updateStudentStatusRequest(String id, String status) async {
    dprint("update  student status ...");
    loading(true);
    try {
      var data = {"Status": status};
      await _apiService.patch(
        url: '${ApiUrls.teacherAttendancesUrl}/$id',
        body: data,
      );
      Get.snackbar(
        AppLanguage.tureOperationStr.tr,
        AppLanguage.updateStudentStatusStr.tr,
      );
      await getTeacherAttendances();
    } catch (e) {
      dprint("Error in update student status ...");
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
}
