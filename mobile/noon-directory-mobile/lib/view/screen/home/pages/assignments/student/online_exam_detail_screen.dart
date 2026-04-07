import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/online_exam_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/view/widget/custom_appbar_v2.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:intl/intl.dart';
import 'package:noon/core/extensions/string_extension.dart';
import 'package:noon/view/screen/pdf_viewer_screen.dart';

class OnlineExamDetailScreen extends StatefulWidget {
  final String examId;
  const OnlineExamDetailScreen({super.key, required this.examId});

  @override
  State<OnlineExamDetailScreen> createState() => _OnlineExamDetailScreenState();
}

class _OnlineExamDetailScreenState extends State<OnlineExamDetailScreen> {
  final controller = Get.find<OnlineExamController>();
  Timer? _timer;
  final _remainingSeconds = 0.obs;
  final _currentQuestionIndex = 0.obs;
  final _examStarted = false.obs;
  bool _autoSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetExam();
      controller.fetchExamById(widget.examId).then((_) {
        _checkIfAlreadyStarted();
      });
    });
  }

  /// Check if the student already started this exam (IN_PROGRESS)
  void _checkIfAlreadyStarted() {
    final exam = controller.currentExam.value;
    if (exam == null) return;
    final studentStatus = controller.getStudentStatus(exam);
    if (studentStatus == 'IN_PROGRESS') {
      final remaining = _calculateRemainingSeconds(exam);
      if (remaining > 0) {
        _examStarted.value = true;
        _startTimerWithSeconds(remaining);
      } else {
        _examStarted.value = true;
        _performAutoSubmit(exam);
      }
    }
  }

  /// Calculate remaining seconds based on server startedAt + duration
  int _calculateRemainingSeconds(Map<String, dynamic> exam) {
    final studentData = exam['OnlineExamStudent'];
    if (studentData is List && studentData.isNotEmpty) {
      final startedAtStr = studentData[0]['startedAt'];
      if (startedAtStr != null) {
        final startedAt = DateTime.tryParse(startedAtStr.toString());
        if (startedAt != null) {
          final dur = exam['duration'] ?? 30;
          final endTime = startedAt.add(Duration(minutes: dur is int ? dur : 30));
          final diff = endTime.difference(DateTime.now()).inSeconds;
          return diff > 0 ? diff : 0;
        }
      }
    }
    final dur = exam['duration'] ?? 30;
    return (dur is int ? dur : 30) * 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimerWithSeconds(int seconds) {
    _timer?.cancel();
    _remainingSeconds.value = seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds.value > 0) {
        _remainingSeconds.value--;
      } else {
        t.cancel();
        _performAutoSubmit(controller.currentExam.value);
      }
    });
  }

  void _performAutoSubmit(Map<String, dynamic>? exam) async {
    if (_autoSubmitting) return;
    _autoSubmitting = true;
    final examType = exam?['examType'] ?? 'MCQ';
    if (examType == 'MCQ') {
      await controller.submitMCQAnswers(widget.examId);
    } else if (controller.uploadedFile.value != null) {
      await controller.submitPaperAnswer(widget.examId, controller.uploadedFile.value!);
    }
    Get.snackbar('⏰', AppLanguage.examTimeEnded.tr,
        backgroundColor: Colors.red.shade50, colorText: Colors.red.shade800,
        snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 4));
    controller.fetchExamById(widget.examId);
  }

  /// Show confirmation dialog before starting exam
  void _showStartConfirmation(Map<String, dynamic> exam) {
    final duration = exam['duration'] ?? 30;
    final totalMarks = exam['totalMarks'] ?? 0;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(Icons.warning_amber_rounded, color: Colors.orange.shade600, size: 48),
        title: Text(AppLanguage.startExam.tr, style: AppTextStyles.bold18),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.timer, color: Colors.orange.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${AppLanguage.examDuration.tr}: $duration ${AppLanguage.minutesStr.tr}',
                          style: AppTextStyles.bold14.copyWith(color: Colors.orange.shade800),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${AppLanguage.totalMarksStr.tr}: $totalMarks',
                          style: AppTextStyles.bold14.copyWith(color: Colors.orange.shade800),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              AppLanguage.examStartWarning.tr,
              style: AppTextStyles.medium14.copyWith(color: Colors.grey.shade700, height: 1.6),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(AppLanguage.cancel.tr, style: AppTextStyles.medium14.copyWith(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await controller.startExam(widget.examId);
              await controller.fetchExamById(widget.examId);
              final updatedExam = controller.currentExam.value;
              if (updatedExam != null) {
                _examStarted.value = true;
                final remaining = _calculateRemainingSeconds(updatedExam);
                _startTimerWithSeconds(remaining);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(AppLanguage.startExam.tr, style: AppTextStyles.bold14.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBackground,
      appBar: CustomAppBarV2(appBarName: AppLanguage.onlineExam.tr),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: Loading());

        final exam = controller.currentExam.value;
        if (exam == null) {
          return Center(child: Text(AppLanguage.noOnlineExams.tr, style: AppTextStyles.medium14));
        }

        final status = controller.getExamStatus(exam);
        final studentStatus = controller.getStudentStatus(exam);
        final examType = exam['examType'] ?? 'MCQ';

        // Already graded - show result
        if (studentStatus == 'GRADED' || studentStatus == 'SUBMITTED') {
          return _buildResultView(exam);
        }

        // Not started yet - show info + start button
        if (!_examStarted.value) {
          return _buildExamInfoView(exam, status, examType);
        }

        // Exam active - show questions/upload
        if (examType == 'MCQ') {
          return _buildMCQExamView(exam);
        } else {
          return _buildPaperExamView(exam);
        }
      }),
    );
  }

  // ======================== INFO VIEW ========================
  Widget _buildExamInfoView(Map<String, dynamic> exam, String status, String examType) {
    final title = exam['title'] ?? '';
    final description = exam['description'] ?? '';
    final duration = exam['duration'] ?? 0;
    final totalMarks = exam['totalMarks'] ?? 0;
    final passingMarks = exam['passingMarks'];
    final startDate = DateTime.tryParse(exam['startDate'] ?? '');
    final endDate = DateTime.tryParse(exam['endDate'] ?? '');
    final questions = (exam['OnlineExamQuestion'] as List?) ?? [];
    final teacherSubject = exam['teacherSubject'];
    final subjectName = teacherSubject?['StageSubject']?['Subject']?['name'] ?? '';
    final teacherName = teacherSubject?['Teacher']?['fullName'] ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: examType == 'MCQ'
                    ? [AppColors.primary, AppColors.primary.withOpacity(0.8)]
                    : [Colors.orange.shade600, Colors.orange.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: (examType == 'MCQ' ? AppColors.primary : Colors.orange).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        examType == 'MCQ' ? Icons.quiz_outlined : Icons.description_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: AppTextStyles.bold18.copyWith(color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(
                            '$subjectName • $teacherName',
                            style: AppTextStyles.regular14.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(description, style: AppTextStyles.regular14.copyWith(color: Colors.white70)),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Stats grid
          Row(
            children: [
              _infoCard(Icons.timer_outlined, '$duration', AppLanguage.minutesStr.tr, Colors.blue),
              const SizedBox(width: 12),
              _infoCard(Icons.star_rounded, '$totalMarks', AppLanguage.totalMarksStr.tr, Colors.amber.shade700),
              const SizedBox(width: 12),
              if (passingMarks != null)
                _infoCard(Icons.check_circle_outline, '$passingMarks', AppLanguage.passingMarksStr.tr, Colors.green),
            ],
          ),

          if (examType == 'MCQ') ...[
            const SizedBox(height: 12),
            _infoCard(Icons.format_list_numbered, '${questions.length}', AppLanguage.questionStr.tr, Colors.purple, fullWidth: true),
          ],

          const SizedBox(height: 20),

          // Date info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3)),
              ],
            ),
            child: Column(
              children: [
                _dateRow(Icons.play_arrow_rounded, AppLanguage.startExam.tr,
                    startDate != null ? DateFormat('yyyy/MM/dd - hh:mm a').format(startDate) : '-', Colors.green),
                Divider(color: Colors.grey.shade100, height: 20),
                _dateRow(Icons.stop_rounded, AppLanguage.examEnded.tr,
                    endDate != null ? DateFormat('yyyy/MM/dd - hh:mm a').format(endDate) : '-', Colors.red),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Start button
          if (status == 'active')
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => _showStartConfirmation(exam),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  shadowColor: AppColors.primary.withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    Text(AppLanguage.startExam.tr, style: AppTextStyles.bold16.copyWith(color: Colors.white)),
                  ],
                ),
              ),
            )
          else if (status == 'upcoming')
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule, color: Colors.blue.shade600),
                  const SizedBox(width: 8),
                  Text(AppLanguage.examNotStarted.tr, style: AppTextStyles.bold14.copyWith(color: Colors.blue.shade700)),
                ],
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timer_off, color: Colors.red.shade600),
                  const SizedBox(width: 8),
                  Text(AppLanguage.examEnded.tr, style: AppTextStyles.bold14.copyWith(color: Colors.red.shade700)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ======================== MCQ VIEW ========================
  Widget _buildMCQExamView(Map<String, dynamic> exam) {
    final questions = (exam['OnlineExamQuestion'] as List?) ?? [];
    if (questions.isEmpty) return Center(child: Text(AppLanguage.noOnlineExams.tr));

    return Column(
      children: [
        // Timer bar
        Obx(() => Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _remainingSeconds.value < 60 ? Colors.red.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _remainingSeconds.value < 60 ? Colors.red.shade200 : Colors.grey.shade200),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
          ),
          child: Row(
            children: [
              Icon(Icons.timer, color: _remainingSeconds.value < 60 ? Colors.red : AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text('${AppLanguage.timeRemainingStr.tr}: ', style: AppTextStyles.medium14),
              Text(
                _formatTime(_remainingSeconds.value),
                style: AppTextStyles.bold18.copyWith(
                  color: _remainingSeconds.value < 60 ? Colors.red : AppColors.primary,
                ),
              ),
              const Spacer(),
              Text(
                '${_currentQuestionIndex.value + 1}/${questions.length}',
                style: AppTextStyles.bold14.copyWith(color: Colors.grey.shade600),
              ),
            ],
          ),
        )),

        // Progress bar
        Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: questions.isEmpty ? 0 : (_currentQuestionIndex.value + 1) / questions.length,
              backgroundColor: Colors.grey.shade200,
              color: AppColors.primary,
              minHeight: 4,
            ),
          ),
        )),

        const SizedBox(height: 16),

        // Question card
        Expanded(
          child: Obx(() {
            final qIndex = _currentQuestionIndex.value;
            if (qIndex >= questions.length) return const SizedBox.shrink();
            final q = questions[qIndex] as Map<String, dynamic>;
            return _buildQuestionCard(q, qIndex, questions.length);
          }),
        ),

        // Navigation buttons
        Obx(() => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
          ),
          child: Row(
            children: [
              if (_currentQuestionIndex.value > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _currentQuestionIndex.value--,
                    icon: const Icon(Icons.arrow_back_ios, size: 16),
                    label: Text(AppLanguage.previous.tr),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              if (_currentQuestionIndex.value > 0) const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_currentQuestionIndex.value < questions.length - 1) {
                      _currentQuestionIndex.value++;
                    } else {
                      _showSubmitConfirm();
                    }
                  },
                  icon: Icon(
                    _currentQuestionIndex.value < questions.length - 1 ? Icons.arrow_forward_ios : Icons.check,
                    size: 16,
                  ),
                  label: Text(
                    _currentQuestionIndex.value < questions.length - 1
                        ? AppLanguage.next.tr
                        : AppLanguage.submitExam.tr,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentQuestionIndex.value < questions.length - 1
                        ? AppColors.primary
                        : Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> q, int index, int total) {
    final questionId = q['id'] ?? '';
    final questionText = q['questionText'] ?? '';
    final marks = q['marks'] ?? 0;
    final options = ['A', 'B', 'C', 'D'];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text('${index + 1}', style: AppTextStyles.bold16.copyWith(color: AppColors.primary)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${AppLanguage.questionStr.tr} ${index + 1}',
                        style: AppTextStyles.bold14.copyWith(color: Colors.grey.shade600),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('$marks ${AppLanguage.scoreStr.tr}', style: AppTextStyles.bold12.copyWith(color: Colors.amber.shade800)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(questionText, style: AppTextStyles.medium16.copyWith(height: 1.6, color: Colors.grey.shade900)),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Options
          ...options.map((opt) {
            final optionText = q['option$opt'] ?? '';
            if (optionText.toString().isEmpty) return const SizedBox.shrink();

            return Obx(() {
              final isSelected = controller.selectedAnswers[questionId] == opt;
              return GestureDetector(
                onTap: () => controller.selectAnswer(questionId, opt),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withOpacity(0.08) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.grey.shade200,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 8)]
                        : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
                  ),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            opt,
                            style: AppTextStyles.bold16.copyWith(color: isSelected ? Colors.white : Colors.grey.shade600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          optionText.toString(),
                          style: AppTextStyles.medium14.copyWith(
                            color: isSelected ? AppColors.primary : Colors.grey.shade800,
                          ),
                        ),
                      ),
                      if (isSelected) Icon(Icons.check_circle, color: AppColors.primary, size: 22),
                    ],
                  ),
                ),
              );
            });
          }),
        ],
      ),
    );
  }

  // ======================== PAPER VIEW ========================
  Widget _buildPaperExamView(Map<String, dynamic> exam) {
    final attachments = (exam['OnlineExamAttachment'] as List?) ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timer
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
            ),
            child: Row(
              children: [
                Icon(Icons.timer, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text('${AppLanguage.timeRemainingStr.tr}: ', style: AppTextStyles.medium14),
                Text(_formatTime(_remainingSeconds.value), style: AppTextStyles.bold18.copyWith(color: AppColors.primary)),
              ],
            ),
          )),

          const SizedBox(height: 20),

          // Paper exam file (if any attachments)
          if (attachments.isNotEmpty) ...[
            Text(AppLanguage.attachments.tr, style: AppTextStyles.bold16),
            const SizedBox(height: 10),
            ...attachments.map((att) => GestureDetector(
              onTap: () {
                final fileUrl = att['fileUrl'];
                if (fileUrl != null && fileUrl.toString().isNotEmpty) {
                  final fullUrl = fileUrl.toString().pdfUrlToFullUrl;
                  if (fullUrl != null) {
                    Get.to(() => PdfViewerScreen(
                      pdfUrl: fullUrl,
                      isLocalFile: false,
                    ));
                  }
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.red.shade400, size: 28),
                    const SizedBox(width: 12),
                    Expanded(child: Text(att['fileName'] ?? 'ملف الأسئلة', style: AppTextStyles.medium14)),
                    Icon(Icons.open_in_new, color: Colors.grey.shade400, size: 20),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 20),
          ],

          // Upload answer section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
            ),
            child: Column(
              children: [
                Icon(Icons.cloud_upload_outlined, size: 48, color: AppColors.primary.withOpacity(0.6)),
                const SizedBox(height: 12),
                Text(AppLanguage.uploadAnswer.tr, style: AppTextStyles.bold16.copyWith(color: Colors.grey.shade800)),
                const SizedBox(height: 6),
                Text(
                  'صوّر ورقة الإجابة أو اختر من المعرض',
                  style: AppTextStyles.regular14.copyWith(color: Colors.grey.shade500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => controller.pickImage(),
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('المعرض'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => controller.takePhoto(),
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: const Text('الكاميرا'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          side: BorderSide(color: Colors.orange.withOpacity(0.3)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Uploaded file preview
          Obx(() {
            if (controller.uploadedFile.value == null) return const SizedBox.shrink();
            return Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.shade200, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(controller.uploadedFile.value!, height: 250, width: double.infinity, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => controller.uploadedFile.value = null,
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                  label: Text('إزالة', style: AppTextStyles.medium14.copyWith(color: Colors.red)),
                ),
              ],
            );
          }),

          const SizedBox(height: 24),

          // Submit button
          Obx(() => SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: controller.uploadedFile.value != null && !controller.isSubmitting.value
                  ? () => _submitPaperExam(exam)
                  : null,
              icon: controller.isSubmitting.value
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.upload_rounded, color: Colors.white),
              label: Text(AppLanguage.submitExam.tr, style: AppTextStyles.bold16.copyWith(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          )),
        ],
      ),
    );
  }

  // ======================== RESULT VIEW ========================
  Widget _buildResultView(Map<String, dynamic> exam) {
    final score = controller.getStudentScore(exam);
    final totalMarks = exam['totalMarks'] ?? 0;
    final passingMarks = exam['passingMarks'];
    final passed = passingMarks != null && score != null && score >= (passingMarks as num).toDouble();
    final examType = exam['examType'] ?? 'MCQ';
    final questions = (exam['OnlineExamQuestion'] as List?) ?? [];
    final studentStatus = controller.getStudentStatus(exam);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Score hero
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: studentStatus == 'GRADED'
                    ? (passed ? [Colors.green.shade400, Colors.green.shade600] : [Colors.red.shade400, Colors.red.shade600])
                    : [Colors.blue.shade400, Colors.blue.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: Column(
              children: [
                Icon(
                  studentStatus == 'GRADED'
                      ? (passed ? Icons.emoji_events : Icons.sentiment_dissatisfied)
                      : Icons.hourglass_top,
                  color: Colors.white, size: 48,
                ),
                const SizedBox(height: 12),
                if (studentStatus == 'GRADED' && score != null) ...[
                  Text(
                    '${score.toStringAsFixed(0)}/$totalMarks',
                    style: AppTextStyles.bold18.copyWith(color: Colors.white, fontSize: 36),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    passed ? AppLanguage.passedStr.tr : AppLanguage.failedStr.tr,
                    style: AppTextStyles.bold16.copyWith(color: Colors.white70),
                  ),
                ] else ...[
                  Text(AppLanguage.submitExam.tr, style: AppTextStyles.bold18.copyWith(color: Colors.white, fontSize: 24)),
                  const SizedBox(height: 8),
                  Text('بانتظار التصحيح', style: AppTextStyles.medium14.copyWith(color: Colors.white70)),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Show questions with correct/wrong for MCQ exams
          if (examType == 'MCQ' && studentStatus == 'GRADED' && questions.isNotEmpty) ...[
            Text(AppLanguage.examResultStr.tr, style: AppTextStyles.bold16),
            const SizedBox(height: 12),
            ...questions.asMap().entries.map((entry) {
              final i = entry.key;
              final q = entry.value as Map<String, dynamic>;
              // Find student's answer for this question
              final studentAnswers = (exam['OnlineExamStudent'] as List?)
                  ?.firstOrNull as Map<String, dynamic>?;
              final allAnswers = (studentAnswers?['OnlineExamStudentAnswer'] as List?) ?? [];
              final studentAnswer = allAnswers.cast<Map<String, dynamic>>().firstWhere(
                (a) => a['onlineExamQuestionId'] == q['id'],
                orElse: () => <String, dynamic>{},
              );
              final selectedOption = studentAnswer['selectedOption'] as String? ?? '';
              return _buildResultQuestionCard(q, i, selectedOption);
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildResultQuestionCard(Map<String, dynamic> q, int index, String studentSelectedOption) {
    final questionText = q['questionText'] ?? '';
    final correctAnswer = q['correctAnswer'] ?? '';
    final marks = q['marks'] ?? 0;
    final options = ['A', 'B', 'C', 'D'];
    final isStudentCorrect = studentSelectedOption.toUpperCase() == correctAnswer.toString().toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30, height: 30,
                decoration: BoxDecoration(
                  color: isStudentCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text('${index + 1}', style: AppTextStyles.bold14.copyWith(
                    color: isStudentCorrect ? Colors.green : Colors.red,
                  )),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(questionText, style: AppTextStyles.medium14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isStudentCorrect ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isStudentCorrect ? '$marks ✓' : '0 ✗',
                  style: AppTextStyles.bold12.copyWith(
                    color: isStudentCorrect ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...options.map((opt) {
            final text = q['option$opt'] ?? '';
            if (text.toString().isEmpty) return const SizedBox.shrink();
            
            final isCorrectOption = correctAnswer.toString().toUpperCase() == opt;
            final isStudentOption = studentSelectedOption.toUpperCase() == opt;
            final isWrongPick = isStudentOption && !isCorrectOption;

            // Determine colors
            Color bgColor;
            Color borderColor;
            Color circleColor;
            Color textColor;
            
            if (isCorrectOption) {
              bgColor = Colors.green.shade50;
              borderColor = Colors.green.shade300;
              circleColor = Colors.green;
              textColor = Colors.green.shade800;
            } else if (isWrongPick) {
              bgColor = Colors.red.shade50;
              borderColor = Colors.red.shade300;
              circleColor = Colors.red;
              textColor = Colors.red.shade800;
            } else {
              bgColor = Colors.grey.shade50;
              borderColor = Colors.grey.shade200;
              circleColor = Colors.grey.shade200;
              textColor = Colors.grey.shade700;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      color: circleColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(child: Text(opt, style: AppTextStyles.bold12.copyWith(
                      color: (isCorrectOption || isWrongPick) ? Colors.white : Colors.grey.shade600,
                    ))),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(text.toString(), style: AppTextStyles.medium14.copyWith(color: textColor))),
                  if (isCorrectOption)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 18),
                        const SizedBox(width: 4),
                        Text('الإجابة الصحيحة', style: AppTextStyles.regular12.copyWith(color: Colors.green.shade700)),
                      ],
                    ),
                  if (isWrongPick)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cancel, color: Colors.red, size: 18),
                        const SizedBox(width: 4),
                        Text('إجابتك', style: AppTextStyles.regular12.copyWith(color: Colors.red.shade700)),
                      ],
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ======================== HELPERS ========================
  Widget _infoCard(IconData icon, String value, String label, Color color, {bool fullWidth = false}) {
    final container = Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.bold18.copyWith(color: color)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.regular12.copyWith(color: Colors.grey.shade500), textAlign: TextAlign.center),
        ],
      ),
    );

    return fullWidth ? container : Expanded(child: container);
  }

  Widget _dateRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Text(label, style: AppTextStyles.medium14.copyWith(color: Colors.grey.shade600)),
        const Spacer(),
        Text(value, style: AppTextStyles.bold14.copyWith(color: Colors.grey.shade800)),
      ],
    );
  }

  void _showSubmitConfirm() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppLanguage.confirmSubmitExam.tr, style: AppTextStyles.bold18),
        content: Text(AppLanguage.confirmSubmitExamDesc.tr, style: AppTextStyles.medium14.copyWith(color: Colors.grey.shade600)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(AppLanguage.cancel.tr, style: AppTextStyles.medium14.copyWith(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              _timer?.cancel();
              final success = await controller.submitMCQAnswers(widget.examId);
              if (success) {
                Get.snackbar('✅', AppLanguage.examSubmittedSuccess.tr, backgroundColor: Colors.green.shade50);
                controller.fetchExamById(widget.examId);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(AppLanguage.submitExam.tr, style: AppTextStyles.bold14.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _submitPaperExam(Map<String, dynamic> exam) async {
    final file = controller.uploadedFile.value;
    if (file == null) return;
    _timer?.cancel();
    final success = await controller.submitPaperAnswer(widget.examId, file);
    if (success) {
      Get.snackbar('✅', AppLanguage.examSubmittedSuccess.tr, backgroundColor: Colors.green.shade50);
      controller.fetchExamById(widget.examId);
    }
  }
}
