import 'dart:convert';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/notification_model.dart';

class AnnouncementsController extends GetxController {
  final pagingController = PagingController<int, NotificationModel>(
    firstPageKey: 1,
  );
  static const _pageSize = 100;
  final _apiService = ApiService();
  RxInt announcementsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getAnnouncementsCount();
    pagingController.addPageRequestListener((pageKey) {
      getAnnouncements(pageKey);
    });
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  Future<void> getAnnouncements(int pageKey) async {
    await fetchAnnouncementsRecursively(pageKey);
  }

  Future<void> getAnnouncementsCount() async {
    try {
      final gController = Get.find<GlobalController>();
      final isStudent = gController.isStudent;

      final res = await _apiService.get(
        url: ApiUrls.notificationUrl,
        queryParameters: {
          "skip": 1,
          "take": _pageSize,
          'sortBy': 'createdAt',
          'sortDirection': 'desc',
          'isAlert': 'TRUE',
          if (!isStudent)
            'studentId': gController.selectedStudentIdForParent.value,
        },
      );

      final allItems = List<NotificationModel>.from(
        res.data['data'].map((e) => NotificationModel.fromJson(jsonEncode(e))),
      );
      for (var e in allItems) {
        if (!e.seenStatues) {
          announcementsCount.value++;
        }
      }
    } catch (e) {
      announcementsCount.value = 0;
    }
  }

  Future<void> markAllSeen() async {
    try {
      if (announcementsCount.value == 0) return;
      await _apiService.patch(url: ApiUrls.notificationMarkAllSeenUrl);
      announcementsCount.value = 0;
    } catch (e) {
      // ignore
    }
  }

  Future<void> fetchAnnouncementsRecursively(
    int pageKey, {
    List<NotificationModel> accumulatedItems = const [],
  }) async {
    try {
      final gController = Get.find<GlobalController>();
      final isStudent = gController.isStudent;

      final pageCount = (pageKey - 1) ~/ _pageSize + 1;
      final res = await _apiService.get(
        url: ApiUrls.notificationUrl,
        queryParameters: {
          "skip": pageCount,
          "take": _pageSize,
          'sortBy': 'createdAt',
          'sortDirection': 'desc',
          'isAlert': 'TRUE',
          if (!isStudent)
            'studentId': gController.selectedStudentIdForParent.value,
        },
      );

      final allItems = List<NotificationModel>.from(
        res.data['data'].map((e) => NotificationModel.fromJson(jsonEncode(e))),
      );
      final total = <NotificationModel>[...accumulatedItems, ...allItems];

      final isLastPage = allItems.length < _pageSize;

      if (total.isNotEmpty || isLastPage) {
        if (isLastPage) {
          pagingController.appendLastPage(total);
        } else {
          final nextPageKey = pageKey + _pageSize;
          pagingController.appendPage(total, nextPageKey);
        }
      } else {
        final nextPageKey = pageKey + _pageSize;
        await fetchAnnouncementsRecursively(
          nextPageKey,
          accumulatedItems: total,
        );
      }
    } catch (e) {
      pagingController.error = e;
    }
  }
}
