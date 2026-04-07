import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/teacher_degrees_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/core/device_utils.dart';
import 'package:noon/models/class_model.dart';
import 'package:noon/models/exam_section_model.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/models/stage_model.dart';
import 'package:noon/models/teacher_subject_model.dart';

import 'package:noon/view/widget/custom_appbar.dart';
import '../../../core/function.dart';
import '../../../core/localization/language.dart';

class TeacherDegreesScreen extends StatefulWidget {
  const TeacherDegreesScreen({super.key});

  @override
  State<TeacherDegreesScreen> createState() => _TeacherDegreesScreenState();
}

class _TeacherDegreesScreenState extends State<TeacherDegreesScreen> {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeacherDegreesController>();
    controller.showKeyboard();

    return SafeArea(
      child: GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(),
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FB),
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar(
            appBarName: AppLanguage.gradesStr.tr,
            isLeading: true,
            press: () => Get.back(),
          ),
          body: Obx(() {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeaderSection(),
                  const SizedBox(height: 30),

                  // 1. Stage
                  _buildAnimatedDropdownCard<Stage>(
                    index: 0,
                    title: "المرحلة",
                    hint: "اختر المرحلة",
                    icon: Icons.school_rounded,
                    value: controller.stageValue.value,
                    content: controller.stages.toList(),
                    displayText: (item) => translateStage(item.name ?? ''),
                    onSelected: (v) {
                      controller.stageValue(v);
                      controller.classValue.value = null;
                      controller.examValue.value = null;
                      controller.sectionValue.value = null;
                      controller.subjectValue.value = null;
                      controller.classes.clear();
                      controller.exams.clear();
                      controller.sections.clear();
                      controller.subjects.clear();
                      if (v?.id != null) {
                        controller.getTeacherClass(v!.id.toString());
                      }
                      setState(() => expandedIndex = null);
                    },
                  ),

                  // 2. Class
                  _buildAnimatedDropdownCard<ClassInfo>(
                    index: 1,
                    title: "الصف",
                    hint: "اختر الصف",
                    icon: Icons.grid_view_rounded,
                    value: controller.classValue.value,
                    content: controller.classes.toList(),
                    displayText: (item) => item.name ?? '',
                    onTap: () {
                      if (controller.classes.isEmpty) {
                        controller.showSnackbarOnce(
                          AppLanguage.warning.tr,
                          AppLanguage.mustSelectRandomly.tr,
                        );
                      }
                    },
                    onSelected: (v) {
                      controller.classValue(v);
                      controller.examValue.value = null;
                      controller.sectionValue.value = null;
                      controller.subjectValue.value = null;
                      controller.exams.clear();
                      controller.sections.clear();
                      controller.subjects.clear();
                      if (v?.id != null) {
                        controller.getTeacherSection(v!.id.toString());
                        controller.getTeacherSubject(v.id.toString());
                      }
                      setState(() => expandedIndex = null);
                    },
                  ),

                  // 3. Section
                  _buildAnimatedDropdownCard<Section>(
                    index: 2,
                    title: "الشعبة",
                    hint: "اختر الشعبة",
                    icon: Icons.groups_rounded,
                    value: controller.sectionValue.value,
                    content: controller.sections.toList(),
                    displayText: (item) => item.name ?? '',
                    onTap: () {
                      if (!controller.loading.value &&
                          controller.sections.isEmpty) {
                        controller.showSnackbarOnce(
                          AppLanguage.warning.tr,
                          AppLanguage.thereIsNoSections.tr,
                        );
                      }
                      if (controller.classes.isEmpty ||
                          controller.stageValue.value == null) {
                        controller.showSnackbarOnce(
                          AppLanguage.warning.tr,
                          AppLanguage.mustSelectRandomly.tr,
                        );
                      }
                    },
                    onSelected: (v) {
                      controller.sectionValue(v);
                      controller.sectionId.value = v?.id?.toString();
                      controller.examValue.value = null;
                      controller.exams.clear();
                      if (v?.id != null &&
                          controller
                                  .subjectValue
                                  .value
                                  ?.stageSubject
                                  ?.subject
                                  ?.id !=
                              null) {
                        controller.getTeacherExams(
                          controller
                              .subjectValue
                              .value!
                              .stageSubject!
                              .subject!
                              .id
                              .toString(),
                        );
                      }
                      setState(() => expandedIndex = null);
                    },
                  ),

                  // 4. Subject
                  _buildAnimatedDropdownCard<TeacherSubject>(
                    index: 3,
                    title: "المادة",
                    hint: "اختر المادة",
                    icon: Icons.book_rounded,
                    value: controller.subjectValue.value,
                    content: controller.filteredSubjects,
                    displayText: (item) =>
                        item.stageSubject?.subject?.name ?? '',
                    onTap: () {
                      if (!controller.loading.value &&
                          controller.subjects.isEmpty) {
                        controller.showSnackbarOnce(
                          AppLanguage.warning.tr,
                          AppLanguage.thereIsNoSubjects.tr,
                        );
                      }
                      if (controller.classes.isEmpty ||
                          controller.classValue.value == null) {
                        controller.showSnackbarOnce(
                          AppLanguage.warning.tr,
                          AppLanguage.mustSelectRandomly.tr,
                        );
                      }
                    },
                    onSelected: (v) {
                      controller.subjectValue(v);
                      controller.examValue.value = null;
                      controller.exams.clear();
                      if (v?.stageSubject?.subject?.id != null &&
                          controller.sectionValue.value != null) {
                        controller.getTeacherExams(
                          v!.stageSubject!.subject!.id.toString(),
                        );
                      }
                      setState(() => expandedIndex = null);
                    },
                  ),

                  // 5. Exam
                  _buildAnimatedDropdownCard<ExamSectionModel>(
                    index: 4,
                    title: "الامتحان",
                    hint: "اختر الامتحان",
                    icon: Icons.assignment_rounded,
                    value: controller.examValue.value,
                    content: controller.exams.toList(),
                    displayText: (item) => item.exam?.examType?.name ?? '',
                    onTap: () {
                      if (controller.sections.isEmpty ||
                          controller.subjects.isEmpty) {
                        controller.showSnackbarOnce(
                          AppLanguage.warning.tr,
                          AppLanguage.mustSelectRandomly.tr,
                        );
                      }
                    },
                    onSelected: (v) {
                      controller.examValue(v);
                      if (v?.id != null) {
                        controller.examSectionIdSelected.value = v!.id
                            .toString();
                        controller.getTeacherResultExams(v.id.toString());
                      }
                      setState(() => expandedIndex = null);
                    },
                  ),

                  const SizedBox(height: 40),
                  _buildGradientButton(controller),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "اضافة درجات الطلبة",
          style: AppTextStyles.bold14.copyWith(
            fontSize: 22,
            color: const Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "يرجى اختيار المراحل والصفوف والمواد لرفع الدرجات",
          style: AppTextStyles.medium14.copyWith(color: Colors.blueGrey[400]),
        ),
      ],
    );
  }

  Widget _buildAnimatedDropdownCard<T>({
    required int index,
    required String title,
    required String hint,
    required IconData icon,
    required T? value,
    required List<T> content,
    required String Function(T) displayText,
    required void Function(T?) onSelected,
    VoidCallback? onTap,
  }) {
    bool isExpanded = expandedIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (onTap != null) onTap();
                setState(() {
                  expandedIndex = isExpanded ? null : index;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.mainColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, size: 20, color: AppColors.mainColor),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTextStyles.medium14.copyWith(
                              color: Colors.blueGrey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            value != null ? displayText(value) : hint,
                            style: AppTextStyles.bold14.copyWith(
                              color: value != null
                                  ? Colors.black87
                                  : Colors.grey[400],
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.25 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: AppColors.mainColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(height: 1, indent: 20, endIndent: 20),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        itemCount: content.length,
                        itemBuilder: (context, i) {
                          final item = content[i];
                          bool isSelected = item == value;
                          return ListTile(
                            onTap: () {
                              onSelected(item);
                            },
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            title: Text(
                              displayText(item),
                              textAlign: TextAlign.right,
                              style: AppTextStyles.medium14.copyWith(
                                color: isSelected
                                    ? AppColors.mainColor
                                    : Colors.black87,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.mainColor,
                                    size: 18,
                                  )
                                : null,
                          );
                        },
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton(TeacherDegreesController controller) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.mainColor,
            AppColors.mainColor.withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.mainColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (controller.examValue.value == null) {
              controller.showSnackbarOnce(
                AppLanguage.warning.tr,
                AppLanguage.mustSelectRandomly.tr,
              );
              return;
            }
            Get.toNamed(ScreensUrls.teacherStudentDegreesScreenUrl);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Center(
              child: controller.loading.value
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      AppLanguage.gradesStr.tr,
                      style: AppTextStyles.bold14.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
