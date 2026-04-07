import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/models/teacher_subject_model.dart';
import '../../../../../../../controllers/homework_completed_controller.dart';
import '../../../../../../../controllers/student_controller.dart';
import '../../../../../../../core/constant/app_sizes.dart';
import '../../../../../../../core/constant/app_text_style.dart';
import '../../../../../../../core/function.dart';
import '../../../../../../../core/localization/language.dart';
import '../../../../../../../models/class_model.dart';
import '../../../../../../../models/section_model.dart';
import '../../../../../../../models/stage_model.dart';
import '../../../../../../widget/dropdown/generic_dropdown_widget.dart';
import '../../../../../../widget/dropdown/multi_select_dropdown_widget.dart';

class PartOneAddlessonWidget extends StatelessWidget {
  PartOneAddlessonWidget({super.key});

  final HomeworkCompletedController controller = Get.find();
  final studentController = Get.find<StudentController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            AppLanguage.chooseNextInfoToAddLessonStr.tr,
            style: AppTextStyles.medium14.copyWith(
              color: AppTextStyles.medium14.color!.withValues(alpha: 0.87),
            ),
          ),
          SizedBox(height: getDynamicHeight(16)),

          CustomGenericDropDown<Stage>(
            content: controller.stages.toList(),
            displayText: (item) => translateStage(item.name ?? ''),
            onChanged: (v) {
              controller.stageValue(v);
              controller.classValue.value = null;

              controller.subjectValue.value = null;
              controller.classes.clear();

              controller.subjects.clear();

              if (v?.id != null) {
                controller.getTeacherClass(v!.id);
              }
            },
            hint: AppLanguage.stageStr.tr,
            value: controller.stageValue.value,
          ),
          SizedBox(height: getDynamicHeight(16)),

          CustomGenericDropDown<ClassInfo>(
            onTap: () {
              if (controller.classes.isEmpty && controller.loading.value) {
                Get.snackbar(AppLanguage.warning.tr, AppLanguage.waiting.tr);
              }
              if (controller.classes.isEmpty && !controller.loading.value) {
                Get.snackbar(
                  AppLanguage.warning.tr,
                  AppLanguage.mustSelectRandomly.tr,
                );
              }
            },
            content: controller.classes.toList(),
            displayText: (item) => item.name ?? '',
            onChanged: (v) {
              controller.classValue(v);
              //if change status for the second time
              //remove all felds becoust all feaild dependent stage
              controller.selectedSections.clear();
              controller.sectionValue.value = null;
              controller.subjectValue.value = null;
              controller.sections.clear();
              controller.subjects.clear();
              if (v?.id != null) {
                controller.getTeacherSection(v!.id);
                controller.getTeacherSubject(v.id);
              }
            },
            hint: AppLanguage.academicStageWithOutSimiStr.tr,
            value: controller.classValue.value,
          ),
          SizedBox(height: getDynamicHeight(16)),

          MultiSelectGenericDropDown<Section>(
            onTap: () {
              if (controller.sections.isEmpty && controller.loading.value) {
                Get.snackbar(AppLanguage.warning.tr, AppLanguage.waiting.tr);
              }
              if (controller.sections.isEmpty && !controller.loading.value) {
                Get.snackbar(
                  AppLanguage.warning.tr,
                  AppLanguage.mustSelectRandomly.tr,
                );
              }
            },
            content: controller.sections.toList(),
            displayText: (item) => item.name ?? '',
            onChanged: (values) {
              controller.subjectValue.value = null;
              studentController.selectedStudentsIds.clear();
              studentController.students.clear();
              controller.selectedSections.assignAll(values);
            },
            hint: AppLanguage.divisionWithOutSimiStr.tr,
            selectedValues: controller.selectedSections,
          ),
          SizedBox(height: getDynamicHeight(16)),

          CustomGenericDropDown<TeacherSubject>(
            onTap: () {
              if (controller.sections.isEmpty ||
                  controller.selectedSections.isEmpty) {
                Get.snackbar(
                  AppLanguage.warning.tr,
                  AppLanguage.mustSelectRandomly.tr,
                );
              }
            },
            content: controller.subjects.toList(),
            displayText: (item) => item.stageSubject?.subject?.name ?? '',
            onChanged: controller.selectedSections.isNotEmpty
                ? (v) {
                    controller.subjectValue(v);
                  }
                : null,
            hint: AppLanguage.subjectStr.tr,
            value: controller.subjectValue.value,
          ),

          if (controller.stageValue.value != null &&
              controller.classValue.value != null &&
              controller.selectedSections.isNotEmpty) ...[
            SizedBox(height: getDynamicHeight(16)),

            SelectStudentsWidget(),
          ],
          SizedBox(height: getDynamicHeight(20)),
        ],
      );
    });
  }
}

class SelectStudentsWidget extends StatelessWidget {
  SelectStudentsWidget({super.key});

  final controller = Get.find<HomeworkCompletedController>();
  final studentController = Get.find<StudentController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.getStudents,
      child: Container(
        padding: const .symmetric(horizontal: 14),
        height: getDynamicHeight(55),
        decoration: BoxDecoration(
          borderRadius: .circular(12),
          border: .all(color: Colors.black.withValues(alpha: 0.12), width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            GetX<StudentController>(
              builder: (_) {
                return Text(
                  studentController.selectedStudentsIds.isEmpty
                      ? AppLanguage.chooseStudents.tr
                      : AppLanguage.selected.tr,
                  style: AppTextStyles.medium14.copyWith(
                    color: AppTextStyles.medium14.color!.withValues(
                      alpha: 0.60,
                    ),
                  ),
                );
              },
            ),
            const Icon(Icons.keyboard_arrow_down_sharp, color: Colors.teal),
          ],
        ),
      ),
    );
  }
}
