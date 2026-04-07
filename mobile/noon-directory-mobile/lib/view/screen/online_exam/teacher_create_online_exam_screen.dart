import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/teacher_online_exam_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/core/function.dart';
import 'package:noon/models/stage_model.dart';
import 'package:noon/models/class_model.dart';
import 'package:noon/models/teacher_subject_model.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/models/exam_section_model.dart';
import 'package:intl/intl.dart';

class TeacherCreateOnlineExamScreen extends StatefulWidget {
  const TeacherCreateOnlineExamScreen({super.key});

  @override
  State<TeacherCreateOnlineExamScreen> createState() =>
      _TeacherCreateOnlineExamScreenState();
}

class _TeacherCreateOnlineExamScreenState
    extends State<TeacherCreateOnlineExamScreen> {
  final controller = Get.find<TeacherOnlineExamController>();
  final _pageController = PageController();
  int? expandedIndex;

  final List<String> stepTitles = [
    'معلومات الامتحان',
    'الأسئلة والمرفقات',
    'تحديد الطلاب',
    'المراجعة والنشر',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (controller.currentStep.value < 3) {
      controller.currentStep.value++;
      _pageController.animateToPage(
        controller.currentStep.value,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevStep() {
    if (controller.currentStep.value > 0) {
      controller.currentStep.value--;
      _pageController.animateToPage(
        controller.currentStep.value,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: CustomAppBar(
        appBarName: 'إنشاء امتحان إلكتروني',
        isLeading: true,
        press: () => Get.back(),
      ),
      body: Obx(() => Column(
            children: [
              // Step Indicator
              _buildStepIndicator(),

              // Content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStep1ExamInfo(),
                    _buildStep2Questions(),
                    _buildStep3Students(),
                    _buildStep4Review(),
                  ],
                ),
              ),

              // Bottom Navigation
              _buildBottomNav(),
            ],
          )),
    );
  }

  // ============================================
  // Step Indicator
  // ============================================
  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(4, (index) {
              final isActive = index <= controller.currentStep.value;
              final isCurrent = index == controller.currentStep.value;
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: isActive
                                  ? LinearGradient(
                                      colors: [
                                        AppColors.mainColor,
                                        AppColors.mainColor
                                            .withValues(alpha: 0.8),
                                      ],
                                    )
                                  : null,
                              color: isActive ? null : Colors.grey.shade200,
                              shape: BoxShape.circle,
                              boxShadow: isCurrent
                                  ? [
                                      BoxShadow(
                                        color: AppColors.mainColor
                                            .withValues(alpha: 0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: isActive && !isCurrent
                                  ? const Icon(Icons.check,
                                      size: 16, color: Colors.white)
                                  : Text(
                                      '${index + 1}',
                                      style: AppTextStyles.bold12.copyWith(
                                        color: isActive
                                            ? Colors.white
                                            : Colors.grey.shade400,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            stepTitles[index],
                            style: AppTextStyles.medium12.copyWith(
                              fontSize: 9,
                              color: isActive
                                  ? AppColors.mainColor
                                  : Colors.grey.shade400,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (index < 3)
                      Expanded(
                        child: Container(
                          height: 2,
                          margin: const EdgeInsets.only(bottom: 20),
                          color: index < controller.currentStep.value
                              ? AppColors.mainColor
                              : Colors.grey.shade200,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ============================================
  // Step 1: Exam Information
  // ============================================
  Widget _buildStep1ExamInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('معلومات الامتحان الأساسية', Icons.info_outline),
          const SizedBox(height: 16),

          // Title
          Obx(() {
            if (controller.isFetchingDropdowns.value &&
                controller.examTypes.isEmpty) {
              return const CircularProgressIndicator();
            }
            if (!controller.isFetchingDropdowns.value &&
                controller.examTypes.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'لا توجد أنواع امتحانات إلكترونية مضافة في لوحة التحكم، لا يمكنك إنشاء امتحان حالياً.',
                        style: AppTextStyles.medium12.copyWith(
                            color: Colors.red.shade800),
                      ),
                    ),
                  ],
                ),
              );
            }
            return _buildAnimatedSelector<ExamType>(
              index: -1,
              title: 'عنوان الامتحان *',
              hint: 'اختر نوع الامتحان الإلكتروني...',
              icon: Icons.title,
              value: controller.selectedDashboardExamType.value,
              items: controller.examTypes.toList(),
              displayText: (item) => item.name ?? '',
              onSelected: (v) => controller.selectedDashboardExamType.value = v,
            );
          }),
          const SizedBox(height: 16),

          // Description
          _buildTextField(
            controller: controller.descriptionController,
            label: 'وصف الامتحان (اختياري)',
            hint: 'وصف مختصر عن محتوى الامتحان',
            icon: Icons.description_outlined,
            maxLines: 3,
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('نوع الامتحان', Icons.category_outlined),
          const SizedBox(height: 12),

          // Exam Type Toggle
          Row(
            children: [
              Expanded(
                child: _buildTypeOption(
                  'MCQ',
                  'اختيار متعدد',
                  Icons.quiz_outlined,
                  controller.selectedExamType.value == 'MCQ',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTypeOption(
                  'PAPER',
                  'ورقي / PDF',
                  Icons.description_outlined,
                  controller.selectedExamType.value == 'PAPER',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('إعدادات الامتحان', Icons.settings_outlined),
          const SizedBox(height: 12),

          // Duration & Total Marks Row
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: controller.durationController,
                  label: 'المدة (دقائق)',
                  hint: '60',
                  icon: Icons.timer_outlined,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: controller.totalMarksController,
                  label: 'الدرجة الكلية',
                  hint: '100',
                  icon: Icons.star_outline_rounded,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Passing Marks
          _buildTextField(
            controller: controller.passingMarksController,
            label: 'درجة النجاح (اختياري)',
            hint: '50',
            icon: Icons.check_circle_outline,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('التوقيت', Icons.access_time_rounded),
          const SizedBox(height: 12),

          // Start & End Date
          Row(
            children: [
              Expanded(
                child: _buildDateButton(
                  label: 'تاريخ البداية',
                  value: controller.startDate.value,
                  onTap: () => controller.pickStartDate(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateButton(
                  label: 'تاريخ النهاية',
                  value: controller.endDate.value,
                  onTap: () => controller.pickEndDate(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Subject Selection
          _buildSectionHeader(
              'المادة والصف والشعبة', Icons.school_outlined),
          const SizedBox(height: 12),

          // Stage
          _buildAnimatedSelector<Stage>(
            index: 0,
            title: AppLanguage.stageStr.tr,
            hint: 'اختر المرحلة',
            icon: Icons.school_rounded,
            value: controller.createStageValue.value,
            items: controller.createStages.toList(),
            displayText: (item) => translateStage(item.name ?? ''),
            onSelected: (v) => controller.onCreateStageChanged(v),
          ),

          // Class
          _buildAnimatedSelector<ClassInfo>(
            index: 1,
            title: AppLanguage.academicStageWithOutSimiStr.tr,
            hint: 'اختر الصف',
            icon: Icons.grid_view_rounded,
            value: controller.createClassValue.value,
            items: controller.createClasses.toList(),
            displayText: (item) => item.name ?? '',
            onSelected: (v) => controller.onCreateClassChanged(v),
          ),

          // Sections (multi-select)
          if (controller.createSections.isNotEmpty) _buildSectionSelector(),

          // Subject
          _buildAnimatedSelector<TeacherSubject>(
            index: 3,
            title: AppLanguage.subjectStr.tr,
            hint: 'اختر المادة',
            icon: Icons.book_rounded,
            value: controller.createSubjectValue.value,
            items: controller.createSubjects.toList(),
            displayText: (item) =>
                item.stageSubject?.subject?.name ?? '',
            onSelected: (v) => controller.createSubjectValue.value = v,
          ),

          const SizedBox(height: 24),

          // Options
          _buildSectionHeader('خيارات إضافية', Icons.tune_rounded),
          const SizedBox(height: 12),

          _buildSwitchOption(
            'خلط الأسئلة',
            'ترتيب عشوائي للأسئلة لكل طالب',
            Icons.shuffle_rounded,
            controller.shuffleQuestions.value,
            (v) => controller.shuffleQuestions.value = v,
          ),
          const SizedBox(height: 8),
          _buildSwitchOption(
            'إظهار النتيجة فوراً',
            'يرى الطالب نتيجته بعد التسليم',
            Icons.visibility_outlined,
            controller.showResultImmediately.value,
            (v) => controller.showResultImmediately.value = v,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ============================================
  // Step 2: Questions & Attachments
  // ============================================
  Widget _buildStep2Questions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.selectedExamType.value == 'MCQ') ...[
            _buildSectionHeader('الأسئلة (اختيار متعدد)', Icons.quiz_outlined),
            const SizedBox(height: 16),

            // Questions List
            ...List.generate(controller.mcqQuestions.length, (index) {
              return _buildMCQQuestionCard(index);
            }),

            // Add Question Button
            _buildAddQuestionButton(),
          ] else ...[
            _buildSectionHeader('ملف الامتحان (PDF)', Icons.picture_as_pdf),
            const SizedBox(height: 16),

            _buildPdfUploadCard(),
          ],

          const SizedBox(height: 24),

          _buildSectionHeader('مرفقات إضافية (اختياري)', Icons.attach_file),
          const SizedBox(height: 12),

          _buildAttachmentsSection(),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ============================================
  // Step 3: Students
  // ============================================
  Widget _buildStep3Students() {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                  'اختيار الطلاب', Icons.people_outline_rounded),
              const SizedBox(height: 8),
              Text(
                'حدد الطلاب المطلوب إشراكهم في الامتحان',
                style: AppTextStyles.regular14.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),

        // Select All
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.mainColor.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.mainColor.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.select_all_rounded,
                  color: AppColors.mainColor, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'تحديد الكل (${controller.selectedStudentIds.length}/${controller.students.length})',
                  style: AppTextStyles.bold14.copyWith(
                    color: AppColors.mainColor,
                  ),
                ),
              ),
              Switch(
                value: controller.isSelectAllStudents.value,
                onChanged: (_) => controller.toggleAllStudents(),
                activeThumbColor: AppColors.mainColor,
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Students List
        Expanded(
          child: controller.students.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline,
                          size: 60, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        'اختر الشعبة أولاً لعرض الطلاب',
                        style: AppTextStyles.medium14.copyWith(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  itemCount: controller.students.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, index) {
                    final student = controller.students[index];
                    final studentData =
                        student['Student'] as Map<String, dynamic>? ?? student;
                    final studentId = (studentData['id'] ?? '').toString();
                    final studentName =
                        studentData['fullName'] ?? 'طالب ${index + 1}';
                    final isSelected =
                        controller.selectedStudentIds.contains(studentId);

                    return _buildStudentTile(
                      studentId: studentId,
                      studentName: studentName,
                      isSelected: isSelected,
                      index: index,
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ============================================
  // Step 4: Review & Publish
  // ============================================
  Widget _buildStep4Review() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('مراجعة الامتحان', Icons.preview_rounded),
          const SizedBox(height: 16),

          // Summary Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildReviewRow('العنوان', controller.selectedDashboardExamType.value?.name ?? '-'),
                _buildReviewDivider(),
                _buildReviewRow(
                    'النوع',
                    controller.selectedExamType.value == 'MCQ'
                        ? 'اختيار متعدد'
                        : 'ورقي'),
                _buildReviewDivider(),
                _buildReviewRow(
                    'المدة', '${controller.durationController.text} دقيقة'),
                _buildReviewDivider(),
                _buildReviewRow(
                    'الدرجة الكلية', controller.totalMarksController.text),
                _buildReviewDivider(),
                _buildReviewRow(
                  'تاريخ البداية',
                  controller.startDate.value != null
                      ? DateFormat('yyyy/MM/dd - hh:mm a')
                          .format(controller.startDate.value!)
                      : '-',
                ),
                _buildReviewDivider(),
                _buildReviewRow(
                  'تاريخ النهاية',
                  controller.endDate.value != null
                      ? DateFormat('yyyy/MM/dd - hh:mm a')
                          .format(controller.endDate.value!)
                      : '-',
                ),
                _buildReviewDivider(),
                _buildReviewRow(
                    'المادة',
                    controller.createSubjectValue.value?.stageSubject?.subject
                            ?.name ??
                        '-'),
                _buildReviewDivider(),
                if (controller.selectedExamType.value == 'MCQ')
                  _buildReviewRow(
                      'عدد الأسئلة', '${controller.mcqQuestions.length}'),
                if (controller.selectedExamType.value == 'MCQ')
                  _buildReviewDivider(),
                _buildReviewRow(
                    'عدد الطلاب', '${controller.selectedStudentIds.length}'),
                _buildReviewDivider(),
                _buildReviewRow(
                    'خلط الأسئلة',
                    controller.shuffleQuestions.value ? 'نعم' : 'لا'),
                _buildReviewDivider(),
                _buildReviewRow('إظهار النتيجة فوراً',
                    controller.showResultImmediately.value ? 'نعم' : 'لا'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Warning
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'سيتم إرسال إشعار لجميع الطلاب المحددين بعد نشر الامتحان',
                    style: AppTextStyles.medium12.copyWith(
                      color: Colors.amber.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ============================================
  // Bottom Navigation
  // ============================================
  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          if (controller.currentStep.value > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _prevStep,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.mainColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'السابق',
                  style: AppTextStyles.bold14.copyWith(
                    color: AppColors.mainColor,
                  ),
                ),
              ),
            ),
          if (controller.currentStep.value > 0) const SizedBox(width: 12),
          Expanded(
            flex: controller.currentStep.value > 0 ? 2 : 1,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.mainColor,
                    AppColors.mainColor.withValues(alpha: 0.85),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mainColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : () {
                        if (controller.currentStep.value == 3) {
                          controller.createOnlineExam();
                        } else {
                          _nextStep();
                          // Auto fetch students when moving to step 3
                          if (controller.currentStep.value == 2) {
                            controller.fetchStudentsForSections();
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isSubmitting.value
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        controller.currentStep.value == 3
                            ? 'نشر الامتحان 🚀'
                            : 'التالي',
                        style: AppTextStyles.bold14.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // Shared Widgets
  // ============================================
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.mainColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppColors.mainColor),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppTextStyles.bold16.copyWith(
            color: const Color(0xFF2D3142),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.medium14.copyWith(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.medium14.copyWith(
              color: Colors.grey.shade400,
            ),
            prefixIcon: Icon(icon, color: AppColors.mainColor, size: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: AppColors.mainColor.withValues(alpha: 0.15),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.mainColor, width: 1.5),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeOption(
      String type, String label, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.selectedExamType.value = type,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.mainColor.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.mainColor
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.mainColor.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 36,
              color:
                  isSelected ? AppColors.mainColor : Colors.grey.shade400,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: AppTextStyles.bold14.copyWith(
                color: isSelected
                    ? AppColors.mainColor
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateButton({
    required String label,
    DateTime? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: value != null
                ? AppColors.mainColor.withValues(alpha: 0.3)
                : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.medium12.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: value != null
                      ? AppColors.mainColor
                      : Colors.grey.shade400,
                ),
                const SizedBox(width: 8),
                Text(
                  value != null
                      ? DateFormat('MM/dd\nhh:mm a').format(value)
                      : 'اختر',
                  style: AppTextStyles.bold12.copyWith(
                    color: value != null
                        ? Colors.black87
                        : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSelector<T>({
    required int index,
    required String title,
    required String hint,
    required IconData icon,
    required T? value,
    required List<T> items,
    required String Function(T) displayText,
    required void Function(T?) onSelected,
  }) {
    bool isExpanded = expandedIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(
                  () => expandedIndex = isExpanded ? null : index),
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            AppColors.mainColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon,
                          size: 20, color: AppColors.mainColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTextStyles.medium12.copyWith(
                              color: Colors.blueGrey.shade300,
                            ),
                          ),
                          Text(
                            value != null
                                ? displayText(value)
                                : hint,
                            style: AppTextStyles.bold14.copyWith(
                              color: value != null
                                  ? Colors.black87
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.25 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: isExpanded
                ? Column(
                    children: [
                      const Divider(
                          height: 1, indent: 20, endIndent: 20),
                      ConstrainedBox(
                        constraints:
                            const BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (_, i) {
                            final item = items[i];
                            bool isSelected = item == value;
                            return ListTile(
                              dense: true,
                              onTap: () {
                                onSelected(item);
                                setState(() =>
                                    expandedIndex = null);
                              },
                              title: Text(
                                displayText(item),
                                textAlign: TextAlign.right,
                                style:
                                    AppTextStyles.medium14.copyWith(
                                  color: isSelected
                                      ? AppColors.mainColor
                                      : Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              trailing: isSelected
                                  ? Icon(Icons.check_circle,
                                      size: 18,
                                      color: AppColors.mainColor)
                                  : null,
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : const SizedBox(
                    width: double.infinity, height: 0),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionSelector() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.mainColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.groups_rounded,
                    size: 20, color: AppColors.mainColor),
              ),
              const SizedBox(width: 12),
              Text(
                'الشعب',
                style: AppTextStyles.bold14,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.createSections.map((s) {
              bool isSelected =
                  controller.createSelectedSectionIds.contains(s.id);
              return FilterChip(
                label: Text(s.name ?? ''),
                selected: isSelected,
                onSelected: (_) => controller.toggleCreateSection(s.id!),
                selectedColor:
                    AppColors.mainColor.withValues(alpha: 0.2),
                checkmarkColor: AppColors.mainColor,
                labelStyle: AppTextStyles.medium12.copyWith(
                  color:
                      isSelected ? AppColors.mainColor : Colors.black87,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchOption(String title, String subtitle, IconData icon,
      bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.mainColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bold14),
                Text(
                  subtitle,
                  style: AppTextStyles.regular12.copyWith(
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.mainColor,
          ),
        ],
      ),
    );
  }

  // ============================================
  // MCQ Question Card
  // ============================================
  Widget _buildMCQQuestionCard(int index) {
    final q = controller.mcqQuestions[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
              // Marks input
              SizedBox(
                width: 80,
                child: TextField(
                  onChanged: (v) => controller.updateMCQQuestion(
                    index, 'marks', int.tryParse(v) ?? 0,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'الدرجة',
                    hintStyle: AppTextStyles.regular12,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 6),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.mainColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => controller.removeMCQQuestion(index),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                iconSize: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Question Text
          TextField(
            onChanged: (v) =>
                controller.updateMCQQuestion(index, 'questionText', v),
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'نص السؤال...',
              hintStyle: AppTextStyles.medium14.copyWith(
                color: Colors.grey.shade400,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.mainColor),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          const SizedBox(height: 12),

          // Options
          ...['A', 'B', 'C', 'D'].map((option) {
            final isCorrect = q['correctAnswer'] == option;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => controller.updateMCQQuestion(
                        index, 'correctAnswer', option),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? Colors.green
                            : Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          option,
                          style: AppTextStyles.bold12.copyWith(
                            color:
                                isCorrect ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => controller.updateMCQQuestion(
                          index, 'option$option', v),
                      decoration: InputDecoration(
                        hintText: 'الخيار $option',
                        hintStyle: AppTextStyles.regular12.copyWith(
                          color: Colors.grey.shade400,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: isCorrect
                                ? Colors.green.withValues(alpha: 0.4)
                                : Colors.grey.shade200,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColors.mainColor),
                        ),
                        filled: true,
                        fillColor: isCorrect
                            ? Colors.green.withValues(alpha: 0.04)
                            : Colors.white,
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

  Widget _buildAddQuestionButton() {
    return GestureDetector(
      onTap: () => controller.addMCQQuestion(),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.mainColor.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.mainColor.withValues(alpha: 0.2),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline,
                color: AppColors.mainColor, size: 24),
            const SizedBox(width: 10),
            Text(
              'إضافة سؤال جديد',
              style: AppTextStyles.bold14.copyWith(
                color: AppColors.mainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfUploadCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          if (controller.pdfFile.value == null)
            GestureDetector(
              onTap: () => controller.pickPdfFile(),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(Icons.picture_as_pdf_rounded,
                        size: 48, color: Colors.red.shade300),
                    const SizedBox(height: 12),
                    Text(
                      'رفع ملف الامتحان',
                      style: AppTextStyles.bold14.copyWith(
                        color: Colors.red.shade400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'PDF, PNG, JPG',
                      style: AppTextStyles.regular12.copyWith(
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Colors.green.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.picture_as_pdf_rounded,
                      color: Colors.redAccent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      controller.pdfFile.value!.path
                          .split('/')
                          .last
                          .split('\\')
                          .last,
                      style: AppTextStyles.medium12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        controller.pdfFile.value = null,
                    icon: const Icon(Icons.cancel_rounded,
                        color: Colors.red, size: 20),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => controller.pickAttachmentFiles(),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_rounded,
                    color: AppColors.mainColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'إضافة مرفقات',
                  style: AppTextStyles.bold14.copyWith(
                    color: AppColors.mainColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (controller.attachmentFiles.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...List.generate(
            controller.attachmentFiles.length,
            (index) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.insert_drive_file,
                      size: 18, color: Colors.blueGrey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      controller.attachmentFiles[index].path
                          .split('/')
                          .last
                          .split('\\')
                          .last,
                      style: AppTextStyles.medium12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        controller.removeAttachmentFile(index),
                    icon: const Icon(Icons.close,
                        size: 18, color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStudentTile({
    required String studentId,
    required String studentName,
    required bool isSelected,
    required int index,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.mainColor.withValues(alpha: 0.04)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? AppColors.mainColor.withValues(alpha: 0.2)
              : Colors.grey.shade100,
        ),
      ),
      child: ListTile(
        onTap: () => controller.toggleStudent(studentId),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.mainColor.withValues(alpha: 0.15),
                AppColors.mainColor.withValues(alpha: 0.05),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: AppTextStyles.bold14.copyWith(
                color: AppColors.mainColor,
              ),
            ),
          ),
        ),
        title: Text(
          studentName,
          style: AppTextStyles.bold14.copyWith(fontSize: 14),
        ),
        trailing: Checkbox(
          value: isSelected,
          onChanged: (_) => controller.toggleStudent(studentId),
          activeColor: AppColors.mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyles.medium14.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const Spacer(),
          Text(
            value.isNotEmpty ? value : '-',
            style: AppTextStyles.bold14,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewDivider() {
    return Divider(height: 1, color: Colors.grey.shade100);
  }
}
