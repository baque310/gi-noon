import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:noon/controllers/behavior_controller.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/models/student_enrollment_model.dart';
import 'package:noon/view/widget/behavior_evaluation_bottom_sheet.dart';
import 'package:noon/view/widget/color_button.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:s_extensions/s_extensions.dart';

class TeacherStudentsBehaviorScreen extends StatefulWidget {
  const TeacherStudentsBehaviorScreen({super.key});

  @override
  State<TeacherStudentsBehaviorScreen> createState() =>
      _TeacherStudentsBehaviorScreenState();
}

class _TeacherStudentsBehaviorScreenState
    extends State<TeacherStudentsBehaviorScreen> {
  final controller = Get.find<BehaviorController>();
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getTeacherStudents(controller.selectedSection.value?.id);
    });
  }

  String _formatDate(DateTime date) {
    bool isArabic = Get.find<GlobalController>().locale.languageCode == 'ar';
    final localeTag = isArabic ? 'ar' : 'en';
    final String monthName = intl.DateFormat('MMMM', localeTag).format(date);
    return '${date.day} $monthName';
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBackground,
      appBar: CustomAppBar(
        appBarName: AppLanguage.studentsBehaviorStr.tr,
        isLeading: true,
      ),
      body: Padding(
        padding: .all(20.0),
        child: Column(
          children: [
            // ? Search Bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.neutralWhite,
                borderRadius: .circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  16.horizontalSpace,
                  Container(
                    padding: .all(10),
                    decoration: BoxDecoration(
                      color: AppColors.mainColor.withValues(alpha: 0.1),
                      borderRadius: .circular(8),
                    ),
                    child: Icon(
                      Icons.tune,
                      color: AppColors.mainColor,
                      size: 20,
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Obx(
                      () => TextField(
                        controller: searchController,
                        onChanged: (val) {
                          controller.searchQuery.value = val;
                        },
                        textAlign: .right,
                        style: AppTextStyles.regular14,
                        decoration: InputDecoration(
                          hintText: AppLanguage.searchByStudentNameStr.tr,
                          hintStyle: AppTextStyles.regular14.copyWith(
                            color: AppColors.neutralMidGrey,
                          ),
                          border: .none,
                          suffixIcon: controller.searchQuery.value.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: AppColors.neutralMidGrey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    searchController.clear();
                                    controller.searchQuery.value = '';
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: .symmetric(horizontal: 12),
                    child: Icon(
                      Icons.search,
                      color: AppColors.neutralMidGrey,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            16.verticalSpace,

            // ? Date Range Filter
            Obx(
              () => GestureDetector(
                onTap: controller.selectDateRange,
                child: Container(
                  padding: .symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.neutralWhite,
                    borderRadius: .circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: AppColors.mainColor,
                      ),
                      8.horizontalSpace,
                      Text(
                        '${_formatDate(controller.startDate.value)} ← ${_formatDate(controller.endDate.value)}',
                        style: AppTextStyles.medium12.copyWith(
                          color: AppColors.neutralDarkGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            12.verticalSpace,

            // ? Select All Filter
            Container(
              padding: .symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.neutralWhite,
                borderRadius: .circular(12),
              ),
              child: Row(
                children: [
                  Obx(
                    () => Checkbox(
                      value: controller.selectAll.value,
                      onChanged: (_) => controller.toggleSelectAll(),
                      activeColor: AppColors.mainColor,
                      shape: RoundedRectangleBorder(borderRadius: .circular(4)),
                    ),
                  ),
                  8.horizontalSpace,
                  Expanded(
                    child: Text(
                      AppLanguage.selectAllStr.tr,
                      style: AppTextStyles.medium14,
                      textAlign: .right,
                    ),
                  ),
                ],
              ),
            ),
            20.verticalSpace,

            // ? Students List
            Expanded(
              child: Obx(() {
                if (controller.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final displayedStudents = controller.filteredStudents;
                if (displayedStudents.isEmpty) {
                  return NoDataWidget(title: AppLanguage.studentsNotFound.tr);
                }

                return Column(
                  children: [
                    ListView.separated(
                      itemCount: displayedStudents.length,
                      separatorBuilder: (_, _) => 12.verticalSpace,
                      itemBuilder: (context, index) {
                        final student = displayedStudents[index];
                        return Obx(
                          () => _StudentBehaviorCard(
                            student: student,
                            isSelected: controller.selectedStudents.contains(
                              student,
                            ),
                            hasBehavior: controller.hasBehavior(student.id),
                            onToggle: () => controller.toggleStudent(student),
                          ),
                        );
                      },
                    ).expanded(),
                    12.verticalSpace,

                    Obx(
                      () => Visibility(
                        visible: controller.selectedStudents.isNotEmpty,
                        child: ColorButton(
                          text: AppLanguage.addStudentBehaviorStr.tr,
                          press: () {
                            BehaviorEvaluationBottomSheet.show();
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    ).safeArea();
  }
}

class _StudentBehaviorCard extends StatelessWidget {
  final StudentEnrollmentModel student;
  final bool isSelected;
  final bool hasBehavior;
  final VoidCallback onToggle;

  const _StudentBehaviorCard({
    required this.student,
    required this.isSelected,
    required this.hasBehavior,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(16),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: .circular(12),
        border: .all(
          color: isSelected
              ? AppColors.mainColor.withValues(alpha: 0.3)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (_) => onToggle(),
            activeColor: AppColors.mainColor,
            shape: RoundedRectangleBorder(borderRadius: .circular(4)),
          ),
          12.horizontalSpace,

          Expanded(
            child: Text(
              student.student.fullName,
              style: AppTextStyles.medium14.copyWith(
                color: AppColors.neutralDarkGrey,
              ),
              textAlign: .right,
            ),
          ),
          12.horizontalSpace,

          if (hasBehavior)
            Container(
              padding: const .all(6.0),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: .circular(12),
              ),
              child: Icon(Icons.check_rounded, size: 28, color: Colors.green),
            ),
        ],
      ),
    );
  }
}
