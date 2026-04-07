// [تحديث التصميم]: تم دمج الواجبات والدروس المنجزة والامتحان الإلكتروني في شاشة واحدة بنظام التبويبات (Tabs).
// تم استخدام تصميم Pill-style لزيادة احترافية الواجهة وتسهيل التنقل.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/controllers/home_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/view/screen/home/pages/assignments/student/homework_completed_section.dart';
import 'package:noon/view/screen/home/pages/assignments/student/homework_section.dart';
import 'package:noon/view/screen/home/pages/assignments/student/online_exam_section.dart';
import 'package:noon/view/screen/home/pages/assignments/teacher/teacher_lessons_section.dart';
import 'package:noon/view/widget/custom_appbar_v2.dart';
import 'package:noon/core/constant/screens_urls.dart';

class AssignmentsTabsScreen extends StatefulWidget {
  const AssignmentsTabsScreen({super.key});

  @override
  State<AssignmentsTabsScreen> createState() => _AssignmentsTabsScreenState();
}

class _AssignmentsTabsScreenState extends State<AssignmentsTabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final gController = Get.find<GlobalController>();
  late Worker _worker;

  @override
  void initState() {
    super.initState();
    final ctrl = Get.find<HomeController>();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: ctrl.assignmentTabIndex.value.clamp(0, 2),
    );

    // Listen to changes from controller
    _worker = ever(ctrl.assignmentTabIndex, (int index) {
      if (_tabController.index != index && index < 3) {
        _tabController.animateTo(index);
      }
    });

    // Update controller when user swipes
    _tabController.addListener(() {
      if (!ctrl.assignmentTabIndex.value.isEqual(_tabController.index)) {
        ctrl.assignmentTabIndex.value = _tabController.index;
      }
    });
  }

  @override
  void dispose() {
    _worker.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBackground,
      appBar: CustomAppBarV2(
        appBarName: AppLanguage.homework.tr, // Combined title
        isLeading: false,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey.shade600,
              labelStyle: AppTextStyles.bold12,
              unselectedLabelStyle: AppTextStyles.medium12,
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              tabs: [
                Tab(text: AppLanguage.homework.tr),
                Tab(text: AppLanguage.completedLessons.tr),
                Tab(text: AppLanguage.onlineExam.tr),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: HomeworksSection(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Builder(
                    builder: (context) {
                      if (gController.isTeacher) {
                        // For teachers, show a shortcut to the full online exam management
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor.withValues(alpha: 0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.quiz_outlined,
                                  size: 60,
                                  color: AppColors.mainColor,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'إدارة الامتحانات الإلكترونية',
                                style: AppTextStyles.bold16.copyWith(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'أنشئ وأدر امتحاناتك الإلكترونية من هنا',
                                style: AppTextStyles.regular14.copyWith(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () => Get.toNamed(
                                  ScreensUrls.teacherOnlineExamScreenUrl,
                                ),
                                icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                                label: Text(
                                  'الذهاب إلى الامتحانات',
                                  style: AppTextStyles.bold14.copyWith(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.mainColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return OnlineExamSection();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
