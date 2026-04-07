import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/online_exam_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/view/screen/home/pages/assignments/student/online_exam_detail_screen.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:intl/intl.dart';

class OnlineExamSection extends StatelessWidget {
  OnlineExamSection({super.key});

  final controller = Get.put(OnlineExamController());

  @override
  Widget build(BuildContext context) {
    controller.fetchExams();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Loading();
      }

      if (controller.exams.isEmpty) {
        return NoDataWidget(title: AppLanguage.noOnlineExams.tr);
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchExams(),
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: controller.exams.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final exam = controller.exams[index];
            return _ExamCard(exam: exam, controller: controller);
          },
        ),
      );
    });
  }
}

class _ExamCard extends StatelessWidget {
  final Map<String, dynamic> exam;
  final OnlineExamController controller;

  const _ExamCard({required this.exam, required this.controller});

  @override
  Widget build(BuildContext context) {
    final status = controller.getExamStatus(exam);
    final studentStatus = controller.getStudentStatus(exam);
    final score = controller.getStudentScore(exam);
    final examType = exam['examType'] ?? 'MCQ';
    final title = exam['title'] ?? '';
    final duration = exam['duration'] ?? 0;
    final totalMarks = exam['totalMarks'] ?? 0;
    final startDate = DateTime.tryParse(exam['startDate'] ?? '');
    final endDate = DateTime.tryParse(exam['endDate'] ?? '');
    final teacherSubject = exam['teacherSubject'];
    final subjectName = teacherSubject?['StageSubject']?['Subject']?['name'] ?? '';
    final teacherName = teacherSubject?['Teacher']?['fullName'] ?? '';
    final questionCount = (exam['OnlineExamQuestion'] as List?)?.length ?? 0;

    return GestureDetector(
      onTap: () {
        Get.to(() => OnlineExamDetailScreen(examId: exam['id']));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top accent bar
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _getStatusGradient(status),
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row + badges
                  Row(
                    children: [
                      // Exam type icon
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: examType == 'MCQ'
                              ? AppColors.primary.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          examType == 'MCQ' ? Icons.quiz_outlined : Icons.description_outlined,
                          color: examType == 'MCQ' ? AppColors.primary : Colors.orange,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppTextStyles.bold16.copyWith(
                                color: Colors.grey.shade900,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$subjectName • $teacherName',
                              style: AppTextStyles.regular12.copyWith(
                                color: Colors.grey.shade500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusBadge(status),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Info chips row
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildInfoChip(
                        icon: Icons.timer_outlined,
                        label: '$duration ${AppLanguage.minutesStr.tr}',
                        color: Colors.blue,
                      ),
                      _buildInfoChip(
                        icon: Icons.star_outline_rounded,
                        label: '$totalMarks ${AppLanguage.scoreStr.tr}',
                        color: Colors.amber.shade700,
                      ),
                      if (examType == 'MCQ')
                        _buildInfoChip(
                          icon: Icons.format_list_numbered,
                          label: '$questionCount ${AppLanguage.questionStr.tr}',
                          color: Colors.purple,
                        ),
                      _buildTypeBadge(examType),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Date row
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 6),
                        Text(
                          startDate != null ? DateFormat('MM/dd - hh:mm a').format(startDate) : '-',
                          style: AppTextStyles.medium12.copyWith(color: Colors.grey.shade700),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.arrow_forward, size: 14, color: Colors.grey.shade400),
                        ),
                        Text(
                          endDate != null ? DateFormat('MM/dd - hh:mm a').format(endDate) : '-',
                          style: AppTextStyles.medium12.copyWith(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),

                  // Student status / score
                  if (studentStatus != 'NOT_STARTED') ...[
                    const SizedBox(height: 12),
                    _buildStudentStatusRow(studentStatus, score, totalMarks, exam),
                  ],
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
        label = AppLanguage.examActive.tr;
        color = Colors.green;
        icon = Icons.play_circle_outline;
        break;
      case 'ended':
        label = AppLanguage.examEnded.tr;
        color = Colors.red;
        icon = Icons.check_circle_outline;
        break;
      default:
        label = AppLanguage.examUpcoming.tr;
        color = Colors.blue;
        icon = Icons.schedule;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
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

  Widget _buildInfoChip({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
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

  Widget _buildTypeBadge(String examType) {
    final isMCQ = examType == 'MCQ';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isMCQ ? AppColors.primary.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isMCQ ? AppLanguage.mcqExam.tr : AppLanguage.paperExam.tr,
        style: AppTextStyles.bold12.copyWith(
          color: isMCQ ? AppColors.primary : Colors.orange,
        ),
      ),
    );
  }

  Widget _buildStudentStatusRow(String status, double? score, int totalMarks, Map<String, dynamic> exam) {
    Color statusColor;
    String statusLabel;
    IconData statusIcon;

    switch (status) {
      case 'GRADED':
        final passed = exam['passingMarks'] != null && score != null && score >= (exam['passingMarks'] as num);
        statusColor = passed ? Colors.green : Colors.red;
        statusLabel = passed ? AppLanguage.passedStr.tr : AppLanguage.failedStr.tr;
        statusIcon = passed ? Icons.check_circle : Icons.cancel;
        break;
      case 'SUBMITTED':
        statusColor = Colors.blue;
        statusLabel = AppLanguage.submitExam.tr;
        statusIcon = Icons.upload_file;
        break;
      case 'IN_PROGRESS':
        statusColor = Colors.orange;
        statusLabel = AppLanguage.examInProgress.tr;
        statusIcon = Icons.pending;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, size: 18, color: statusColor),
          const SizedBox(width: 8),
          Text(statusLabel, style: AppTextStyles.bold12.copyWith(color: statusColor)),
          const Spacer(),
          if (score != null)
            Text(
              '${score.toStringAsFixed(0)}/$totalMarks',
              style: AppTextStyles.bold16.copyWith(color: statusColor),
            ),
        ],
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
}
