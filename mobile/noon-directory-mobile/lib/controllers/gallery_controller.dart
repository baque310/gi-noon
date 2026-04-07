import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/failures.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/reusable_model.dart';

class GalleryController extends GetxController {
  RxBool loading = false.obs;

  //pagination sections
  final PagingController<int, ReusableModel> pagingController =
      PagingController(firstPageKey: 1);
  static const _pageSize = 8;
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    pagingController.addPageRequestListener((pageKey) {
      getGallery(pageKey);
    });
    super.onInit();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  Future getGallery(int pageKey) async {
    loading(true);
    try {
      double pageCount = (pageKey - 1) / _pageSize + 1;
      final res = await _apiService.get(
        url: ApiUrls.galleryUrl,
        queryParameters: {
          "skip": pageCount,
          "take": _pageSize,
          'sortBy': 'createdAt',
          'sortDirection': 'desc',
        },
      );

      final gc = Get.find<GlobalController>();

      final items =
          List<ReusableModel>.from(
                res.data['data'].map(
                  (e) => ReusableModel.fromJson(jsonEncode(e)),
                ),
              )
              .where(
                (m) =>
                    m.classId == null ||
                    (gc.isStudent
                        ? m.classId == gc.classId
                        : m.classId == gc.selectedStudentClassIdForParent),
              )
              .toList();

      dprint(tag: 'items', items);
      dprint(tag: 'classId', gc.classId);
      dprint(
        tag: 'selectedStudentClassIdForParent',
        gc.selectedStudentClassIdForParent,
      );

      final bool isLastPage = items.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(items);
      } else {
        final nextPageKey = pageKey + items.length;
        pagingController.appendPage(items, nextPageKey);
      }
      pagingController.itemList?.sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );
    } catch (e) {
      dprint("Error in Get gallery ...");
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
