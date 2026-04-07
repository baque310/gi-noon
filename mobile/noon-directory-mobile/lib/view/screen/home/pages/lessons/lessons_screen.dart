import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/view/screen/home/pages/assignments/student/homework_completed_section.dart';
import 'package:noon/view/screen/home/pages/assignments/teacher/teacher_lessons_section.dart';
import '../../../../../core/localization/language.dart';
import '../../../../widget/custom_appbar_v2.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen>
    with SingleTickerProviderStateMixin {
  final gController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.neutralBackground,
        appBar: CustomAppBarV2(
          appBarName: AppLanguage.lessons.tr,
          isLeading: gController.isTeacher ? true : false,
          // isLeading: true,
        ),
        body: Padding(
          padding: const .symmetric(horizontal: 16),
          child: Builder(
            builder: (context) {
              if (gController.isStudent || gController.isParent) {
                return HomeWorksCompletedSection();
              } else {
                return TeacherLessonSection();
              }
            },
          ),
        ),
      ),
    );
  }
}
