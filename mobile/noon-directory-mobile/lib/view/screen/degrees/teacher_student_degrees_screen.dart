import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/teacher_degrees_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/device_utils.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import '../../../core/function.dart';
import '../../../core/localization/language.dart';

class TeacherStudentDegreesScreen extends GetView<TeacherDegreesController> {
  const TeacherStudentDegreesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => DeviceUtils.hideKeyboard(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: CustomAppBar(
          appBarName: AppLanguage.gradesStr.tr,
          isLeading: true,
          press: () => Get.back(),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // ─── Search Bar & Filter ───
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    // Filter Button
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mainColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.tune_rounded, color: Colors.white),
                        onPressed: () => _showFilterBottomSheet(),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Search Field
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: TextField(
                          onChanged: (val) => controller.searchQuery.value = val,
                          decoration: InputDecoration(
                            hintText: AppLanguage.search.tr,
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            suffixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade400),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade200),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.mainColor, width: 1.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ─── Breadcrumbs ───
              Obx(() {
                final stage = translateStage(controller.stageValue.value?.name ?? '');
                final classInfo = controller.classValue.value?.name ?? '';
                final subject = controller.subjectValue.value?.stageSubject?.subject?.name ?? '';
                final section = controller.sectionValue.value?.name ?? '';

                final path = [stage, classInfo, subject, section]
                    .where((s) => s.isNotEmpty)
                    .join(' > ');

                if (path.isEmpty) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.mainColor.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.folder_open_rounded, size: 16, color: AppColors.mainColor.withValues(alpha: 0.7)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            path,
                            style: AppTextStyles.medium12.copyWith(color: AppColors.mainColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              // ─── Summary Header ───
              Obx(() {
                final students = controller.filteredExamResults;
                if (students.isEmpty) return const SizedBox.shrink();

                final maxScore = controller.examValue.value?.exam?.score ?? 100;
                final totalWithGrades = students.where((s) => !s.id.startsWith("new_")).length;
                final totalWithout = students.where((s) => s.id.startsWith("new_")).length;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Row(
                    children: [
                      _buildStatChip(
                        icon: Icons.people_alt_rounded,
                        label: '${students.length}',
                        subtitle: 'طالب',
                        color: AppColors.mainColor,
                      ),
                      const SizedBox(width: 8),
                      _buildStatChip(
                        icon: Icons.check_circle_rounded,
                        label: '$totalWithGrades',
                        subtitle: 'مُقيَّم',
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      _buildStatChip(
                        icon: Icons.pending_rounded,
                        label: '$totalWithout',
                        subtitle: 'بانتظار',
                        color: Colors.orange,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(
                          'من $maxScore',
                          style: AppTextStyles.semiBold12.copyWith(color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 8),

              // ─── Student List with inline grade fields ───
              Expanded(
                child: Obx(() {
                  final students = controller.filteredExamResults;

                  if (students.isEmpty) {
                    return NoDataWidget(title: AppLanguage.noInfoAvailable.tr);
                  }

                  final maxScore = controller.examValue.value?.exam?.score ?? 100;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final degree = students[index];
                      final isNew = degree.id.startsWith("new_");

                      // Determine the displayed score (edited or original)
                      final displayScore = controller.editedScores.containsKey(degree.id)
                          ? controller.editedScores[degree.id]!
                          : degree.score;

                      final scoreController = TextEditingController(text: displayScore.toString());

                      // Determine score color
                      Color scoreColor;
                      if (isNew && !controller.editedScores.containsKey(degree.id)) {
                        scoreColor = Colors.orange;
                      } else {
                        final pct = displayScore / maxScore;
                        if (pct >= 0.7) {
                          scoreColor = Colors.green;
                        } else if (pct >= 0.5) {
                          scoreColor = Colors.orange;
                        } else {
                          scoreColor = Colors.red;
                        }
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: controller.editedScores.containsKey(degree.id)
                                ? AppColors.mainColor.withValues(alpha: 0.4)
                                : Colors.grey.shade100,
                            width: controller.editedScores.containsKey(degree.id) ? 1.5 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Student Number
                            Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.mainColor.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${index + 1}',
                                style: AppTextStyles.semiBold12.copyWith(
                                  color: AppColors.mainColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Student Name
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    degree.student?.fullName ?? '',
                                    style: AppTextStyles.medium14.copyWith(
                                      color: const Color(0xFF2D3142),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (isNew && !controller.editedScores.containsKey(degree.id))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        'بدون درجة',
                                        style: AppTextStyles.regular10.copyWith(
                                          color: Colors.orange.shade400,
                                        ),
                                      ),
                                    ),
                                  if (controller.editedScores.containsKey(degree.id))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        'تم التعديل ●',
                                        style: AppTextStyles.regular10.copyWith(
                                          color: AppColors.mainColor,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // Score Input Field
                            Container(
                              width: 72,
                              height: 40,
                              decoration: BoxDecoration(
                                color: scoreColor.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: scoreColor.withValues(alpha: 0.3)),
                              ),
                              child: TextField(
                                controller: scoreController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.semiBold14.copyWith(
                                  color: scoreColor,
                                  fontSize: 16,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                                ),
                                onChanged: (val) {
                                  int? v = int.tryParse(val);
                                  if (v != null && v > maxScore) {
                                    scoreController.text = maxScore.toString();
                                    scoreController.selection = TextSelection.fromPosition(
                                      TextPosition(offset: scoreController.text.length),
                                    );
                                    v = maxScore;
                                  }
                                  if (v != null) {
                                    controller.setInlineScore(degree.id, v);
                                  }
                                },
                              ),
                            ),

                            // Max Score Label
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Text(
                                '/$maxScore',
                                style: AppTextStyles.medium12.copyWith(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),

              // ─── Bottom Save Bar ───
              Obx(() {
                final hasChanges = controller.hasUnsavedChanges;
                final isSaving = controller.isSavingAll.value;
                final changeCount = controller.editedScores.length;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.fromLTRB(
                    16,
                    12,
                    16,
                    MediaQuery.of(context).viewPadding.bottom + 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: hasChanges
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 12,
                              offset: const Offset(0, -4),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    children: [
                      // Unsaved count badge
                      if (hasChanges)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit_note_rounded, size: 16, color: AppColors.mainColor),
                              const SizedBox(width: 4),
                              Text(
                                '$changeCount تعديل',
                                style: AppTextStyles.semiBold12.copyWith(color: AppColors.mainColor),
                              ),
                            ],
                          ),
                        ),
                      if (hasChanges) const SizedBox(width: 12),

                      // Save Button
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: hasChanges && !isSaving
                                ? () => controller.saveAllDegrees()
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: hasChanges ? AppColors.mainColor : Colors.grey.shade300,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade300,
                              disabledForegroundColor: Colors.grey.shade500,
                              elevation: hasChanges ? 2 : 0,
                              shadowColor: AppColors.mainColor.withValues(alpha: 0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: isSaving
                                ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'جاري الحفظ...',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        hasChanges ? Icons.save_rounded : Icons.check_circle_outline_rounded,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        hasChanges ? 'حفظ جميع الدرجات' : 'لا توجد تغييرات',
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  /// Small stat chip for the summary bar
  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.semiBold12.copyWith(color: color),
          ),
          const SizedBox(width: 2),
          Text(
            subtitle,
            style: AppTextStyles.regular10.copyWith(color: color.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption({
    required String title,
    required StudentSortOption value,
  }) {
    return RadioListTile<StudentSortOption>(
      title: Text(
        title,
        style: AppTextStyles.medium14.copyWith(color: Colors.black87),
      ),
      value: value,
      activeColor: AppColors.mainColor,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  void _showFilterBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLanguage.viewStudentsBy.tr,
                  style: AppTextStyles.medium16.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    controller.selectedSortOption.value = StudentSortOption.alphabetical;
                  },
                  child: Text(
                    AppLanguage.clearAll.tr,
                    style: AppTextStyles.medium14.copyWith(
                      color: AppColors.mainColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
              () => RadioGroup<StudentSortOption>(
                groupValue: controller.selectedSortOption.value,
                onChanged: (StudentSortOption? val) {
                  if (val != null) controller.selectedSortOption.value = val;
                },
                child: Column(
                  children: [
                    _buildRadioOption(
                      title: AppLanguage.orderByAlphabetical.tr,
                      value: StudentSortOption.alphabetical,
                    ),
                    _buildRadioOption(
                      title: AppLanguage.showStudentsWithoutGrades.tr,
                      value: StudentSortOption.noGrades,
                    ),
                    _buildRadioOption(
                      title: AppLanguage.orderGradesHighToLow.tr,
                      value: StudentSortOption.scoreHighToLow,
                    ),
                    _buildRadioOption(
                      title: AppLanguage.orderGradesLowToHigh.tr,
                      value: StudentSortOption.scoreLowToHigh,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                AppLanguage.viewStudents.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(Get.context!).viewPadding.bottom),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

