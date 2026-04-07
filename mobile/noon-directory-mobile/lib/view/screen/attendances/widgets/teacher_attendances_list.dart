import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_extensions/s_extensions.dart';

import '../../../../controllers/attendances_controller.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_sizes.dart';
import '../../../../core/constant/app_text_style.dart';
import '../../../../core/enum.dart';
import '../../../../core/function.dart';
import '../../../../core/localization/language.dart';
import '../../../widget/custom_choice_chip_widget.dart';
import '../../../widget/reuseable_container_widget.dart';

class AttendanceList extends StatelessWidget {
  const AttendanceList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AttendancesController>();

    return Obx(() {
      return Container(
        width: .infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: .circular(12),
          border: .all(color: AppColors.blackColor.withValues(alpha: 0.12)),
        ),
        child: Column(
          children: [
            ReuseableContainerWidget(
              text1: AppLanguage.studentNameStr.tr,
              text2: AppLanguage.studentStatus.tr,
            ),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.teacherAttendances.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = controller.teacherAttendances[index];

                return Padding(
                  padding: .symmetric(
                    horizontal: getDynamicHeight(16),
                    vertical: getDynamicHeight(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        item.studentEnrollment.student.fullName,
                        style: AppTextStyles.medium14.copyWith(
                          color: AppTextStyles.medium14.color!.withValues(
                            alpha: 0.87,
                          ),
                        ),
                      ),
                      SizedBox(height: getDynamicHeight(6)),

                      Row(
                        mainAxisAlignment: .center,
                        children: StudentStutus.values.map((status) {
                          return CustomChoiceChip(
                            label: translateStatus(status.name),
                            selected: item.status.toLowerCase() == status.name,
                            onSelected: (isSelected) {
                              if (isSelected) {
                                controller.updateStudentStatusRequest(
                                  item.id,
                                  StringExtensions(status.name).capitalize,
                                );
                              }
                            },
                          ).expanded();
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
