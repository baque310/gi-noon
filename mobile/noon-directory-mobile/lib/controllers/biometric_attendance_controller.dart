import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/core/failures.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/view/widget/alert_dialogs.dart';
import 'global_controller.dart';

class BiometricAttendanceController extends GetxController {
  final loading = false.obs;
  final ApiService _apiService = ApiService();
  final controller = Get.find<GlobalController>();

  // Student info
  final studentName = ''.obs;
  final studentPhoto = Rxn<String>(null);
  final biometricPhoto = Rxn<String>(null);
  final biometricEnrollId = Rxn<int>(null);
  final stageName = ''.obs;
  final className = ''.obs;
  final sectionName = ''.obs;

  // Balance
  final allowedAbsences = 0.obs;
  final usedAbsences = 0.obs;
  final remainingBalance = 0.obs;

  // Today record
  final todayRecord = Rxn<Map<String, dynamic>>(null);

  // History records (last 3 days)
  final historyRecords = <Map<String, dynamic>>[].obs;

  // Selected date
  final selectedDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    selectedDate.value =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    fetchBiometricAttendance();
  }

  Future<void> fetchBiometricAttendance() async {
    dprint("Fetching biometric attendance...");
    loading(true);

    try {
      String url;
      if (controller.isStudent) {
        url = ApiUrls.studentBiometricAttendanceUrl;
      } else {
        // Parent
        url =
            '${ApiUrls.parentBiometricAttendanceUrl}/${controller.selectedStudentIdForParent.value}';
      }

      final res = await _apiService.get(
        url: url,
        queryParameters: {"date": selectedDate.value},
      );

      final data = res.data;

      // Student info
      if (data['student'] != null) {
        final student = data['student'];
        studentName.value = student['name'] ?? '';
        studentPhoto.value = student['photo'];
        biometricPhoto.value = student['biometricPhoto'];
        biometricEnrollId.value = student['biometricEnrollId'];
        stageName.value = student['stage'] ?? '';
        className.value = student['className'] ?? '';
        sectionName.value = student['sectionName'] ?? '';
      }

      // Balance
      if (data['balance'] != null) {
        final balance = data['balance'];
        allowedAbsences.value = balance['allowed'] ?? 0;
        usedAbsences.value = balance['used'] ?? 0;
        remainingBalance.value = balance['remaining'] ?? 0;
      }

      // Today
      todayRecord.value = data['today'] != null
          ? Map<String, dynamic>.from(data['today'])
          : null;

      // History
      if (data['history'] != null) {
        historyRecords.value = List<Map<String, dynamic>>.from(
          (data['history'] as List).map((e) => Map<String, dynamic>.from(e)),
        );
      } else {
        historyRecords.clear();
      }
    } catch (e) {
      dprint("Error fetching biometric attendance: $e");
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

  void changeDate(DateTime date) {
    selectedDate.value =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    fetchBiometricAttendance();
  }
}
