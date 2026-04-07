import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/models/installment_model.dart';
import 'package:noon/models/other_installment_model.dart';
import '../core/constant/api_urls.dart';
import '../core/failures.dart';
import '../data/api_services.dart';

class InstallmentsController extends GetxController
    with StateMixin<List<dynamic>> {
  final ApiService _apiService = ApiService();
  final controller = Get.find<GlobalController>();
  var selectedTabIndex = 0.obs;

  var installmentsData = <InstallmentModel>[].obs;
  var otherPaymentsData = <OtherInstallmentModel>[].obs;

  var isLoadingInstallments = false.obs;
  var isLoadingOtherPayments = false.obs;

  var installmentsError = ''.obs;
  var otherPaymentsError = ''.obs;

  @override
  void onInit() {
    fetchCurrentTabData();
    super.onInit();
  }

  void updateSelectedTab(int index) {
    selectedTabIndex.value = index;
    fetchCurrentTabData();
  }

  Future<void> fetchCurrentTabData() async {
    if (selectedTabIndex.value == 0) {
      await fetchInstallments();
    } else {
      await fetchOtherPayments();
    }
  }

  Future<void> fetchInstallments() async {
    try {
      isLoadingInstallments.value = true;
      installmentsError.value = '';
      change(null, status: RxStatus.loading());

      final res = await _apiService.get(
        url: controller.isStudent
            ? ApiUrls.installmentUrl
            : '${ApiUrls.installmentForParentUrl}/${controller.selectedStudentIdForParent.value}',
      );

      if (res.data == null ||
          res.data.isEmpty ||
          res.data[0]['installment'] == null) {
        installmentsData.clear();
        change(null, status: RxStatus.empty());
        return;
      }

      final installments = List<InstallmentModel>.from(
        res.data.map((e) {
          return InstallmentModel.fromJson(e['installment']);
        }),
      );

      installmentsData.value = installments;

      if (installments.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(installments.cast<dynamic>(), status: RxStatus.success());
      }
    } catch (e) {
      dprint('Installments fetch error: ${e.toString()}');
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      installmentsError.value = error;
      change(null, status: RxStatus.error(error));
    } finally {
      isLoadingInstallments.value = false;
    }
  }

  Future<void> fetchOtherPayments() async {
    try {
      isLoadingOtherPayments.value = true;
      otherPaymentsError.value = '';
      change(null, status: RxStatus.loading());

      final res = await _apiService.get(
        url: controller.isStudent
            ? ApiUrls.otherPaymentUrl
            : ApiUrls.otherPaymentForParentUrl,
      );

      if (res.data == null || res.data.isEmpty) {
        otherPaymentsData.clear();
        change(null, status: RxStatus.empty());
        return;
      }

      final otherPayments = List<OtherInstallmentModel>.from(
        res.data.map((e) {
          return OtherInstallmentModel.fromJson(e['installment'] ?? e);
        }),
      );

      otherPaymentsData.value = otherPayments;

      if (otherPayments.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(otherPayments.cast<dynamic>(), status: RxStatus.success());
      }
    } catch (e) {
      dprint('Other payments fetch error: ${e.toString()}');
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      otherPaymentsError.value = error;
      change(null, status: RxStatus.error(error));
    } finally {
      isLoadingOtherPayments.value = false;
    }
  }

  List<dynamic> get currentTabData {
    return selectedTabIndex.value == 0
        ? installmentsData.cast<dynamic>()
        : otherPaymentsData.cast<dynamic>();
  }

  bool get isCurrentTabLoading {
    return selectedTabIndex.value == 0
        ? isLoadingInstallments.value
        : isLoadingOtherPayments.value;
  }

  String get currentTabError {
    return selectedTabIndex.value == 0
        ? installmentsError.value
        : otherPaymentsError.value;
  }

  Future<void> refreshCurrentTab() async {
    await fetchCurrentTabData();
  }
}
