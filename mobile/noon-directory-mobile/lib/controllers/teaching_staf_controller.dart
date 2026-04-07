import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/failures.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/teaching_staff_model.dart';

class TeachingStafController extends GetxController {
  final pagingController = PagingController<int, TeachingStaffModel>(
    firstPageKey: 1,
  );
  static const _pageSize = 8;
  final _apiService = ApiService();
  final controller = Get.find<GlobalController>();
  final searchController = TextEditingController();

  RxBool loading = false.obs;
  RxString searchQuery = ''.obs;

  List<TeachingStaffModel> allTeachers = [];
  List<TeachingStaffModel> filteredTeachers = [];

  @override
  void onInit() {
    pagingController.addPageRequestListener((pageKey) {
      getTeachers(pageKey);
    });

    // Add search listener
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      _performSearch();
    });

    super.onInit();
  }

  @override
  void onClose() {
    pagingController.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future getTeachers(int pageKey) async {
    loading(true);
    try {
      double pageCount = (pageKey - 1) / _pageSize + 1;
      final res = await _apiService.get(
        url: controller.isStudent
            ? ApiUrls.teachingStaffUrl
            : '${ApiUrls.teachingStaffForParentUrl}/${controller.selectedStudentIdForParent.value!}',
        queryParameters: {"skip": pageCount, "take": _pageSize},
      );

      final items = List<TeachingStaffModel>.from(
        res.data['data'].map((e) => TeachingStaffModel.fromJson(jsonEncode(e))),
      );

      // Dedupe teacherSubject list INSIDE each staff item by subject name (keep first occurrence)
      final dedupedItems = items.map((staff) {
        final tsList = staff.teacherSubject;
        if (tsList == null || tsList.isEmpty) return staff;
        final seen = <String>{};
        final filtered = tsList.where((ts) {
          final subjectName = ts.stageSubject?.subject?.name?.trim();
          if (subjectName == null || subjectName.isEmpty) {
            // Keep entries without a subject name (cannot classify as duplicate)
            return true;
          }
          if (seen.contains(subjectName.toLowerCase())) {
            return false;
          }
          seen.add(subjectName.toLowerCase());
          return true;
        }).toList();
        // Rebuild staff with filtered teacherSubject list
        return staff.rebuild((b) {
          b.teacherSubject
            ..clear()
            ..addAll(filtered);
        });
      }).toList();

      // Store all teachers for search functionality
      if (pageKey == 1) {
        allTeachers.clear();
      }
      allTeachers.addAll(dedupedItems);

      // Apply search filter if there's a search query
      final itemsToShow = searchQuery.value.isEmpty
          ? dedupedItems
          : _filterTeachers(dedupedItems);

      final bool isLastPage = dedupedItems.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(itemsToShow);
      } else {
        final nextPageKey = pageKey + dedupedItems.length;
        pagingController.appendPage(itemsToShow, nextPageKey);
      }
    } catch (e) {
      dprint("Error in Get Teaching Staff  ...");
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

  void _performSearch() {
    if (searchQuery.value.isEmpty) {
      pagingController.refresh();
    } else {
      filteredTeachers = _filterTeachers(allTeachers);
      pagingController.value = PagingState(
        nextPageKey: null,
        error: null,
        itemList: filteredTeachers,
      );
    }
  }

  List<TeachingStaffModel> _filterTeachers(List<TeachingStaffModel> teachers) {
    final query = searchQuery.value.toLowerCase().trim();
    if (query.isEmpty) return teachers;

    return teachers.where((teacher) {
      final fullName = teacher.fullName?.toLowerCase() ?? '';
      if (fullName.contains(query)) return true;

      final subjects =
          teacher.teacherSubject
              ?.map((e) => e.stageSubject?.subject?.name?.toLowerCase() ?? '')
              .where((name) => name.isNotEmpty)
              .toList() ??
          [];

      return subjects.any((subject) => subject.contains(query));
    }).toList();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    pagingController.refresh();
  }
}
