import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/view/screen/attendances/widgets/teacher_attendances_list.dart';
import 'package:s_extensions/s_extensions.dart';
import '../../../controllers/attendances_controller.dart';
import '../../../core/constant/app_text_style.dart';
import '../../../core/function.dart';
import '../../../core/localization/language.dart';
import '../../../models/class_model.dart';
import '../../../models/section_model.dart';
import '../../../models/stage_model.dart';
import '../../../models/teacher_section_schedule.dart';
import '../../widget/bottom_navbar.dart';
import '../../widget/custom_appbar.dart';

class TeacherAttendancesScreen extends StatefulWidget {
  const TeacherAttendancesScreen({super.key});

  @override
  State<TeacherAttendancesScreen> createState() =>
      _TeacherAttendancesScreenState();
}

class _TeacherAttendancesScreenState extends State<TeacherAttendancesScreen> {
  int? expandedIndex;

  final Map<String, String> reversedDaysMap = {
    'SUNDAY': 'الأحد',
    'MONDAY': 'الإثنين',
    'TUESDAY': 'الثلاثاء',
    'WEDNESDAY': 'الأربعاء',
    'THURSDAY': 'الخميس',
    'FRIDAY': 'الجمعة',
    'SATURDAY': 'السبت',
  };

  @override
  Widget build(BuildContext context) {
    AttendancesController controller = Get.find();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: CustomAppBar(
          appBarName: AppLanguage.studentStatus.tr,
          isLeading: true,
        ),
        body: SafeArea(
          child: Obx(() {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(
                    "سجل الحضور والغياب",
                    "اختر تفاصيل البحث للوصول لسجل الحضور المطلوب",
                  ),
                  const SizedBox(height: 20),
                  // 1. Stage
                  _buildAnimatedCard<Stage>(
                    index: 0,
                    title: AppLanguage.stageStr.tr,
                    hint: "اختر المرحلة",
                    icon: Icons.school_rounded,
                    value: controller.stageValue.value,
                    content: controller.stages.toList(),
                    displayText: (item) => translateStage(item.name ?? ''),
                    onTap: () {
                      if (controller.stages.isEmpty) {
                        controller.getTeacherStage();
                      }
                    },
                    onSelected: (v) {
                      controller.stageValue(v);
                      controller.classValue.value = null;
                      controller.sectionValue.value = null;
                      controller.classes.clear();
                      controller.sections.clear();
                      controller.selectedDate('تحديد تاريخ');
                      controller.teacherSectionScheduleList.clear();
                      controller.teacherAttendances.clear();
                      controller.dayValue.value = null;
                      if (v?.id != null) {
                        controller.getTeacherClass(v!.id);
                      }
                    },
                  ),

                  // 2. Class
                  _buildAnimatedCard<ClassInfo>(
                    index: 1,
                    title: AppLanguage.classStr.tr,
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
                      controller.sectionValue.value = null;
                      controller.sections.clear();
                      controller.selectedDate('تحديد تاريخ');
                      controller.teacherSectionScheduleList.clear();
                      controller.teacherAttendances.clear();
                      controller.dayValue.value = null;
                      if (v?.id != null) {
                        controller.getTeacherSection(v!.id);
                      }
                    },
                  ),

                  // 3. Section
                  _buildAnimatedCard<Section>(
                    index: 2,
                    title: "الشعبة",
                    hint: "اختر الشعبة",
                    icon: Icons.groups_rounded,
                    value: controller.sectionValue.value,
                    content: controller.sections.toList(),
                    displayText: (item) => item.name ?? '',
                    onTap: () {
                      if (controller.sections.isEmpty) {
                        controller.showSnackbarOnce(
                          AppLanguage.warning.tr,
                          AppLanguage.thereIsNoSections.tr,
                        );
                      }
                    },
                    onSelected: (v) {
                      controller.sectionValue(v);
                      controller.sectionId.value = v?.id;
                      controller.selectedDate('تحديد تاريخ');
                      controller.teacherSectionScheduleList.clear();
                      controller.teacherAttendances.clear();
                      controller.dayValue.value = null;
                    },
                  ),

                  // 4. Date Picker
                  _buildDateCard(controller),

                  // 5. Lesson Selection (TeacherSectionSchedule)
                  if (controller.teacherSectionScheduleList.isNotEmpty)
                    _buildAnimatedCard<TeacherSectionSchedule>(
                      index: 4,
                      title: "الدرس",
                      hint: "اختر الدرس",
                      icon: Icons.history_toggle_off_rounded,
                      value:
                          controller.teacherSectionScheduleList.contains(
                            controller.dayValue.value,
                          )
                          ? controller.dayValue.value
                          : null,
                      content: controller.teacherSectionScheduleList.toList(),
                      displayText: (item) =>
                          "${reversedDaysMap[item.schedule?.day]} ${item.schedule!.timeFrom!.toDate!.formatDateTime} - ${item.schedule!.timeTo!.toDate!.formatDateTime}",
                      onSelected: (v) {
                        controller.dayValue(v);
                        controller.sectionScheduleId.value = v?.id;
                        if (v?.id != null) {
                          controller.getTeacherAttendances();
                        }
                      },
                    ),

                  const SizedBox(height: 20),

                  if (controller.teacherAttendances.isNotEmpty)
                    const AttendanceList(),

                  if (controller.dayValue.value != null &&
                      !controller.loading.value &&
                      controller.teacherAttendances.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          AppLanguage.studentStatusNoteStr.tr,
                          style: AppTextStyles.medium14.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),

                  if (controller.selectedDate.value != 'تحديد تاريخ' &&
                      !controller.loading.value &&
                      controller.teacherSectionScheduleList.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          AppLanguage.classNotFoundStr.tr,
                          style: AppTextStyles.medium14.copyWith(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
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
              enable:
                  controller.sectionId.value != null &&
                  controller.selectedDate.value != 'تحديد تاريخ' &&
                  controller.sectionScheduleId.value != null,
              text: AppLanguage.addStudentStatusStr.tr,
              onTap: () {
                controller.getTeacherStudents();
                Get.toNamed(ScreensUrls.teacherAddStudentStatusUrl);
              },
            ),
          );
        }),
      ),
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
                if (onTap != null) onTap();
                setState(() => expandedIndex = isExpanded ? null : index);
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

  Widget _buildDateCard(AttendancesController controller) {
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
          onTap: () {
            if (controller.stageValue.value == null ||
                controller.classValue.value == null ||
                controller.sectionValue.value == null) {
              controller.showSnackbarOnce(
                AppLanguage.warning.tr,
                AppLanguage.mustSelectRandomly.tr,
              );
            } else {
              controller.teacherSectionScheduleList.clear();
              controller.teacherAttendances.clear();
              controller.dayValue.value = null;
              controller.sectionScheduleId.value = null;
              controller.pickDate();
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.calendar_today_rounded,
                    size: 22,
                    color: Colors.teal,
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
                        controller.selectedDate.value,
                        style: AppTextStyles.bold14.copyWith(
                          color: controller.selectedDate.value == 'تحديد تاريخ'
                              ? Colors.grey[400]
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.event_available_rounded,
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

  Widget _buildHeaderSection(String title, String desc) {
    return Column(
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
          style: AppTextStyles.medium14.copyWith(color: Colors.blueGrey[300]),
        ),
      ],
    );
  }
}
