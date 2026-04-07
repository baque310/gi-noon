import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/teacher_students_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/function.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/models/class_model.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/models/stage_model.dart';
import 'package:noon/view/widget/custom_appbar.dart';

class TeacherStudentsScreen extends StatefulWidget {
  const TeacherStudentsScreen({super.key});

  @override
  State<TeacherStudentsScreen> createState() => _TeacherStudentsScreenState();
}

class _TeacherStudentsScreenState extends State<TeacherStudentsScreen> {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TeacherStudentsController());

    return Scaffold(
      appBar: CustomAppBar(appBarName: "الطلاب", isLeading: true),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFFF8F9FB)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 30),

                // 1. Stage (المرحلة)
                _buildAnimatedDropdownCard<Stage>(
                  index: 0,
                  title: AppLanguage.stageStr.tr,
                  hint: "اختر المرحلة",
                  icon: Icons.school_rounded,
                  value: controller.selectedStage.value,
                  content: controller.stages.toList(),
                  displayText: (item) => translateStage(item.name ?? ''),
                  onSelected: (v) {
                    controller.setStage(v);
                    setState(() => expandedIndex = null);
                  },
                ),

                // 2. Class (الصف)
                _buildAnimatedDropdownCard<ClassInfo>(
                  index: 1,
                  title: AppLanguage.academicStageWithOutSimiStr.tr,
                  hint: "اختر الصف",
                  icon: Icons.grid_view_rounded,
                  value: controller.selectedClass.value,
                  content: controller.classes.toList(),
                  displayText: (item) => item.name ?? '',
                  onTap: () {
                    if (controller.classes.isEmpty) {
                      controller.showSnackbarOnce(
                        AppLanguage.warning.tr,
                        "يرجى اختيار المرحلة أولاً",
                      );
                    }
                  },
                  onSelected: (v) {
                    controller.setClass(v);
                    setState(() => expandedIndex = null);
                  },
                ),

                // 3. Section (الشعبة)
                _buildAnimatedDropdownCard<Section>(
                  index: 2,
                  title: "الشعبة",
                  hint: "اختر الشعبة",
                  icon: Icons.groups_rounded,
                  value: controller.selectedSection.value,
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
                  },
                  onSelected: (v) {
                    controller.setSection(v);
                    setState(() => expandedIndex = null);
                  },
                ),

                const SizedBox(height: 40),
                _buildGradientButton(controller),
              ],
            );
          }),
        ),
      ),
    );
  }

  // ? Modern Header section with clear instructions for the teacher
  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "عرض الطلبة",
          style: AppTextStyles.bold14.copyWith(
            fontSize: 22,
            color: const Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "يرجى اختيار المرحلة والصف والشعبة للوصول لسجل الطلاب",
          style: AppTextStyles.medium14.copyWith(color: Colors.blueGrey[400]),
        ),
      ],
    );
  }

  // ? Reusable Custom Animated Dropdown Card for a Premium UI Feel
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

  // ? Gradient Button with Shadow and Loading State for professional interaction
  Widget _buildGradientButton(TeacherStudentsController controller) {
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
          onTap: () => controller.navigateToStudents(),
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
                      "البحث عن الطلبة",
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
