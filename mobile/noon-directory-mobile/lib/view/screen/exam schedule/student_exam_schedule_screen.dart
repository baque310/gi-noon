import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/exam_schedule_controller.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/view/widget/alert_dialogs.dart';
import 'package:noon/view/widget/loading.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_sizes.dart';
import '../../../core/constant/app_text_style.dart';
import '../../../core/localization/language.dart';
import '../../../models/exam_data_model.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/dropdown/generic_dropdown_widget.dart';
import '../../widget/no_data_widget.dart';

class StudentExamScheduleScreen extends StatelessWidget {
  StudentExamScheduleScreen({super.key});

  final controller = Get.find<ExamScheduleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarName: AppLanguage.examScheduleStr1.tr,
        isLeading: true,
      ),
      body: Obx(() {
        final selectedKey = controller.studentExamValue.value;
        List<ExamDataModel> selectedData =
            controller.studentExamResults.value.sections[selectedKey]
                ?.toList() ??
            [];

        if (controller.loading.value) {
          return const Center(child: Loading());
        } else if (controller.studentExams.isEmpty) {
          return NoDataWidget(title: AppLanguage.thereIsNoStudentExams.tr);
        } else {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(16)),
            child: Column(
              children: [
                SizedBox(height: getDynamicHeight(16)),
                CustomGenericDropDown<String>(
                  content: controller.studentExams.toList(),
                  displayText: (item) => item,
                  onChanged: (v) {
                    controller.studentExamValue(v);
                  },
                  hint: AppLanguage.examStr.tr,
                  value: selectedKey,
                ),
                if (selectedData.isNotEmpty)
                  SizedBox(height: getDynamicHeight(16)),
                if (selectedData.isNotEmpty)
                  ExamScheduleTabelWidget(data: selectedData),
                const SizedBox(height: 16),
              ],
            ),
          );
        }
      }),
    );
  }
}

class ExamScheduleTabelWidget extends StatelessWidget {
  const ExamScheduleTabelWidget({super.key, required this.data});

  final List<ExamDataModel> data;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> reversedDaysMap = {
      'SUNDAY': AppLanguage.sunday.tr,
      'MONDAY': AppLanguage.monday.tr,
      'TUESDAY': AppLanguage.tuesday.tr,
      'WEDNESDAY': AppLanguage.wednesday.tr,
      'THURSDAY': AppLanguage.thursday.tr,
      'FRIDAY': AppLanguage.friday.tr,
      'SATURDAY': AppLanguage.saturday.tr,
    };

    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: getDynamicHeight(16)),
            height: getDynamicHeight(42),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLanguage.dayStr.tr,
                  style: AppTextStyles.textMedium12.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  AppLanguage.subjectStr.tr,
                  style: AppTextStyles.textMedium12.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  AppLanguage.dateStr.tr,
                  style: AppTextStyles.textMedium12.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  AppLanguage.detailsStr.tr,
                  style: AppTextStyles.textMedium12.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            separatorBuilder: (context, index) =>
                data[index].examSections.isNotEmpty
                ? const Divider()
                : const SizedBox.shrink(),
            itemBuilder: (context, index) {
              final item = data[index];

              if (item.examSections.isNotEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getDynamicHeight(16),
                    vertical: getDynamicHeight(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        reversedDaysMap[item
                                .examSections
                                .first
                                .examDate
                                ?.getDayFromDate
                                .toUpperCase()] ??
                            '',
                        style: AppTextStyles.textMedium10.copyWith(
                          color: AppTextStyles.textMedium10.color!.withValues(
                            alpha: 0.87,
                          ),
                        ),
                      ),
                      Text(
                        item.stageSubject.name.toString().length > 18
                            ? '${item.stageSubject.name.toString().substring(0, 18)}...'
                            : item.stageSubject.name.toString(),
                        style: AppTextStyles.textMedium10.copyWith(
                          color: AppTextStyles.textMedium10.color!.withValues(
                            alpha: 0.87,
                          ),
                        ),
                      ),
                      Text(
                        item
                            .examSections
                            .first
                            .examDate!
                            .formatDateToYearMonthDay,
                        style: AppTextStyles.textMedium10.copyWith(
                          color: AppTextStyles.textMedium10.color!.withValues(
                            alpha: 0.87,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showAlertDialog(
                            title: AppLanguage.examDetailsStr.tr,
                            content: item.content,
                            defaultActionBg: Colors.transparent,
                          );
                        },
                        child: SvgPicture.asset(
                          AppAssets.icVisibility,
                          colorFilter: const ColorFilter.mode(
                            AppColors.mainColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
