import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/constant/app_strings.dart';
import 'package:noon/core/failures.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/day_model.dart';
import 'package:intl/intl.dart';
import '../core/localization/language.dart';
import 'global_controller.dart';

class SchoolScheduleController extends GetxController {
  final ApiService apiService = ApiService();

  final RxBool loading = false.obs;
  final RxString errorMessage = ''.obs;
  RxString selectedDay = ''.obs;
  final box = Hive.box(AppStrings.boxKey);
  RxList<DayModel> days = <DayModel>[].obs;

  @override
  void onInit() {
    //select current day and get schedule for this day
    selectedDay(DateFormat('EEEE').format(DateTime.now()).toUpperCase());
    getSchedule();
    super.onInit();
  }

  final controller = Get.find<GlobalController>();

  Future getSchedule() async {
    try {
      loading(true);
      final String url;

      if (controller.isTeacher) {
        url = ApiUrls.teacherScheduleUrl;
      } else if (controller.isStudent) {
        url = ApiUrls.studentScheduleUrl;
      } else {
        url =
            '${ApiUrls.studentScheduleForParentUrl}/${controller.selectedStudentIdForParent.value}';
      }
      final res = await apiService.get(url: '$url?day=$selectedDay');

      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }

      days.value = List<DayModel>.from(
        (res.data['data'][selectedDay] ?? []).map(
          (e) => DayModel.fromJson(jsonEncode(e)),
        ),
      );
    } catch (e) {
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      dprint(error);
      return false;
    } finally {
      loading(false);
    }
  }
}
