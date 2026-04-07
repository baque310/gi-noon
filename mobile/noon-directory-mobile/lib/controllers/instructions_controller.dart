import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/failures.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/reusable_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InstructionsController extends GetxController {
  RxBool loading = false.obs;

  //pagination sections
  final PagingController<int, ReusableModel> pagingController =
      PagingController(firstPageKey: 1);
  static const _pageSize = 8;
  final ApiService _apiService = ApiService();
  Rx<ReusableModel?> guidance = Rx<ReusableModel?>(null);

  @override
  void onInit() {
    pagingController.addPageRequestListener((pageKey) {
      getGuidances(pageKey);
    });
    super.onInit();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  Future getGuidances(int pageKey) async {
    loading(true);
    try {
      double pageCount = (pageKey - 1) / _pageSize + 1;
      final res = await _apiService.get(
        url: ApiUrls.guidanceUrl,
        queryParameters: {"skip": pageCount, "take": _pageSize},
      );

      final items = List<ReusableModel>.from(
        res.data['data'].map((e) => ReusableModel.fromJson(jsonEncode(e))),
      );
      final bool isLastPage = items.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(items);
      } else {
        final nextPageKey = pageKey + items.length;
        pagingController.appendPage(items, nextPageKey);
      }
    } catch (e) {
      dprint("Error in Get guidances ...");
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

  Future getGuidance(String id) async {
    loading(true);
    try {
      final res = await _apiService.get(url: '${ApiUrls.guidanceUrl}/$id');
      guidance.value = ReusableModel.fromJson(jsonEncode(res.data));
    } catch (e) {
      dprint("Error in Get guidances by id  ...");
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
}
