import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/homework_completed_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/function.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/models/class_model.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/models/stage_model.dart';
import 'package:noon/models/teacher_subject_model.dart';
import 'package:noon/view/screen/home/pages/assignments/teacher/teacher_lessons_section.dart';
import 'package:noon/core/constant/screens_urls.dart';

class TeacherLessonsFilterScreen extends StatefulWidget {
  const TeacherLessonsFilterScreen({super.key});

  @override
  State<TeacherLessonsFilterScreen> createState() =>
      _TeacherLessonsFilterScreenState();
}

class _TeacherLessonsFilterScreenState
    extends State<TeacherLessonsFilterScreen> {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeworkCompletedController());
    if (controller.stages.isEmpty) {
      controller.getTeacherStage();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 40),
              // 1. Stage
              _buildAnimatedCard<Stage>(
                index: 0,
                title: AppLanguage.stageStr.tr,
                hint: "اختر المرحلة",
                icon: Icons.school_rounded,
                value: controller.searchStageValue.value,
                content: controller.stages.toList(),
                displayText: (item) => translateStage(item.name ?? ''),
                onSelected: (v) {
                  controller.searchStageValue.value = v;
                  controller.searchClassValue.value = null;
                  controller.searchSectionValue.value = null;
                  controller.searchSubjectValue.value = null;
                  if (v != null) {
                    controller.getTeacherClass(v.id);
                  } else {
                    controller.classes.clear();
                    controller.sections.clear();
                    controller.subjects.clear();
                  }
                },
              ),

              // 2. Class
              _buildAnimatedCard<ClassInfo>(
                index: 1,
                title: AppLanguage.classStr.tr,
                hint: "اختر الصف",
                icon: Icons.grid_view_rounded,
                value: controller.searchClassValue.value,
                content: controller.classes.toList(),
                displayText: (item) => item.name ?? '',
                onSelected: (v) {
                  controller.searchClassValue.value = v;
                  controller.searchSectionValue.value = null;
                  controller.searchSubjectValue.value = null;
                  if (v != null) {
                    controller.getTeacherSection(v.id);
                    controller.getTeacherSubject(v.id);
                  } else {
                    controller.sections.clear();
                    controller.subjects.clear();
                  }
                },
              ),

              // 3. Section
              _buildAnimatedCard<Section>(
                index: 2,
                title: "الشعبة",
                hint: "اختر الشعبة",
                icon: Icons.groups_rounded,
                value: controller.searchSectionValue.value,
                content: controller.sections.toList(),
                displayText: (item) => item.name ?? '',
                onSelected: (v) {
                  controller.searchSectionValue.value = v;
                },
              ),

              // 4. Subject
              _buildAnimatedCard<TeacherSubject>(
                index: 3,
                title: AppLanguage.subjectStr.tr,
                hint: "اختر المادة",
                icon: Icons.book_rounded,
                value: controller.searchSubjectValue.value,
                content: controller.subjects.toList(),
                displayText: (item) => item.stageSubject?.subject?.name ?? '',
                onSelected: (v) {
                  controller.searchSubjectValue.value = v;
                },
              ),

              // 5. Date
              _buildDateCard(controller),

              const SizedBox(height: 30),

              // Action Button
              _buildActionButton(),
              const SizedBox(height: 50),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "فلترة الدروس",
                style: AppTextStyles.bold16.copyWith(
                  fontSize: 22,
                  color: const Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "اختر تفاصيل البحث المطلوبة",
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
          onTap: () => Get.toNamed(ScreensUrls.addLessonTeacherScreenUrl),
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
                  "إضافة درس",
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

  Widget _buildAnimatedCard<T>({
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
      margin: const EdgeInsets.only(bottom: 16),
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
                if (onTap != null) onTap();
                setState(() => expandedIndex = isExpanded ? null : index);
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.mainColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, size: 22, color: AppColors.mainColor),
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
            child: isExpanded
                ? Column(
                    children: [
                      const Divider(height: 1, indent: 20, endIndent: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: content.length,
                        itemBuilder: (context, i) {
                          final item = content[i];
                          bool isSelected = item == value;
                          return ListTile(
                            onTap: () {
                              onSelected(item);
                              setState(() => expandedIndex = null);
                            },
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
                    ],
                  )
                : const SizedBox(width: double.infinity, height: 0),
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard(HomeworkCompletedController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.pickSearchDate(),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.calendar_today_rounded,
                    size: 22,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLanguage.date.tr,
                        style: AppTextStyles.medium12.copyWith(
                          color: Colors.blueGrey[300],
                        ),
                      ),
                      Text(
                        controller.searchDate.value.isEmpty
                            ? "تحديد التاريخ"
                            : controller.searchDate.value,
                        style: AppTextStyles.bold14.copyWith(
                          color: controller.searchDate.value.isEmpty
                              ? Colors.grey[400]
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.event_note_rounded,
                  size: 20,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
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
          Get.to(() => TeacherLessonSection(), arguments: {'filtered': true});
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          "أرشيف الدروس",
          style: AppTextStyles.bold14.copyWith(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
