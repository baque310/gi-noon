import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/school_schedule_controller.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/view/widget/days_tab_bar.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:noon/view/widget/schedule_card.dart';
import '../../controllers/global_controller.dart';
import '../../core/localization/language.dart';

class SchoolScheduleScreen extends StatelessWidget {
  const SchoolScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SchoolScheduleController controller = Get.find();

    return Scaffold(
      appBar: CustomAppBar(
        appBarName: AppLanguage.schoolScheduleStr1.tr,
        isLeading: true,
      ),
      body: Padding(
        padding: const .only(left: 16, top: 16, right: 16),
        child: Column(
          children: [
            AnimatedTabBar(
              onItemSelected: (itemSelected, index) async {
                controller.selectedDay(itemSelected);
                await controller.getSchedule();
              },
            ),
            SizedBox(height: getDynamicHeight(6)),
            Obx(() {
              if (controller.loading.value) {
                return Padding(
                  padding: .only(top: Get.height / 4),
                  child: const Loading(),
                );
              }

              if (controller.days.isEmpty) {
                return Padding(
                  padding: .only(top: Get.height / 4),
                  child: NoDataWidget(title: AppLanguage.noInfoAvailable.tr),
                );
              }

              return Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: controller.days.asMap().entries.map((entry) {
                      int index = entry.key;
                      final item = entry.value;
                      return Padding(
                        padding: .symmetric(vertical: getDynamicHeight(6)),
                        child: ScheduleCard(
                          index: index,
                          title:
                              "${item.teacherSubject?.stageSubject?.subject?.name}",
                          teacherName: getSubTitle(
                            item.teacherSubject?.teacher?.fullName,
                            item.section?.name,
                            Get.find<GlobalController>().isTeacher,
                            item.section?.classInfo?.name,
                          ),
                          date:
                              '${DateTime.parse(item.schedule?.timeFrom ?? '').formatDateTime}'
                              ' - ${DateTime.parse(item.schedule?.timeTo ?? '').formatDateTime}'
                              ' ${DateTime.parse(item.schedule?.timeFrom ?? '').formatAmPm}',
                          isTeacher: Get.find<GlobalController>().isTeacher,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String getSubTitle(
    String? tName,
    String? division,
    bool? isTeacher,
    String? section,
  ) {
    if (isTeacher != null && isTeacher) {
      return "${AppLanguage.sectionStr.tr} ${section ?? ' '} - ${AppLanguage.divisionStr.tr}${division ?? ' '}";
    } else {
      return "${AppLanguage.teacherStr.tr}: ${tName ?? ' '}";
    }
  }
}
