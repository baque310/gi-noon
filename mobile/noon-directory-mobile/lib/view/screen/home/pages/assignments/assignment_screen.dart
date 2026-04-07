import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/view/screen/home/pages/assignments/teacher/teacher_homework_filter_screen.dart';
import 'package:noon/view/screen/home/pages/assignments/teacher/teacher_lessons_filter_screen.dart';
import '../../../../../core/localization/language.dart';
import '../../../../widget/custom_appbar_v2.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen>
    with SingleTickerProviderStateMixin {
  final gController = Get.put(GlobalController());
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.neutralBackground,
        appBar: CustomAppBarV2(
          appBarName: AppLanguage.assignmentStr.tr,
          isLeading: gController.isTeacher ? true : false,
          // isLeading: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              margin: const .symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: .circular(16),
                border: .all(
                  width: 0.5,
                  color: AppColors.blackColor.withValues(alpha: 0.12),
                ),
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: AppColors.secondryOringe,
                  borderRadius: .circular(16),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: AppLanguage.assignmentStr.tr),
                  Tab(text: AppLanguage.completedLessons.tr),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const TeacherHomeworkFilterScreen(),
                  const TeacherLessonsFilterScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
