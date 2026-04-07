import 'package:get/get.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/calendar/attendance.dart';
import 'package:noon/models/calendar/completed_lesson.dart';
import 'package:noon/models/calendar/exam.dart';
import 'package:noon/models/calendar/homework.dart';
import 'package:noon/models/calendar/schedule.dart';
import 'package:s_extensions/s_extensions.dart';

class CalendarController extends GetxController {
  final GlobalController _global = Get.find<GlobalController>();
  final ApiService _api = ApiService();

  final selectedTabIndex = 0.obs;
  final selectedDate = DateTime.now().obs;
  final isLoading = false.obs;
  final isError = false.obs;
  final schedule = <ScheduleModel>[].obs;
  final completedLessons = <CompletedLessonModel>[].obs;
  final homework = <HomeworkModel>[].obs;
  final exams = <ExamModel>[].obs;
  final attendance = <AttendanceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    debounce<DateTime>(selectedDate, (_) => _fetchDashboard(), time: 300.msec);
    setSelectedDate(DateTime.now());
  }

  void setSelectedTabIndex(int index) => selectedTabIndex(index);
  void setSelectedDate(DateTime d) => selectedDate(d);

  Future<void> _fetchDashboard() async {
    isLoading(true);
    try {
      final dateStr = selectedDate.value.formatDayMonthYear.replaceAll(
        '-',
        '/',
      );
      String url;
      Map<String, dynamic> params = {'date': dateStr};

      if (_global.isParent) {
        url =
            '${ApiUrls.parentDashboardUrl}/${_global.selectedStudentIdForParent.value}';
      } else {
        url = ApiUrls.studentDashboardUrl;
      }

      final response = await _api.get(url: url, queryParameters: params);

      if (response.data == null) {
        isError(true);
        return;
      }

      final data = response.data as Map<String, dynamic>;

      schedule.value = data['schedule']
          .map<ScheduleModel>(
            (e) => ScheduleModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      completedLessons.value = data['completedLessons']['items']
          .map<CompletedLessonModel>(
            (e) => CompletedLessonModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      homework.value = data['homework']['items']
          .map<HomeworkModel>(
            (e) => HomeworkModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      exams.value = data['exams']
          .map<ExamModel>((e) => ExamModel.fromJson(e as Map<String, dynamic>))
          .toList();

      attendance.value = data['attendance']['items']
          .map<AttendanceModel>(
            (e) => AttendanceModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      dprint(tag: '[attendance]', attendance);
    } catch (_, s) {
      isError(true);
      dprint(tag: '[Error]', s);
    }
    isLoading(false);
  }
}
