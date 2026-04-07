import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/homework_completed_controller.dart';
import 'package:noon/controllers/student_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/function.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/models/class_model.dart';
import 'package:noon/models/stage_model.dart';
import 'package:noon/models/teacher_subject_model.dart';
import 'package:noon/view/widget/bottom_navbar.dart';
import 'package:noon/view/widget/files_list_widget.dart';
import 'package:noon/view/widget/upload_file_widget.dart';
import 'package:noon/view/widget/custom_appbar.dart';

class AddLessonScreen extends StatefulWidget {
  const AddLessonScreen({super.key});

  @override
  State<AddLessonScreen> createState() => _AddLessonScreenState();
}

class _AddLessonScreenState extends State<AddLessonScreen> {
  final controller = Get.find<HomeworkCompletedController>();
  final studentController = Get.find<StudentController>();
  int? expandedIndex;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    isEdit = (args != null && args == true);
  }

  @override
  void dispose() {
    if (!isEdit) {
      controller.clearPreviseData();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: CustomAppBar(
        appBarName: isEdit ? AppLanguage.editLesson.tr : "إضافة درس جديد",
        isLeading: true,
        press: () => Get.back(),
      ),
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isEdit) ...[
                  // 1. Stage
                  _buildAnimatedCard<Stage>(
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
                      controller.subjectValue.value = null;
                      controller.classes.clear();
                      controller.subjects.clear();
                      if (v?.id != null) controller.getTeacherClass(v!.id);
                    },
                  ),

                  // 2. Class
                  _buildAnimatedCard<ClassInfo>(
                    index: 1,
                    title: "الصف",
                    hint: "اختر الصف",
                    icon: Icons.grid_view_rounded,
                    value: controller.classValue.value,
                    content: controller.classes.toList(),
                    displayText: (item) => item.name ?? '',
                    onSelected: (v) {
                      controller.classValue(v);
                      controller.selectedSections.clear();
                      controller.subjectValue.value = null;
                      controller.sections.clear();
                      controller.subjects.clear();
                      if (v?.id != null) {
                        controller.getTeacherSection(v!.id);
                        controller.getTeacherSubject(v.id);
                      }
                    },
                  ),

                  // 3. Section (Multi-select)
                  _buildSectionAnimatedCard(index: 2),

                  // 4. Subject
                  _buildAnimatedCard<TeacherSubject>(
                    index: 3,
                    title: "المادة",
                    hint: "اختر المادة",
                    icon: Icons.book_rounded,
                    value: controller.subjectValue.value,
                    content: controller.filteredSubjects,
                    displayText: (item) =>
                        item.stageSubject?.subject?.name ?? '',
                    onSelected: (v) => controller.subjectValue(v),
                  ),

                  // 5. Student Selector
                  if (controller.stageValue.value != null &&
                      controller.classValue.value != null &&
                      controller.selectedSections.isNotEmpty)
                    _buildStudentSelectorCard(),
                ],

                const SizedBox(height: 20),

                // Title and Description
                _buildInputCard(),

                const SizedBox(height: 24),

                // Attachments
                if (!isEdit)
                  UploadFileWidget(
                    title: AppLanguage.uploadAttachments.tr,
                    onTaped: controller.showFilePickerBottomSheet,
                  ),

                const SizedBox(height: 16),

                if (controller.images.isNotEmpty)
                  FilesListWidget(
                    files: controller.images.toList(),
                    onRemoveFilePressed: controller.removeFileAt,
                  ),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: Obx(() {
        return IgnorePointer(
          ignoring: controller.loading.value,
          child: BottomNavbar(
            backgroundColor: Colors.white,
            enable: isEdit
                ? controller.isFormValidEdit.value
                : controller.isFormValid.value,
            loading: controller.loading.value,
            text: isEdit
                ? AppLanguage.editLesson.tr
                : AppLanguage.addLessonStr.tr,
            onTap: !isEdit
                ? () async {
                    await controller.addLesson();
                    controller.pagingController.refresh();
                  }
                : () async {
                    await controller.editLesson();
                    controller.pagingController.refresh();
                  },
          ),
        );
      }),
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
              onTap: () =>
                  setState(() => expandedIndex = isExpanded ? null : index),
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
                        color: AppColors.mainColor.withValues(alpha: 0.1),
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
                : const SizedBox(height: 0, width: double.infinity),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionAnimatedCard({required int index}) {
    bool isExpanded = expandedIndex == index;
    String sectionText = controller.selectedSections.isEmpty
        ? "اختر الشعبة"
        : controller.selectedSections.map((s) => s.name).join(' ، ');

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
              onTap: () =>
                  setState(() => expandedIndex = isExpanded ? null : index),
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
                        color: AppColors.mainColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.groups_rounded,
                        size: 20,
                        color: AppColors.mainColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "الشعبة",
                            style: AppTextStyles.medium12.copyWith(
                              color: Colors.blueGrey[300],
                            ),
                          ),
                          Text(
                            sectionText,
                            style: AppTextStyles.bold14.copyWith(
                              color: controller.selectedSections.isNotEmpty
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
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        const Divider(height: 1),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          children: controller.sections.map((section) {
                            bool isSelected = controller.selectedSections
                                .contains(section);
                            return FilterChip(
                              label: Text(section.name ?? ''),
                              selected: isSelected,
                              onSelected: (bool selected) {
                                if (selected) {
                                  controller.selectedSections.add(section);
                                } else {
                                  controller.selectedSections.remove(section);
                                }
                                if (controller.subjectValue.value != null &&
                                    !controller.filteredSubjects.contains(
                                      controller.subjectValue.value,
                                    )) {
                                  controller.subjectValue.value = null;
                                }
                                studentController.selectedStudentsIds.clear();
                                studentController.students.clear();
                              },
                              selectedColor: AppColors.mainColor.withValues(
                                alpha: 0.2,
                              ),
                              checkmarkColor: AppColors.mainColor,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(height: 0, width: double.infinity),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentSelectorCard() {
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.getStudents,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.person_search_rounded,
                    size: 20,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "تحديد الطلاب",
                        style: AppTextStyles.medium12.copyWith(
                          color: Colors.blueGrey[300],
                        ),
                      ),
                      Text(
                        studentController.selectedStudentsIds.isEmpty
                            ? AppLanguage.chooseStudents.tr
                            : "تم تحديد ${studentController.selectedStudentsIds.length} طالب",
                        style: AppTextStyles.bold14.copyWith(
                          color:
                              studentController.selectedStudentsIds.isNotEmpty
                              ? Colors.black87
                              : Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController ctrl,
    required String hint,
    required Function(String) onChanged,
    int maxLines = 1,
    Widget? icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE482), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          TextField(
            controller: ctrl,
            onChanged: onChanged,
            maxLines: maxLines,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                maxLines > 1 ? 40 : 16,
              ),
              hintStyle: AppTextStyles.medium14.copyWith(
                color: Colors.grey[400],
              ),
            ),
          ),
          if (icon != null) Positioned(bottom: 8, left: 12, child: icon),
        ],
      ),
    );
  }

  Widget _buildInputCard() {
    return Column(
      children: [
        _buildTextField(
          ctrl: controller.titleController,
          hint: 'مثلاً: الفصل الاول - الشهر الثاني',
          onChanged: (v) => controller.title.value = v,
          icon: const Icon(
            Icons.edit_note_rounded,
            color: Color(0xFFFDE482),
            size: 28,
          ),
        ),
        _buildTextField(
          ctrl: controller.descController,
          hint: AppLanguage.lessonDetailsStr.tr,
          onChanged: (v) => controller.description.value = v,
          maxLines: 4,
        ),
      ],
    );
  }
}
