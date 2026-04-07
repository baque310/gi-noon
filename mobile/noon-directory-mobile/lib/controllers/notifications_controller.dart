import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/controllers/profile_controller.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/failures.dart';
import 'package:noon/core/function.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/notification_model.dart';

class NotificationsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxBool loading = false.obs;
  int type = 0;
  RxInt selectedPageIndex = 0.obs;

  late TabController tabController;
  final PageController pageController = PageController();

  late List<PagingController<int, NotificationModel>> pagingControllers;
  static const _pageSize = 20;
  final ApiService _apiService = ApiService();

  PagingController<int, NotificationModel> get currentPagingController =>
      pagingControllers[selectedPageIndex.value];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 6, vsync: this);

    pagingControllers = List.generate(6, (index) {
      final controller = PagingController<int, NotificationModel>(
        firstPageKey: 1,
      );
      controller.addPageRequestListener((pageKey) {
        getNotifications(pageKey, type: index);
      });
      return controller;
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    pageController.dispose();
    for (var controller in pagingControllers) {
      controller.dispose();
    }
    loading.close();
    selectedPageIndex.close();
    super.onClose();
  }

  List<NotificationModel> _filterNotificationsByType(
    List<NotificationModel> items,
    int type,
  ) {
    if (type == 0) return items;

    return items.where((notification) {
      final dataType = notification.data?.type ?? '';
      switch (type) {
        case 1:
          return dataType == 'chat_message';
        case 2:
          return dataType == 'homework';
        case 3:
          return dataType == 'lesson';
        case 4:
          return dataType == 'exam';
        case 5:
          return dataType == 'studentInstallment';
        default:
          return false;
      }
    }).toList();
  }

  void changePage(int index) {
    type = index;
    selectedPageIndex.value = index;

    pagingControllers[index].refresh();

    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    selectedPageIndex.value = index;
    type = index;

    pagingControllers[index].refresh();

    if (tabController.index != index) {
      tabController.animateTo(index);
    }
  }

  Future<void> getNotifications(int pageKey, {int type = 0}) async {
    loading(true);
    try {
      await _fetchNotificationsRecursively(pageKey, type);
    } catch (e) {
      dprint("Error in Get Notifications ...");
      dprint(e.toString());
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      pagingControllers[type].error = error;
    } finally {
      loading(false);
    }
  }

  Future<void> _fetchNotificationsRecursively(
    int pageKey,
    int type, {
    List<NotificationModel> accumulatedItems = const [],
  }) async {
    double pageCount = (pageKey - 1) / _pageSize + 1;
    final res = await _apiService.get(
      url: ApiUrls.notificationUrl,
      queryParameters: {"skip": pageCount, "take": _pageSize},
    );

    List<NotificationModel> allItems = List<NotificationModel>.from(
      res.data['data'].map((e) => NotificationModel.fromJson(jsonEncode(e))),
    );

    List<NotificationModel> filteredItems = _filterNotificationsByType(
      allItems,
      type,
    );

    List<NotificationModel> totalFilteredItems = [
      ...accumulatedItems,
      ...filteredItems,
    ];

    dprint(
      "Page $pageKey: Found ${filteredItems.length} filtered items, total accumulated: ${totalFilteredItems.length}",
    );

    final bool isLastPage = allItems.length < _pageSize;
    final targetController = pagingControllers[type];

    if (totalFilteredItems.isNotEmpty || isLastPage) {
      if (isLastPage) {
        targetController.appendLastPage(totalFilteredItems);
      } else {
        final nextPageKey = pageKey + _pageSize;
        targetController.appendPage(totalFilteredItems, nextPageKey);
      }
    } else {
      final nextPageKey = pageKey + _pageSize;
      await _fetchNotificationsRecursively(
        nextPageKey,
        type,
        accumulatedItems: totalFilteredItems,
      );
    }
  }

  Future<void> updateNotificationStatues(String id) async {
    loading(true);
    try {
      final ApiService apiService = ApiService();
      const String url = ApiUrls.notificationUrl;

      final res = await apiService.patch(url: '$url/$id/TRUE');

      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception();
      }
      if (res.data != null) {
        for (var controller in pagingControllers) {
          final List<NotificationModel>? current = controller.itemList;
          if (current != null) {
            final idx = current.indexWhere((n) => n.id == id);
            if (idx != -1) {
              final updated = List<NotificationModel>.from(current);
              updated[idx] = updated[idx].rebuild((b) => b..isSeen = "TRUE");
              controller.itemList = updated;
            }
          }
        }
      }

      final controller = Get.find<ProfileController>();
      if (controller.notificationCount.value > 0) {
        controller.notificationCount.value--;
      }
    } catch (_) {
    } finally {
      loading(false);
    }
  }

  Future<void> handleNotificationClick(NotificationModel notification) async {
    if (notification.isSeen == "FALSE") {
      await updateNotificationStatues(notification.id);
    }
    final typeStr = notification.data?.type;
    final isAlert = notification.isAlert == "TRUE";

    if (typeStr == 'chat_message') {
      goToTargetChatPage(typeStr ?? '', notification);
    } else {
      goToTargetPage(typeStr ?? '', isAlert: isAlert);
    }
  }

  Future<void> markAllSeen() async {
    try {
      await _apiService.patch(url: ApiUrls.notificationMarkAllSeenUrl);
      final profileController = Get.find<ProfileController>();
      profileController.notificationCount.value = 0;
    } catch (e) {
      // ignore
    }
  }
}
