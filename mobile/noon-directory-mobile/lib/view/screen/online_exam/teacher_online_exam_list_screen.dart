import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/teacher_online_exam_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/core/function.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:intl/intl.dart';

class TeacherOnlineExamListScreen extends StatefulWidget {
  const TeacherOnlineExamListScreen({super.key});

  @override
  State<TeacherOnlineExamListScreen> createState() =>
      _TeacherOnlineExamListScreenState();
}

class _TeacherOnlineExamListScreenState
    extends State<TeacherOnlineExamListScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(TeacherOnlineExamController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    controller.fetchExams(refresh: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: CustomAppBar(
        appBarName: 'الامتحان الإلكتروني',
        isLeading: true,
        press: () => Get.back(),
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
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
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey.shade600,
              labelStyle: AppTextStyles.bold14,
              unselectedLabelStyle: AppTextStyles.medium14,
              tabs: const [
                Tab(text: 'الامتحانات الحالية'),
                Tab(text: 'أرشيف الامتحانات'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCurrentExamsTab(),
                _buildArchiveTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.mainColor,
            AppColors.mainColor.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainColor.withValues(alpha: 0.35),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () {
          controller.clearCreateForm();
          controller.fetchCreateStages();
          Get.toNamed(ScreensUrls.teacherCreateOnlineExamScreenUrl);
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'إنشاء امتحان',
          style: AppTextStyles.bold14.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  // ============================================
  // Current Exams Tab
  // ============================================
  Widget _buildCurrentExamsTab() {
    return Obx(() {
      if (controller.isLoading.value && controller.exams.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final activeExams = controller.exams.where((exam) {
        final status = controller.getExamStatus(exam);
        return status == 'active' || status == 'upcoming';
      }).toList();

      if (activeExams.isEmpty) {
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
                  size: 64,
                  color: AppColors.mainColor.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'لا توجد امتحانات حالية',
                style: AppTextStyles.bold16.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'أنشئ امتحان جديد لطلابك',
                style: AppTextStyles.regular14.copyWith(
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchExams(refresh: true),
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          itemCount: activeExams.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (_, index) {
            return _OnlineExamCard(
              exam: activeExams[index],
              controller: controller,
            );
          },
        ),
      );
    });
  }

  // ============================================
  // Archive Tab
  // ============================================
  Widget _buildArchiveTab() {
    return Obx(() {
      if (controller.isLoading.value && controller.exams.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final archivedExams = controller.exams.where((exam) {
        final status = controller.getExamStatus(exam);
        return status == 'ended';
      }).toList();

      if (archivedExams.isEmpty) {
        return Center(
          child: NoDataWidget(title: 'لا توجد امتحانات سابقة'),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchExams(refresh: true),
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          itemCount: archivedExams.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (_, index) {
            return _OnlineExamCard(
              exam: archivedExams[index],
              controller: controller,
              isArchive: true,
            );
          },
        ),
      );
    });
  }
}

// ============================================
// Online Exam Card Widget
// ============================================
class _OnlineExamCard extends StatelessWidget {
  final Map<String, dynamic> exam;
  final TeacherOnlineExamController controller;
  final bool isArchive;

  const _OnlineExamCard({
    required this.exam,
    required this.controller,
    this.isArchive = false,
  });

  @override
  Widget build(BuildContext context) {
    final status = controller.getExamStatus(exam);
    final title = exam['title'] ?? '';
    final examType = exam['examType'] ?? 'MCQ';
    final duration = exam['duration'] ?? 0;
    final totalMarks = exam['totalMarks'] ?? 0;
    final startDate = DateTime.tryParse(exam['startDate'] ?? '');
    final endDate = DateTime.tryParse(exam['endDate'] ?? '');
    final submittedCount = controller.getSubmittedCount(exam);
    final totalStudents = controller.getTotalStudents(exam);
    final questionCount = controller.getQuestionCount(exam);

    // Teacher/Subject info
    final teacherSubject = exam['teacherSubject'];
    final subjectName = teacherSubject?['StageSubject']?['Subject']?['name'] ?? '';
    final stageName = teacherSubject?['StageSubject']?['Stage']?['name'] ?? '';
    final className = teacherSubject?['StageSubject']?['Class']?['name'] ?? '';

    return GestureDetector(
      onTap: () => Get.toNamed(
        ScreensUrls.teacherOnlineExamDetailScreenUrl,
        arguments: exam,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Status Bar
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _getStatusGradient(status),
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    children: [
                      // Icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: examType == 'MCQ'
                                ? [
                                    AppColors.primary.withValues(alpha: 0.15),
                                    AppColors.primary.withValues(alpha: 0.05),
                                  ]
                                : [
                                    Colors.orange.withValues(alpha: 0.15),
                                    Colors.orange.withValues(alpha: 0.05),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          examType == 'MCQ'
                              ? Icons.quiz_outlined
                              : Icons.description_outlined,
                          color: examType == 'MCQ'
                              ? AppColors.primary
                              : Colors.orange,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppTextStyles.bold16,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$subjectName • ${translateStage(stageName)} • $className',
                              style: AppTextStyles.regular12.copyWith(
                                color: Colors.grey.shade500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      _buildStatusBadge(status),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Info Row
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildInfoChip(
                        icon: Icons.timer_outlined,
                        label: '$duration دقيقة',
                        color: Colors.blue,
                      ),
                      _buildInfoChip(
                        icon: Icons.star_outline_rounded,
                        label: '$totalMarks درجة',
                        color: Colors.amber.shade700,
                      ),
                      if (examType == 'MCQ')
                        _buildInfoChip(
                          icon: Icons.format_list_numbered,
                          label: '$questionCount سؤال',
                          color: Colors.purple,
                        ),
                      _buildInfoChip(
                        icon: Icons.people_outline,
                        label: '$submittedCount/$totalStudents',
                        color: Colors.teal,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Date Row
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 6),
                        Text(
                          startDate != null
                              ? DateFormat('MM/dd - hh:mm a').format(startDate)
                              : '-',
                          style: AppTextStyles.medium12.copyWith(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.arrow_forward,
                              size: 14, color: Colors.grey.shade400),
                        ),
                        Text(
                          endDate != null
                              ? DateFormat('MM/dd - hh:mm a').format(endDate)
                              : '-',
                          style: AppTextStyles.medium12.copyWith(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Progress bar for submissions
                  if (totalStudents > 0) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: totalStudents > 0
                                  ? submittedCount / totalStudents
                                  : 0,
                              minHeight: 6,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation(
                                submittedCount == totalStudents
                                    ? Colors.green
                                    : AppColors.mainColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '$submittedCount/$totalStudents أكملوا',
                          style: AppTextStyles.medium12.copyWith(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Actions
            if (!isArchive)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionButton(
                      icon: Icons.visibility_outlined,
                      label: 'التفاصيل',
                      color: AppColors.mainColor,
                      onTap: () => Get.toNamed(
                        ScreensUrls.teacherOnlineExamDetailScreenUrl,
                        arguments: exam,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _buildActionButton(
                      icon: Icons.delete_outline,
                      label: 'حذف',
                      color: Colors.red,
                      onTap: () => _confirmDelete(exam['id']),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    String label;
    Color color;
    IconData icon;

    switch (status) {
      case 'active':
        label = 'نشط';
        color = Colors.green;
        icon = Icons.play_circle_outline;
        break;
      case 'ended':
        label = 'انتهى';
        color = Colors.red;
        icon = Icons.check_circle_outline;
        break;
      default:
        label = 'قادم';
        color = Colors.blue;
        icon = Icons.schedule;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.bold12.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.medium12.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(label, style: AppTextStyles.medium12.copyWith(color: color)),
          ],
        ),
      ),
    );
  }

  List<Color> _getStatusGradient(String status) {
    switch (status) {
      case 'active':
        return [Colors.green.shade400, Colors.green.shade600];
      case 'ended':
        return [Colors.red.shade300, Colors.red.shade500];
      default:
        return [Colors.blue.shade300, Colors.blue.shade500];
    }
  }

  void _confirmDelete(String examId) {
    Get.defaultDialog(
      title: AppLanguage.deleteStr.tr,
      middleText: 'هل أنت متأكد من حذف هذا الامتحان؟',
      textConfirm: AppLanguage.deleteStr.tr,
      textCancel: AppLanguage.cancel.tr,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        controller.deleteExam(examId);
        Get.back();
      },
    );
  }
}
