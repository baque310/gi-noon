import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/behavior_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/view/widget/color_button.dart';
import 'package:s_extensions/s_extensions.dart';

class BehaviorEvaluationBottomSheet extends StatelessWidget {
  const BehaviorEvaluationBottomSheet({super.key});

  static void show() {
    final controller = Get.find<BehaviorController>();
    controller.loadBehaviorSheetData();

    Get.bottomSheet(
      const BehaviorEvaluationBottomSheet().safeArea(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BehaviorController>();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFBFBFE),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              15.verticalSpace,
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              20.verticalSpace,

              Text(
                "تقييم سلوك الطلاب",
                style: AppTextStyles.bold14.copyWith(fontSize: 18),
              ),
              20.verticalSpace,

              // ? Student Selector (Horizontal Chips)
              if (controller.selectedStudents.length > 1) ...[
                _StudentSelector(),
                20.verticalSpace,
              ],

              // ? Content
              Expanded(
                child: Obx(() {
                  if (controller.sheetLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final sections = controller.behaviorSections;
                  final types = controller.behaviorTypes;

                  if (sections.isEmpty || types.isEmpty) {
                    return Center(
                      child: Text(
                        AppLanguage.noInfoAvailable.tr,
                        style: AppTextStyles.medium14,
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: sections.length + 1, // +1 for notes
                    itemBuilder: (context, index) {
                      if (index < sections.length) {
                        return _SectionRatingCard(
                          sectionId: sections[index].id,
                          title: sections[index].name,
                          types: types,
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          child: _NotesSection(controller: controller),
                        );
                      }
                    },
                  );
                }),
              ),

              // ? Submit button
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ColorButton(
                    text: AppLanguage.addStudentBehaviorStr.tr,
                    loading: controller.loading.value,
                    press: controller.submitBehavior,
                  ),
                ),
              ),
              15.verticalSpace,
            ],
          ),
        );
      },
    );
  }
}

// بطاقة التقييم الجديدة (الاحترافية)
class _SectionRatingCard extends StatelessWidget {
  final String sectionId;
  final String title;
  final List types;

  const _SectionRatingCard({
    required this.sectionId,
    required this.title,
    required this.types,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BehaviorController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                final selected = controller.getRating(sectionId);
                final label = selected < types.length
                    ? types[selected].name
                    : '';
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(selected).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    label,
                    style: AppTextStyles.bold14.copyWith(
                      color: _getStatusColor(selected),
                      fontSize: 12,
                    ),
                  ),
                );
              }),
              Text(
                title,
                style: AppTextStyles.bold14.copyWith(
                  color: const Color(0xFF2D3142),
                ),
              ),
            ],
          ),
          15.verticalSpace,
          Obx(() {
            final selected = controller.getRating(sectionId);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(types.length, (index) {
                final isSelected = index == selected;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => controller.updateRating(sectionId, index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _getStatusColor(index)
                            : const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? _getStatusColor(index)
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _getFaceEmoji(index, types.length),
                            style: TextStyle(fontSize: isSelected ? 22 : 18),
                          ),
                          4.verticalSpace,
                          Text(
                            types[index].name.toString().split(' ').first,
                            style: AppTextStyles.medium12.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[600],
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  Color _getStatusColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFF4D4D); // ضعيف
      case 1:
        return const Color(0xFFFFB300); // مقبول
      case 2:
        return const Color(0xFF4CAF50); // جيد
      case 3:
        return const Color(0xFF00BFA5); // ممتاز
      default:
        return AppColors.mainColor;
    }
  }

  String _getFaceEmoji(int index, int total) {
    // توزيع التعبيرات حسب الترتيب
    const emojis = ['😣', '😐', '😊', '🤩'];
    if (index < emojis.length) return emojis[index];
    return '😊';
  }
}

class _NotesSection extends StatelessWidget {
  final BehaviorController controller;

  const _NotesSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            AppLanguage.additionalNotesStr.tr,
            style: AppTextStyles.bold14.copyWith(
              color: const Color(0xFF2D3142),
            ),
            textAlign: .right,
          ),
        ),
        12.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller.notesController,
            onChanged: (val) => controller.updateNotes(val),
            maxLines: 3,
            textAlign: .right,
            textDirection: .rtl,
            style: AppTextStyles.regular14,
            decoration: InputDecoration(
              hintText: AppLanguage.writeNotesHereStr.tr,
              hintStyle: AppTextStyles.regular14.copyWith(
                color: Colors.grey[400],
              ),
              border: .none,
              prefixIcon: Icon(
                Icons.edit_note,
                color: AppColors.mainColor.withValues(alpha: 0.5),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}

class _StudentSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BehaviorController>();
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        children: [
          // ? "All Students" Chip
          Obx(() {
            final isSelected = controller.currentStudentId.value == null;
            return _buildChip(
              label: AppLanguage.all.tr,
              isSelected: isSelected,
              onTap: () => controller.setCurrentStudent(null),
            );
          }),

          // ? Individual Students
          ...controller.selectedStudents.map((student) {
            return Obx(() {
              final isSelected =
                  controller.currentStudentId.value == student.id;
              final hasData =
                  (controller.behaviorDrafts[student.id]?.ratings.values.any(
                        (v) => v > 0,
                      ) ??
                      false) ||
                  (controller.behaviorDrafts[student.id]?.notes.isNotEmpty ??
                      false);

              return _buildChip(
                label: student.student.fullName.split(' ').first,
                isSelected: isSelected,
                hasData: !isSelected && hasData,
                onTap: () => controller.setCurrentStudent(student.id),
              );
            });
          }),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    bool hasData = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainColor : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? AppColors.mainColor
                : Colors.grey.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.mainColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            if (hasData) ...[
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF00BFA5),
                  shape: BoxShape.circle,
                ),
              ),
              8.horizontalSpace,
            ],
            Text(
              label,
              style: AppTextStyles.bold14.copyWith(
                color: isSelected ? Colors.white : Colors.blueGrey[700],
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
