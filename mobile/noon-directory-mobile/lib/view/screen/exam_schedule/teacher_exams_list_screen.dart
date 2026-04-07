import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/teacher_exams_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/core/function.dart';
import 'package:noon/models/exam_data_model.dart';
import 'package:noon/models/stage_model.dart';
import 'package:noon/models/class_model.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/models/teacher_subject_model.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:s_extensions/s_extensions.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/bottom_navbar.dart';
import 'package:noon/core/constant/app_assets.dart';

class TeacherExamsListScreen extends StatefulWidget {
  const TeacherExamsListScreen({super.key});

  @override
  State<TeacherExamsListScreen> createState() => _TeacherExamsListScreenState();
}

class _TeacherExamsListScreenState extends State<TeacherExamsListScreen> {
  final controller = Get.put(TeacherExamsController());
  int? expandedIndex;
  bool showArchive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: CustomAppBar(
        appBarName: AppLanguage.examScheduleStr.tr,
        isLeading: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.loading.value && controller.allExams.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: controller.fetchExams,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!showArchive) ...[
                    _buildHeaderSection(
                      "فلترة الامتحانات",
                      "اختر تفاصيل البحث المطلوبة",
                    ),
                    const SizedBox(height: 40),
                    // 🔹 تم إضافة تعليقات توضح طريقة عملنا لتجنب إعادة التحميل المزعجة:
                    // 1. Stage (اختيار المرحلة يقوم بجلب الصفوف باستخدام isFetchingDropdowns بدلا من loading)
                    _buildAnimatedFilterCard<Stage>(
                      index: 0,
                      title: AppLanguage.stageStr.tr,
                      hint: "اختر المرحلة",
                      icon: Icons.school_rounded,
                      value: controller.stageValue.value,
                      content: controller.stages.toList(),
                      displayText: (item) => translateStage(item.name ?? ''),
                      onSelected: (v) => controller.onStageChanged(v),
                    ),

                    // 2. Class (اختيار الصف يقوم بجلب الشعب والمواد)
                    _buildAnimatedFilterCard<ClassInfo>(
                      index: 1,
                      title: AppLanguage.academicStageWithOutSimiStr.tr,
                      hint: "اختر الصف",
                      icon: Icons.grid_view_rounded,
                      value: controller.classValue.value,
                      content: controller.classes.toList(),
                      displayText: (item) => item.name ?? '',
                      onSelected: (v) => controller.onClassChanged(v),
                    ),

                    // 🔹 3. Section (تمت إضافة هذا الفلتر بالكامل لتمكين المعلم من فلترة المواد بناءً على الشعبة المختارة حصراً)
                    _buildAnimatedFilterCard<Section>(
                      index: 2,
                      title: AppLanguage.sectionStr.tr,
                      hint: "اختر الشعبة",
                      icon: Icons.class_outlined,
                      value: controller.sectionValue.value,
                      content: controller.sections.toList(),
                      displayText: (item) => item.name ?? '',
                      onSelected: (v) => controller.onSectionChanged(v),
                    ),

                    // 🔹 4. Subject (تم تصحيح جلب المواد لتعتمد على filteredSubjectsForFilter والتي تعرض فقط المواد المربوطة بالشعبة المختارة)
                    _buildAnimatedFilterCard<TeacherSubject>(
                      index: 3,
                      title: AppLanguage.subjectStr.tr,
                      hint: "اختر المادة",
                      icon: Icons.book_rounded,
                      value: controller.subjectValue.value,
                      content: controller.filteredSubjectsForFilter,
                      displayText: (item) =>
                          item.stageSubject?.subject?.name ?? '',
                      onSelected: (v) => controller.onSubjectChanged(v),
                    ),

                    // 🔹 5. Exam Type (يتم جلبه وتنقيته بشكل صحيح ليعمل بسلاسة مع التعديل الأخير في الـ API)
                    _buildAnimatedFilterCard<String>(
                      index: 4,
                      title: AppLanguage.examTypeStr.tr,
                      hint: "اختر نوع الامتحان",
                      icon: Icons.assignment_rounded,
                      value: controller.examTypeFilter.value,
                      content: controller.examTypes
                          .map((e) => e.name ?? '')
                          .where((n) => n.isNotEmpty)
                          .toList(),
                      displayText: (item) => item,
                      onSelected: (v) => controller.onExamTypeFilterChanged(v),
                    ),

                    const SizedBox(height: 60),
                    _buildArchiveButton(),
                  ],

                  if (showArchive) ...[
                    // Exams List
                    // Added fix to align the No Data state to the absolute center of the exams empty space area
                    if (controller.filteredExams.isEmpty)
                      SizedBox(
                        height: Get.height * 0.6,
                        child: Center(
                          child: NoDataWidget(
                            title: AppLanguage.notExamResultFoundStr.tr,
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.filteredExams.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
                        itemBuilder: (_, index) {
                          return _ModernExamCard(
                            examData: controller.filteredExams[index],
                          );
                        },
                      ),

                    const SizedBox(height: 30),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        }),
      ),
      // Added bottom padding and made background transparent to elevate the button from sticky edge
      bottomNavigationBar: showArchive
          ? Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: BottomNavbar(
                backgroundColor: Colors.transparent,
                text: "اضافة امتحان جديد",
                icon: AppAssets.icAdd,
                onTap: () =>
                    Get.toNamed(ScreensUrls.teacherCreateExamScreenUrl),
              ),
            )
          : null,
    );
  }

  Widget _buildHeaderSection(String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bold16.copyWith(
                  fontSize: 22,
                  color: const Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                desc,
                style: AppTextStyles.medium14.copyWith(
                  color: Colors.blueGrey[300],
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () => Get.toNamed(ScreensUrls.teacherCreateExamScreenUrl),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: AppColors.mainColor, size: 20),
                const SizedBox(width: 6),
                Text(
                  "إضافة امتحان",
                  style: AppTextStyles.bold14.copyWith(
                    color: AppColors.mainColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArchiveButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.mainColor,
            AppColors.mainColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          controller.applyFilters();
          setState(() => showArchive = true);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          "أرشيف الامتحانات",
          style: AppTextStyles.bold14.copyWith(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedFilterCard<T>({
    required int index,
    required String title,
    required String hint,
    required IconData icon,
    required T? value,
    required List<T> content,
    required String Function(T) displayText,
    required void Function(T?) onSelected,
  }) {
    bool isExpanded = expandedIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  expandedIndex = isExpanded ? null : index;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.mainColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, size: 20, color: AppColors.mainColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTextStyles.medium12.copyWith(
                              color: Colors.blueGrey[300],
                            ),
                          ),
                          Text(
                            value != null ? displayText(value) : hint,
                            style: AppTextStyles.bold14.copyWith(
                              color: value != null
                                  ? Colors.black87
                                  : Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.25 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Column(
                    children: [
                      const Divider(height: 1, indent: 20, endIndent: 20),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: content.length,
                          itemBuilder: (context, i) {
                            final item = content[i];
                            bool isSelected = item == value;
                            return ListTile(
                              onTap: () {
                                onSelected(item);
                                setState(() => expandedIndex = null);
                              },
                              dense: true,
                              title: Text(
                                displayText(item),
                                textAlign: TextAlign.right,
                                style: AppTextStyles.medium14.copyWith(
                                  color: isSelected
                                      ? AppColors.mainColor
                                      : Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              trailing: isSelected
                                  ? Icon(
                                      Icons.check_circle,
                                      size: 18,
                                      color: AppColors.mainColor,
                                    )
                                  : null,
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : const SizedBox(width: double.infinity, height: 0),
          ),
        ],
      ),
    );
  }
}

class _ModernExamCard extends StatelessWidget {
  final ExamDataModel examData;
  const _ModernExamCard({required this.examData});

  @override
  Widget build(BuildContext context) {
    final stageSubject = examData.stageSubject;
    final examSections = examData.examSections;

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Subject and Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.book_rounded,
                    color: AppColors.mainColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stageSubject.subject?.name ?? '',
                        style: AppTextStyles.bold16,
                      ),
                      if (examSections.isNotEmpty)
                        Text(
                          examSections.first.exam?.examType?.name ?? '',
                          style: AppTextStyles.medium12.copyWith(
                            color: AppColors.mainColor,
                          ),
                        ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert_rounded),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () => Get.toNamed(
                        ScreensUrls.teacherCreateExamScreenUrl,
                        arguments: {'examData': examData, 'isEditing': true},
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.edit_rounded, color: Colors.blue),
                          const SizedBox(width: 10),
                          Text(AppLanguage.editStr.tr),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () => _deleteConfirm(context),
                      child: Row(
                        children: [
                          const Icon(Icons.delete_rounded, color: Colors.red),
                          const SizedBox(width: 10),
                          Text(AppLanguage.deleteStr.tr),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Details Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(
                  Icons.school_rounded,
                  '${translateStage(stageSubject.stage?.name ?? '')} - ${stageSubject.classDetail?.name ?? ''}',
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  Icons.stars_rounded,
                  '${AppLanguage.maximumScoreStr.tr}: ${examData.score}',
                  iconColor: Colors.orange,
                ),
                if (examData.content.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      examData.content,
                      style: AppTextStyles.regular14,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Sections Tags
          if (examSections.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: examSections
                    .map(
                      (section) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.mainColor.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.mainColor.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Text(
                          '${section.section?.name ?? ''} | ${section.examDate?.formatYearMonthDay ?? ''}',
                          style: AppTextStyles.medium12.copyWith(
                            fontSize: 10,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {Color? iconColor}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor ?? Colors.blueGrey[300]),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.medium14.copyWith(color: Colors.blueGrey[700]),
          ),
        ),
      ],
    );
  }

  void _deleteConfirm(BuildContext context) async {
    final controller = Get.find<TeacherExamsController>();
    Get.defaultDialog(
      title: AppLanguage.deleteStr.tr,
      middleText: AppLanguage.deleteMsgDesc.tr,
      textConfirm: AppLanguage.deleteStr.tr,
      textCancel: AppLanguage.cancel.tr,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        controller.deleteExam(examData.id);
        Get.back();
      },
    );
  }
}
