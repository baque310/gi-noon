import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/failures.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/lines_model.dart';

import '../core/localization/language.dart';
import 'global_controller.dart';

class LinesController extends GetxController {
  final ApiService apiService = ApiService();

  final RxBool loading = false.obs;
  final RxString errorMessage = ''.obs;
  Rx<LinesModel?> bus = Rx<LinesModel?>(null);

  final controller = Get.find<GlobalController>();

  @override
  void onInit() {
    getLines();
    super.onInit();
  }

  Future getLines() async {
    try {
      loading(true);
      final res = await apiService.get(
        url: controller.isStudent
            ? ApiUrls.busUrl
            : '${ApiUrls.busForParentUrl}/${controller.selectedStudentIdForParent.value}',
      );

      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }

      bus.value = LinesModel.fromJson(jsonEncode(res.data));
    } catch (e) {
      dprint("Error in get buses ... ${e.toString()}");
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        error = ServerFailure.fromDioError(e).message;
        if (statusCode == 404 && error == 'schoolBus not found') {
          error = AppLanguage.busNotFoundStr.tr;
        }
      }
      errorMessage(error);
      return false;
    } finally {
      loading(false);
    }
  }
}
