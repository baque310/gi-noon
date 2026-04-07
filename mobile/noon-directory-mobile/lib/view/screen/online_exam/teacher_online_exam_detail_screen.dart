import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/teacher_online_exam_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/core/function.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:intl/intl.dart';

class TeacherOnlineExamDetailScreen extends StatefulWidget {
  const TeacherOnlineExamDetailScreen({super.key});

  @override
  State<TeacherOnlineExamDetailScreen> createState() =>
      _TeacherOnlineExamDetailScreenState();
}

class _TeacherOnlineExamDetailScreenState
    extends State<TeacherOnlineExamDetailScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<TeacherOnlineExamController>();
  late TabController _tabController;
  Map<String, dynamic>? exam;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    exam = Get.arguments as Map<String, dynamic>?;
    if (exam != null && exam!['id'] != null) {
      controller.fetchExamById(exam!['id']);
    }
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
        appBarName: 'تفاصيل الامتحان',
        isLeading: true,
        press: () => Get.back(),
      ),
      body: Obx(() {
        final examData = controller.currentExam.value;
        if (controller.isLoading.value && examData == null) {
          return const Loading();
        }
        if (examData == null) {
          return const Center(child: Text('لا توجد بيانات'));
        }

        return Column(
          children: [
            // Exam Info Header
            _buildExamHeader(examData),

            // Tabs
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle: AppTextStyles.bold12,
                unselectedLabelStyle: AppTextStyles.medium12,
                tabs: const [
                  Tab(text: 'الأسئلة'),
                  Tab(text: 'الطلاب'),
                  Tab(text: 'الإحصائيات'),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildQuestionsTab(examData),
                  _buildStudentsTab(examData),
                  _buildStatisticsTab(examData),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // ============================================
  // Exam Header
  // ============================================
  Widget _buildExamHeader(Map<String, dynamic> examData) {
    final title = examData['title'] ?? '';
    final examType = examData['examType'] ?? 'MCQ';
    final totalMarks = examData['totalMarks'] ?? 0;
    final duration = examData['duration'] ?? 0;
    final startDate = DateTime.tryParse(examData['startDate'] ?? '');
    final status = controller.getExamStatus(examData);

    final teacherSubject = examData['teacherSubject'];
    final subjectName =
        teacherSubject?['StageSubject']?['Subject']?['name'] ?? '';
    final stageName =
        teacherSubject?['StageSubject']?['Stage']?['name'] ?? '';

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.mainColor,
            AppColors.mainColor.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bold16.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$subjectName • ${translateStage(stageName)}',
                      style: AppTextStyles.medium12.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(status),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildHeaderChip(Icons.timer_outlined, '$duration دقيقة'),
              _buildHeaderChip(
                  Icons.star_outline_rounded, '$totalMarks درجة'),
              _buildHeaderChip(
                Icons.category_outlined,
                examType == 'MCQ' ? 'اختيار متعدد' : 'ورقي',
              ),
              if (startDate != null)
                _buildHeaderChip(
                  Icons.play_arrow_rounded,
                  DateFormat('MM/dd hh:mm a').format(startDate),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    String label;
    Color color;
    switch (status) {
      case 'active':
        label = 'نشط';
        color = Colors.greenAccent;
        break;
      case 'ended':
        label = 'انتهى';
        color = Colors.redAccent.shade100;
        break;
      default:
        label = 'قادم';
        color = Colors.lightBlueAccent;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.bold12.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildHeaderChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.9)),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.medium12.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // Questions Tab
  // ============================================
  Widget _buildQuestionsTab(Map<String, dynamic> examData) {
    final questions =
        (examData['OnlineExamQuestion'] as List?)?.cast<Map<String, dynamic>>() ??
            [];

    if (questions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz_outlined, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              examData['examType'] == 'PAPER'
                  ? 'امتحان ورقي - لا توجد أسئلة MCQ'
                  : 'لا توجد أسئلة',
              style: AppTextStyles.medium14.copyWith(
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      itemCount: questions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        final q = questions[index];
        return _buildQuestionCard(q, index);
      },
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> q, int index) {
    final correctAnswer = q['correctAnswer'] ?? '';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.mainColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'سؤال ${index + 1}',
                  style: AppTextStyles.bold12.copyWith(
                    color: AppColors.mainColor,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${q['marks'] ?? 0} درجة',
                  style: AppTextStyles.bold12.copyWith(
                    color: Colors.amber.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            q['questionText'] ?? '',
            style: AppTextStyles.medium14.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 12),
          ...['A', 'B', 'C', 'D'].map((option) {
            final isCorrect = correctAnswer == option;
            final optionText = q['option$option'] ?? '';
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isCorrect
                    ? Colors.green.withValues(alpha: 0.08)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isCorrect
                      ? Colors.green.withValues(alpha: 0.3)
                      : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isCorrect
                          ? Colors.green
                          : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isCorrect
                          ? const Icon(Icons.check,
                              size: 14, color: Colors.white)
                          : Text(option,
                              style: AppTextStyles.bold12.copyWith(
                                  color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      optionText,
                      style: AppTextStyles.medium14.copyWith(
                        color: isCorrect
                            ? Colors.green.shade700
                            : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ============================================
  // Students Tab
  // ============================================
  Widget _buildStudentsTab(Map<String, dynamic> examData) {
    final students = (examData['OnlineExamStudent'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        [];

    if (students.isEmpty) {
      return Center(
        child: Text(
          'لا يوجد طلاب مسجلين',
          style: AppTextStyles.medium14.copyWith(
            color: Colors.grey.shade400,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      itemCount: students.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, index) {
        final student = students[index];
        return _buildStudentCard(student, examData, index);
      },
    );
  }

  Widget _buildStudentCard(
      Map<String, dynamic> student, Map<String, dynamic> examData, int index) {
    final studentInfo = student['Student'] as Map<String, dynamic>? ?? {};
    final fullName = studentInfo['fullName'] ?? 'طالب ${index + 1}';
    final status = student['status'] ?? 'NOT_STARTED';
    final totalScore = student['totalScore'];
    final totalMarks = examData['totalMarks'] ?? 100;

    Color statusColor;
    String statusLabel;
    IconData statusIcon;

    switch (status) {
      case 'GRADED':
        final passed = examData['passingMarks'] != null &&
            totalScore != null &&
            totalScore >= (examData['passingMarks'] as num);
        statusColor = passed ? Colors.green : Colors.red;
        statusLabel = passed ? 'ناجح' : 'راسب';
        statusIcon = passed ? Icons.check_circle : Icons.cancel;
        break;
      case 'SUBMITTED':
        statusColor = Colors.blue;
        statusLabel = 'تم التسليم';
        statusIcon = Icons.upload_file;
        break;
      case 'IN_PROGRESS':
        statusColor = Colors.orange;
        statusLabel = 'قيد الامتحان';
        statusIcon = Icons.pending;
        break;
      default:
        statusColor = Colors.grey;
        statusLabel = 'لم يبدأ';
        statusIcon = Icons.schedule;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  statusColor.withValues(alpha: 0.2),
                  statusColor.withValues(alpha: 0.05),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: AppTextStyles.bold14.copyWith(color: statusColor),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fullName, style: AppTextStyles.bold14),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(statusIcon, size: 14, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      statusLabel,
                      style: AppTextStyles.medium12.copyWith(
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Score
          if (totalScore != null)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$totalScore/$totalMarks',
                style: AppTextStyles.bold14.copyWith(color: statusColor),
              ),
            ),

          // Grade button for SUBMITTED status (Paper type)
          if (status == 'SUBMITTED' && examData['examType'] == 'PAPER')
            IconButton(
              onPressed: () => _showGradeDialog(student),
              icon: Icon(Icons.grading, color: AppColors.mainColor),
            ),
        ],
      ),
    );
  }

  void _showGradeDialog(Map<String, dynamic> student) {
    final scoreCtrl = TextEditingController();
    final feedbackCtrl = TextEditingController();

    final answers = student['OnlineExamStudentAnswer'] as List? ?? [];

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'تصحيح الإجابة',
          style: AppTextStyles.bold16,
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: scoreCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'الدرجة',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: feedbackCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'ملاحظات (اختياري)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(AppLanguage.cancel.tr),
          ),
          ElevatedButton(
            onPressed: () {
              if (answers.isNotEmpty) {
                final answerId = answers.first['id'];
                final score =
                    double.tryParse(scoreCtrl.text) ?? 0;
                controller.gradeAnswer(
                  answerId,
                  score,
                  feedbackCtrl.text,
                );
              }
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('حفظ',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ============================================
  // Statistics Tab
  // ============================================
  Widget _buildStatisticsTab(Map<String, dynamic> examData) {
    final students = (examData['OnlineExamStudent'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        [];
    final totalStudents = students.length;
    final submitted = students.where((s) {
      final status = s['status'];
      return status == 'SUBMITTED' || status == 'GRADED';
    }).length;
    final graded = students.where((s) => s['status'] == 'GRADED').length;
    final notStarted =
        students.where((s) => s['status'] == 'NOT_STARTED').length;
    final inProgress =
        students.where((s) => s['status'] == 'IN_PROGRESS').length;

    // Calculate average score
    double avgScore = 0;
    int gradedWithScore = 0;
    for (var s in students) {
      if (s['totalScore'] != null) {
        avgScore += (s['totalScore'] as num).toDouble();
        gradedWithScore++;
      }
    }
    if (gradedWithScore > 0) avgScore /= gradedWithScore;

    // Pass/Fail count
    final passingMarks = examData['passingMarks'] ?? 0;
    int passed = 0;
    int failed = 0;
    for (var s in students) {
      if (s['totalScore'] != null) {
        if ((s['totalScore'] as num) >= passingMarks) {
          passed++;
        } else {
          failed++;
        }
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'إجمالي الطلاب',
                  '$totalStudents',
                  Icons.people_outline,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'أكملوا الامتحان',
                  '$submitted',
                  Icons.check_circle_outline,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'لم يبدأوا',
                  '$notStarted',
                  Icons.schedule,
                  Colors.grey,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'قيد الامتحان',
                  '$inProgress',
                  Icons.pending,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'المعدل',
                  avgScore > 0 ? avgScore.toStringAsFixed(1) : '-',
                  Icons.analytics_outlined,
                  AppColors.mainColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'تم التصحيح',
                  '$graded',
                  Icons.grading,
                  Colors.teal,
                ),
              ),
            ],
          ),

          // Pass/Fail section
          if (gradedWithScore > 0) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text('نسبة النجاح', style: AppTextStyles.bold16),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCircleStat(
                        'ناجح',
                        passed,
                        gradedWithScore,
                        Colors.green,
                      ),
                      _buildCircleStat(
                        'راسب',
                        failed,
                        gradedWithScore,
                        Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.bold16.copyWith(
              fontSize: 24,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.medium12.copyWith(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleStat(
      String label, int count, int total, Color color) {
    final percentage =
        total > 0 ? (count / total * 100).toStringAsFixed(0) : '0';
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: total > 0 ? count / total : 0,
                strokeWidth: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
            Text(
              '$percentage%',
              style: AppTextStyles.bold16.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '$label ($count)',
          style: AppTextStyles.medium12.copyWith(color: color),
        ),
      ],
    );
  }
}
