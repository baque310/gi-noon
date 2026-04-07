import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/attendances_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/view/screen/attendances/widgets/chip_information_widget.dart';
import 'package:noon/view/screen/attendances/widgets/datepicker_widget.dart';
import 'package:noon/view/widget/attendance_card.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:noon/view/widget/no_data_widget.dart';

import '../../../core/enum.dart';
import '../../../core/localization/language.dart';
import '../../widget/custom_appbar.dart';

class StudentAttendancesScreen extends StatelessWidget {
  const StudentAttendancesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AttendancesController>();

    return Scaffold(
      appBar: CustomAppBar(
        appBarName: AppLanguage.attendancesStr.tr,
        isLeading: true,
        press: () => Get.back(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const .symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              Obx(
                () => DatepickerWidget(
                  onTap: () => controller.pickDate(),
                  text: controller.selectedDate.value,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                return controller.attendances.isNotEmpty
                    ? Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          ChipInformation(
                            title: AppLanguage.attendancesStr.tr,
                            color: AppColors.bubbleGreenColor,
                            number: controller.presentCount.value ?? 0,
                          ),
                          const SizedBox(width: 10),
                          ChipInformation(
                            title: AppLanguage.absenceStr.tr,
                            color: AppColors.errorRedColor,
                            number: controller.absentCount.value ?? 0,
                          ),
                          const SizedBox(width: 10),
                          ChipInformation(
                            title: AppLanguage.vacations.tr,
                            color: AppColors.secondryOringe,
                            number: controller.vacationCount.value ?? 0,
                          ),
                        ],
                      )
                    : const SizedBox();
              }),
              Obx(() {
                if (controller.loading.value) {
                  return Padding(
                    padding: .only(top: Get.height / 4),
                    child: const Loading(),
                  );
                }
                if (controller.attendances.isEmpty &&
                    controller.selectedDate.value != 'تحديد تاريخ') {
                  return Padding(
                    padding: .only(top: Get.height / 4),
                    child: NoDataWidget(title: AppLanguage.noInfoAvailable.tr),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.attendances.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final attendance = controller.attendances[index];

                    return AttendanceCard(
                      index: index,
                      attendanceStatus: attendance.status.toLowerCase().tr,
                      color: _getCardColor(attendance.status),
                      date: attendance.date.getDayFromDate,
                      subject:
                          attendance
                              .sectionSchedule
                              .teacherSubject
                              .stageSubject
                              ?.subject
                              ?.name ??
                          '',
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCardColor(String status) {
    final studentStatus = StudentStutus.values.firstWhere(
      (e) => e.toString().split('.').last == status.toLowerCase(),
    );
    switch (studentStatus) {
      case .present:
        return AppColors.bubbleGreenColor;
      case .absent:
        return AppColors.errorRedColor;
      case .vacation:
        return AppColors.yellow500Color;
    }
  }
}
