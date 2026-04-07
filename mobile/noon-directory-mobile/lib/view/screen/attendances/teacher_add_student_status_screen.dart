import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/core/enum.dart';

import '../../../controllers/attendances_controller.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_sizes.dart';
import '../../../core/constant/app_text_style.dart';
import '../../../core/function.dart';
import '../../../core/localization/language.dart';
import '../../widget/bottom_navbar.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_choice_chip_widget.dart';
import '../../widget/loading.dart';
import '../../widget/reuseable_container_widget.dart';

class TeacherAddStudentStatusScreen extends StatelessWidget {
  const TeacherAddStudentStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AttendancesController controller = Get.find();

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          appBarName: AppLanguage.attendancesStr.tr,
          isLeading: true,
          press: () => Get.back(),
        ),
        body: SizedBox(
          width: .infinity,
          child: SingleChildScrollView(
            child: Obx(() {
              if (controller.loading.value) {
                return SizedBox(height: Get.height / 2, child: const Loading());
              }
              return Padding(
                padding: const .symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      width: .infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: .circular(12),
                        border: .all(
                          color: AppColors.blackColor.withValues(alpha: 0.12),
                        ),
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
                            itemCount: controller.students.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) {
                              final student = controller.students[index];
                              return Padding(
                                padding: .symmetric(
                                  horizontal: getDynamicHeight(16),
                                  vertical: getDynamicHeight(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: .spaceBetween,
                                  children: [
                                    Text(
                                      student.student.fullName,
                                      style: AppTextStyles.medium10.copyWith(
                                        color: AppTextStyles.medium10.color!
                                            .withValues(alpha: 0.87),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        CustomChoiceChip(
                                          label: translateStatus(
                                            StudentStutus.present.name,
                                          ),
                                          onSelected: (v) {
                                            controller.updateStudentStatus(
                                              student.id,
                                              StudentStutus.present,
                                            );
                                          },
                                          selected:
                                              student.status ==
                                              StudentStutus.present,
                                        ),
                                        CustomChoiceChip(
                                          label: translateStatus(
                                            StudentStutus.absent.name,
                                          ),
                                          onSelected: (v) {
                                            controller.updateStudentStatus(
                                              student.id,
                                              .absent,
                                            );
                                          },
                                          selected: student.status == .absent,
                                        ),
                                        CustomChoiceChip(
                                          label: translateStatus(
                                            StudentStutus.vacation.name,
                                          ),
                                          onSelected: (v) {
                                            controller.updateStudentStatus(
                                              student.id,
                                              .vacation,
                                            );
                                          },
                                          selected: student.status == .vacation,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        bottomNavigationBar: Obx(() {
          return IgnorePointer(
            ignoring: controller.loading.value,
            child: BottomNavbar(
              loading: controller.loading.value,
              enable: controller.attendanceRecords.isNotEmpty,
              text: AppLanguage.addStr.tr,
              onTap: () {
                controller.addStudentStatus();
              },
            ),
          );
        }),
      ),
    );
  }
}
