import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/failures.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/models/student_model.dart';
import 'package:dio/dio.dart';

class SectionStudentsController extends GetxController {
  final _apiService = ApiService();

  // Pagination
  final pagingController = PagingController<int, StudentModel>(firstPageKey: 1);
  static const _pageSize = 20;

  // Search
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  // Section filter
  final sections = <Section>[].obs;
  final selectedSection = Rxn<Section>(null);
  final isLoadingSections = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTeacherSections();

    searchController.addListener(() {
      searchQuery.value = searchController.text;
      if (selectedSection.value != null) {
        pagingController.refresh();
      }
    });
  }

  void _initializePagingController() {
    pagingController.addPageRequestListener((pageKey) {
      fetchStudents(pageKey);
    });
  }

  @override
  void onClose() {
    pagingController.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchTeacherSections() async {
    try {
      isLoadingSections(true);

      final stagesRes = await _apiService.get(url: ApiUrls.teacherStageUrl);
      if (stagesRes.data == null || stagesRes.data.isEmpty) {
        sections.clear();
        return;
      }

      final allSections = <Section>[];
      for (var stage in stagesRes.data) {
        final stageId = stage['id'];

        final classesRes = await _apiService.get(
          url: '${ApiUrls.teacherClassUrl}/$stageId',
        );

        if (classesRes.data != null) {
          for (var classData in classesRes.data) {
            final classId = classData['id'];

            final sectionsRes = await _apiService.get(
              url: '${ApiUrls.teacherSectionUrl}/$classId',
            );

            if (sectionsRes.data != null) {
              final classSections = List<Section>.from(
                sectionsRes.data.map((s) => Section.fromJson(jsonEncode(s))),
              );
              allSections.addAll(classSections);
            }
          }
        }
      }

      sections.value = allSections;

      if (sections.isNotEmpty) {
        selectedSection.value = sections.first;
        _initializePagingController();
        pagingController.refresh();
      }
    } catch (e) {
      dprint('Error fetching teacher sections: $e');
      sections.clear();
    } finally {
      isLoadingSections(false);
    }
  }

  Future<void> fetchStudents(int pageKey) async {
    try {
      if (selectedSection.value == null) {
        pagingController.error = 'Please select a section';
        return;
      }

      final queryParams = {'sectionId': selectedSection.value!.id};

      final res = await _apiService.get(
        url: ApiUrls.studentsList,
        queryParameters: queryParams,
      );

      if (res.data == null) {
        pagingController.appendLastPage([]);
        return;
      }

      var students = List<StudentModel>.from(
        res.data.map((e) => StudentModel.fromJson(jsonEncode(e))),
      );

      if (searchQuery.value.isNotEmpty) {
        students = students.where((student) {
          return student.fullName.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          );
        }).toList();
      }

      final startIndex = (pageKey - 1) * _pageSize;
      final endIndex = startIndex + _pageSize;

      if (startIndex >= students.length) {
        pagingController.appendLastPage([]);
        return;
      }

      final pageItems = students.sublist(
        startIndex,
        endIndex > students.length ? students.length : endIndex,
      );

      final isLastPage = endIndex >= students.length;
      if (isLastPage) {
        pagingController.appendLastPage(pageItems);
      } else {
        pagingController.appendPage(pageItems, pageKey + 1);
      }
    } catch (e) {
      dprint('Error fetching students: $e');
      String error = 'Failed to load students';
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      pagingController.error = error;
    }
  }

  void onSectionChanged(Section? section) {
    selectedSection.value = section;
    pagingController.refresh();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }
}
