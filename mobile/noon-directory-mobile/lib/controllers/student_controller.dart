import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/student_model.dart';
import '../core/localization/language.dart';

class StudentController extends GetxController {
  final List<StudentModel> students = [];
  final selectedStudentsIds = RxList<String>();

  Future<void> getStudents({List<String>? sectionIds}) async {
    try {
      EasyLoading.show();
      selectedStudentsIds.clear();
      students.clear();

      if (sectionIds == null || sectionIds.isEmpty) return;

      final futures = sectionIds.map(
        (id) => ApiService().get(
          url: ApiUrls.studentsList,
          queryParameters: {"sectionId": id},
        ),
      );

      final responses = await Future.wait(futures);

      for (var res in responses) {
        final items = List<StudentModel>.from(
          res.data.map((e) {
            return StudentModel.fromJson(jsonEncode(e));
          }),
        );
        students.addAll(items);
      }

      final uniqueStudents = {for (var s in students) s.id: s}.values.toList();
      students.clear();
      students.addAll(uniqueStudents);
    } catch (e) {
      Get.snackbar(AppLanguage.errorStr.tr, AppLanguage.unexpectedErrorStr.tr);
    } finally {
      EasyLoading.dismiss();
    }
  }

  final searchQuery = ''.obs;
  final searchController = TextEditingController();

  List<StudentModel> get filteredStudents {
    if (searchQuery.value.isEmpty) {
      return students;
    }
    return students
        .where(
          (student) => student.fullName.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ),
        )
        .toList();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void toggleStudentSelection(StudentModel? student) {
    if (student == null) {
      if (isAllStudentsSelected) {
        for (var s in filteredStudents) {
          selectedStudentsIds.remove(s.id);
        }
      } else {
        for (var s in filteredStudents) {
          if (!selectedStudentsIds.contains(s.id)) {
            selectedStudentsIds.add(s.id);
          }
        }
      }
      return;
    }

    if (selectedStudentsIds.contains(student.id)) {
      selectedStudentsIds.remove(student.id);
    } else {
      selectedStudentsIds.add(student.id);
    }
  }

  bool get isAllStudentsSelected {
    if (filteredStudents.isEmpty) return false;
    return filteredStudents.every((s) => selectedStudentsIds.contains(s.id));
  }

  bool isStudentSelected(StudentModel student) {
    return selectedStudentsIds.contains(student.id);
  }
}
