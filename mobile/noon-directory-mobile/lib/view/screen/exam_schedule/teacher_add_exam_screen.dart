import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/teacher_exams_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/models/stage_model.dart';
import 'package:noon/models/class_model.dart';
import 'package:noon/models/teacher_subject_model.dart';
import 'package:noon/core/function.dart';
import 'package:noon/view/widget/upload_file_widget.dart';

class TeacherCreateExamScreen extends StatefulWidget {
  const TeacherCreateExamScreen({super.key});

  @override
  State<TeacherCreateExamScreen> createState() =>
      _TeacherCreateExamScreenState();
}

class _TeacherCreateExamScreenState extends State<TeacherCreateExamScreen> {
  final controller = Get.put(TeacherExamsController());
  bool isEditing = false;
  String? editingExamId;
  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null && args is Map) {
      isEditing = args['isEditing'] == true;
      if (isEditing && args['examData'] != null) {
        final examData = args['examData'];
        editingExamId = examData.id;
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _prefillForm(examData),
        );
      } else {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => controller.clearForm(),
        );
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => controller.clearForm(),
      );
    }
  }

  @override
  void dispose() {
    // We only clear if we were adding a new exam to avoid keeping lingering text on next add
    if (!isEditing) {
      controller.clearForm();
    }
    super.dispose();
  }

  void _prefillForm(dynamic examData) {
    controller.contentController.text = examData.content ?? '';
    controller.scoreController.text = examData.score?.toString() ?? '';
    final stageSubject = examData.stageSubject;
    if (stageSubject != null) {
      controller.stageValue.value = stageSubject.stage;
      if (stageSubject.stage?.id != null) {
        controller.getTeacherClass(stageSubject.stage!.id).then((_) {
          controller.classValue.value = stageSubject.classDetail;
          if (stageSubject.classDetail?.id != null) {
            controller.getTeacherSection(stageSubject.classDetail!.id);
            controller.getTeacherSubject(stageSubject.classDetail!.id).then((
              _,
            ) {
              final matchingSubject = controller.subjects.firstWhereOrNull(
                (s) => s.stageSubject?.subject?.id == stageSubject.subject?.id,
              );
              controller.subjectValue.value = matchingSubject;
            });
          }
        });
      }
    }
    if (examData.examSections != null && examData.examSections.isNotEmpty) {
      final firstSection = examData.examSections.first;
      if (firstSection.exam?.examType != null) {
        controller.selectedExamType.value = firstSection.exam!.examType;
      }
      for (var examSection in examData.examSections) {
        if (examSection.section?.id != null) {
          controller.selectedSectionIds.add(examSection.section!.id!);
        }
      }
    }
    controller.updateFormValidity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: CustomAppBar(
        appBarName: isEditing
            ? '${AppLanguage.editStr.tr} ${AppLanguage.examStr.tr}'
            : AppLanguage.examStr.tr,
        isLeading: true,
        press: () => Get.back(),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 25),

              // Selection Section
              _buildAnimatedCard<Stage>(
                index: 0,
                title: AppLanguage.stageStr.tr,
                hint: "اختر المرحلة",
                icon: Icons.school_rounded,
                value: controller.stageValue.value,
                content: controller.stages.toList(),
                displayText: (item) => translateStage(item.name ?? ''),
                onSelected: (v) {
                  controller.stageValue(v);
                  _resetSubSelections();
                  if (v?.id != null) controller.getTeacherClass(v!.id);
                },
              ),

              _buildAnimatedCard<ClassInfo>(
                index: 1,
                title: AppLanguage.academicStageWithOutSimiStr.tr,
                hint: "اختر الصف",
                icon: Icons.grid_view_rounded,
                value: controller.classValue.value,
                content: controller.classes.toList(),
                displayText: (item) => item.name ?? '',
                onTap: () => _checkStageSelection(),
                onSelected: (v) {
                  controller.classValue(v);
                  _resetClassBasedSelections();
                  if (v?.id != null) {
                    controller.getTeacherSection(v!.id);
                    controller.getTeacherSubject(v.id);
                  }
                },
              ),

              // 3. Section Selection (Now moved before Subject)
              if (controller.sections.isNotEmpty)
                _buildSectionAnimatedCard(index: 2),

              _buildAnimatedCard<TeacherSubject>(
                index: 3,
                title: AppLanguage.subjectStr.tr,
                hint: "اختر المادة",
                icon: Icons.book_rounded,
                value: controller.subjectValue.value,
                content: controller.filteredSubjects,
                displayText: (item) => item.stageSubject?.subject?.name ?? '',
                onTap: () => _checkClassSelection(),
                onSelected: (v) {
                  controller.subjectValue(v);
                  controller.updateFormValidity();
                },
              ),

              // 4. Exam Type Card
              _buildAnimatedCard<dynamic>(
                index: 4,
                title: "نوع الامتحان",
                hint: "اختر نوع الامتحان",
                icon: Icons.assignment_rounded,
                value: controller.selectedExamType.value,
                content: controller.examTypes.toList(),
                displayText: (item) => item.name ?? '',
                onSelected: (v) {
                  controller.selectedExamType.value = v;
                  controller.updateFormValidity();
                },
              ),

              // 6. Exam Details Card (Now revamped)
              if (controller.selectedSectionIds.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildExamDetailsCard(),
                const SizedBox(height: 20),
                _buildAttachmentCard(),
                const SizedBox(height: 30),
                _buildSubmitButton(),
                const SizedBox(height: 50),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: controller.isFormValid.value
              ? [
                  AppColors.mainColor,
                  AppColors.mainColor.withValues(alpha: 0.8),
                ]
              : [Colors.grey[400]!, Colors.grey[400]!],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: controller.isFormValid.value
            ? [
                BoxShadow(
                  color: AppColors.mainColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: controller.isFormValid.value && !controller.loading.value
            ? () => isEditing ? _processUpdate() : controller.createExam()
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: controller.loading.value
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                isEditing ? AppLanguage.editStr.tr : AppLanguage.addStr.tr,
                style: AppTextStyles.bold14.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEditing ? AppLanguage.editStr.tr : "إضافة امتحان جديد",
          style: AppTextStyles.bold14.copyWith(
            fontSize: 22,
            color: const Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "املأ البيانات التالية لتعريف امتحان جديد لطلابك",
          style: AppTextStyles.medium14.copyWith(color: Colors.blueGrey[400]),
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

  Widget _buildSectionAnimatedCard({required int index}) {
    bool isExpanded = expandedIndex == index;
    String selectedNames = controller.selectedSectionIds.isEmpty
        ? "اختر الشعبة"
        : controller.sections
              .where((s) => controller.selectedSectionIds.contains(s.id))
              .map((s) => s.name)
              .join('، ');

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
              onTap: () =>
                  setState(() => expandedIndex = isExpanded ? null : index),
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
                      child: Icon(
                        Icons.groups_rounded,
                        size: 22,
                        color: AppColors.mainColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLanguage.divisionStr.tr,
                            style: AppTextStyles.medium12.copyWith(
                              color: Colors.blueGrey[300],
                            ),
                          ),
                          Text(
                            selectedNames,
                            style: AppTextStyles.bold14.copyWith(
                              color: controller.selectedSectionIds.isNotEmpty
                                  ? Colors.black87
                                  : Colors.grey[400],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: controller.sections.map((s) {
                            bool isSelected = controller.selectedSectionIds
                                .contains(s.id);
                            return FilterChip(
                              label: Text(s.name ?? ''),
                              selected: isSelected,
                              onSelected: (v) {
                                controller.setSectionChecked(s.id!, v);
                                setState(() {}); // Update the card summary text
                              },
                              selectedColor: AppColors.mainColor.withValues(
                                alpha: 0.2,
                              ),
                              checkmarkColor: AppColors.mainColor,
                              labelStyle: AppTextStyles.medium12.copyWith(
                                color: isSelected
                                    ? AppColors.mainColor
                                    : Colors.black87,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            );
                          }).toList(),
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

  Widget _buildExamDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
                  color: AppColors.mainColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: AppColors.mainColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "تفاصيل الامتحان",
                style: AppTextStyles.bold14.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Exam Description Field
          Text(
            "وصف الامتحان",
            style: AppTextStyles.medium14.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller.contentController,
            maxLines: 3,
            onChanged: (_) => controller.updateFormValidity(),
            decoration: InputDecoration(
              hintText: "مثلاً: الفصل الأول - الشهر الثاني",
              hintStyle: AppTextStyles.medium14.copyWith(
                color: Colors.grey[400],
              ),
              prefixIcon: const Icon(
                Icons.edit_note_rounded,
                color: Colors.amber,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.amber.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.amber, width: 1.5),
              ),
              filled: true,
              fillColor: const Color(0xFFFFFBF0),
            ),
          ),

          const SizedBox(height: 20),

          // Max Score Field
          Text(
            "درجة الإمتحان العليا",
            style: AppTextStyles.medium14.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller.scoreController,
            keyboardType: TextInputType.number,
            onChanged: (_) => controller.updateFormValidity(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: "مثلاً: 100",
              hintStyle: AppTextStyles.medium14.copyWith(
                color: Colors.grey[400],
              ),
              prefixIcon: Icon(Icons.speed_rounded, color: AppColors.mainColor),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: AppColors.mainColor.withValues(alpha: 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.mainColor, width: 1.5),
              ),
              filled: true,
              fillColor: AppColors.mainColor.withValues(alpha: 0.02),
            ),
          ),

          const SizedBox(height: 20),

          // Date Picker Field
          Text(
            "تاريخ الامتحان",
            style: AppTextStyles.medium14.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => controller.pickDate(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.blueGrey.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.blueGrey.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.blueGrey,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Obx(
                    () => Text(
                      controller.selectedDate.value,
                      style: AppTextStyles.medium14.copyWith(
                        color: controller.selectedDate.value == 'تحديد تاريخ'
                            ? Colors.grey[400]
                            : Colors.black87,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          UploadFileWidget(
            title: '${AppLanguage.uploadAttachments.tr} (PDF)',
            onTaped: controller.pickPdfFile,
          ),
          if (controller.pdfFile.value != null) ...[
            const SizedBox(height: 12),
            _buildFilePreview(),
          ],
        ],
      ),
    );
  }

  Widget _buildFilePreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              controller.pdfFile.value!.path.split('/').last,
              style: AppTextStyles.medium12,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: controller.removePdfFile,
            icon: const Icon(Icons.cancel_rounded, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }

  void _resetSubSelections() {
    controller.classValue.value = null;
    controller.sectionValue.value = null;
    controller.subjectValue.value = null;
    controller.classes.clear();
    controller.sections.clear();
    controller.subjects.clear();
    controller.selectedSectionIds.clear();
  }

  void _resetClassBasedSelections() {
    controller.sectionValue.value = null;
    controller.subjectValue.value = null;
    controller.sections.clear();
    controller.subjects.clear();
    controller.selectedSectionIds.clear();
  }

  void _checkStageSelection() {
    if (controller.classes.isEmpty) {
      controller.showSnackbarOnce(
        AppLanguage.warning.tr,
        AppLanguage.mustSelectRandomly.tr,
      );
    }
  }

  void _checkClassSelection() {
    if (controller.subjects.isEmpty) {
      controller.showSnackbarOnce(
        AppLanguage.warning.tr,
        AppLanguage.thereIsNoSubjects.tr,
      );
    }
  }

  Future<void> _processUpdate() async {
    final Map<String, dynamic> updateData = {
      'content': controller.contentController.text.trim(),
      'score': double.tryParse(controller.scoreController.text.trim()) ?? 0.0,
    };
    if (controller.selectedExamType.value?.id != null) {
      updateData['examTypeId'] = controller.selectedExamType.value!.id;
    }
    if (controller.subjectValue.value?.stageSubjectId != null) {
      updateData['stageSubjectId'] =
          controller.subjectValue.value!.stageSubjectId;
    }
    if (controller.selectedSectionIds.isNotEmpty) {
      updateData['sectionIds'] = controller.selectedSectionIds.toList();
    }
    await controller.updateExam(editingExamId!, updateData);
    if (!controller.loading.value) Get.back();
  }
}
