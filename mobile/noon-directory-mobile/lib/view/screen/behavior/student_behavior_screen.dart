import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/behavior_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/models/behaviors/behavior.dart';
import 'package:noon/view/widget/circle_progressbar.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:s_extensions/s_extensions.dart';

class StudentBehaviorScreen extends StatefulWidget {
  const StudentBehaviorScreen({super.key});

  @override
  State<StudentBehaviorScreen> createState() => _StudentBehaviorScreenState();
}

class _StudentBehaviorScreenState extends State<StudentBehaviorScreen> {
  final controller = Get.put(BehaviorController());
  final RxInt selectedDateIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    ever(controller.behaviors, (_) {
      selectedDateIndex.value = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          appBarName: AppLanguage.behaviorStr.tr,
          isLeading: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  12.verticalSpace,
                  Text("اختر المادة", style: AppTextStyles.bold16),
                  12.verticalSpace,
                  SizedBox(
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.studentSubjects.length,
                      separatorBuilder: (context, index) => 12.horizontalSpace,
                      itemBuilder: (context, index) {
                        final subject = controller.studentSubjects[index];
                        final isSelected =
                            controller.selectedStudentSubject.value?.id ==
                            subject.id;
                        return GestureDetector(
                          onTap: () {
                            controller.toggleSelectedSubject(subject);
                            selectedDateIndex.value = 0;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.mainColor
                                  : AppColors.mainColor.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(24),
                              border: isSelected
                                  ? null
                                  : Border.all(
                                      color: AppColors.mainColor.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              subject.stageSubject?.subject?.name ?? '',
                              style: AppTextStyles.bold14.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.mainColor,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (controller.behaviors.isNotEmpty) ...[
                    24.verticalSpace,
                    Text("اختر فترة التقييم", style: AppTextStyles.bold16),
                    12.verticalSpace,
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.behaviors.length,
                        separatorBuilder: (context, index) =>
                            10.horizontalSpace,
                        itemBuilder: (context, index) {
                          final behavior = controller.behaviors[index];
                          final isSelected = selectedDateIndex.value == index;
                          return GestureDetector(
                            onTap: () => selectedDateIndex.value = index,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.mainColor
                                    : AppColors.mainColor.withValues(
                                        alpha: 0.1,
                                      ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "${behavior.fromDate.toString().substring(5, 10)} / ${behavior.toDate.toString().substring(5, 10)}",
                                style: AppTextStyles.bold12.copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.mainColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  24.verticalSpace,
                  if (controller.loading.value)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Loading(),
                      ),
                    )
                  else if (controller.behaviors.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Center(
                        child: NoDataWidget(
                          title: controller.selectedStudentSubject.value == null
                              ? AppLanguage.selectSubjectStr.tr
                              : "لا توجد تقييمات لهذه المادة",
                        ),
                      ),
                    )
                  else ...[
                    () {
                      final index =
                          selectedDateIndex.value >= controller.behaviors.length
                          ? 0
                          : selectedDateIndex.value;
                      final currentBehavior = controller.behaviors[index];
                      final score = _calculateSingleBehaviorScore(
                        currentBehavior,
                      );
                      final hasEvaluation = score > 0.0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.mainColor.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "فترة التقييم الحالية",
                                        style: AppTextStyles.bold14.copyWith(
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                        ),
                                      ),
                                      4.verticalSpace,
                                      Text(
                                        "${currentBehavior.fromDate.toString().substring(0, 10)}  ⇠  ${currentBehavior.toDate.toString().substring(0, 10)}",
                                        style: AppTextStyles.bold16.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                      12.verticalSpace,
                                      Text(
                                        score.toStringAsFixed(1),
                                        style: AppTextStyles.bold36.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                      12.verticalSpace,
                                      if (hasEvaluation)
                                        Text(
                                          '${AppLanguage.yourRatingIsStr.tr} ${_getBehaviorRatingText(score)}',
                                          style: AppTextStyles.semiBold14
                                              .copyWith(
                                                color: Colors.white.withValues(
                                                  alpha: 0.8,
                                                ),
                                              ),
                                        )
                                      else
                                        Text(
                                          "لا توجد تقييمات لهذه المادة بعد",
                                          style: AppTextStyles.semiBold14
                                              .copyWith(
                                                color: Colors.white.withValues(
                                                  alpha: 0.8,
                                                ),
                                              ),
                                        ),
                                    ],
                                  ),
                                ),
                                CircleProgressbar(
                                  progress: score,
                                  maxProgress: 5,
                                  color: Colors.white,
                                  height: 65,
                                  width: 65,
                                ),
                              ],
                            ),
                          ),
                          24.verticalSpace,
                          if (hasEvaluation)
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      WidgetExtensions(
                                            Icon(
                                              Icons.menu_book_rounded,
                                              color: AppColors.mainColor,
                                              size: 30,
                                            ),
                                          )
                                          .paddingAll(8)
                                          .decoration(
                                            color: AppColors.mainColor
                                                .withValues(alpha: .1),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                      16.horizontalSpace,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              currentBehavior.subjectName,
                                              style: AppTextStyles.bold16,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            4.verticalSpace,
                                            Text(
                                              "تم التقييم في: ${currentBehavior.createdAt.toString().substring(0, 10)}",
                                              style: AppTextStyles.regular14
                                                  .copyWith(
                                                    color: AppTextStyles
                                                        .bold14
                                                        .color!
                                                        .withValues(alpha: .7),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  16.verticalSpace,
                                  GridView.builder(
                                    itemCount:
                                        currentBehavior.evaluationItems.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 12,
                                          childAspectRatio: 2 / 1,
                                        ),
                                    itemBuilder: (context, index) {
                                      final evaluation = currentBehavior
                                          .evaluationItems[index];
                                      return Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.mainColor.withValues(
                                            alpha: .05,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  evaluation
                                                          .behaviorSection
                                                          ?.name ??
                                                      '',
                                                  style: AppTextStyles.bold14
                                                      .copyWith(
                                                        color: AppTextStyles
                                                            .bold14
                                                            .color!
                                                            .withValues(
                                                              alpha: .7,
                                                            ),
                                                      ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ).expanded(),
                                                4.horizontalSpace,
                                                Text(
                                                  _getBehaviorSectionEmoji(
                                                    evaluation
                                                            .behaviorType
                                                            ?.order ??
                                                        0,
                                                  ),
                                                  style: AppTextStyles.bold16,
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            List.generate(
                                              5,
                                              (i) => Icon(
                                                i <
                                                        (evaluation
                                                                .behaviorType
                                                                ?.order ??
                                                            0)
                                                    ? Icons.star_rate_rounded
                                                    : Icons
                                                          .star_outline_rounded,
                                                color: Colors.amber,
                                                size: 18,
                                              ),
                                            ).toRow(spacing: 0),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  if (currentBehavior.notes.isNotEmpty) ...[
                                    16.verticalSpace,
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.mainColor.withValues(
                                          alpha: 0.05,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: AppColors.mainColor.withValues(
                                            alpha: 0.1,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.notes_rounded,
                                                color: AppColors.mainColor,
                                                size: 20,
                                              ),
                                              8.horizontalSpace,
                                              Text(
                                                "ملاحظات المعلم",
                                                style: AppTextStyles.bold14
                                                    .copyWith(
                                                      color:
                                                          AppColors.mainColor,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          8.verticalSpace,
                                          Text(
                                            currentBehavior.notes.trim(),
                                            style: AppTextStyles.regular14
                                                .copyWith(height: 1.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                        ],
                      );
                    }(),
                  ],
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  String _getBehaviorSectionEmoji(int order) {
    switch (order) {
      case 1:
        return "😞";
      case 2:
        return "☹️";
      case 3:
        return "😐";
      case 4:
        return "😊";
      default:
        return "🤩";
    }
  }

  String _getBehaviorRatingText(double rating) {
    if (rating > 3.5) {
      return AppLanguage.behaviorRatingExcellentStr.tr;
    } else if (rating > 2.5) {
      return AppLanguage.behaviorRatingVeryGoodStr.tr;
    } else if (rating > 1.5) {
      return AppLanguage.behaviorRatingGoodStr.tr;
    } else {
      return AppLanguage.behaviorRatingWeakStr.tr;
    }
  }

  double _calculateSingleBehaviorScore(BehaviorModel behavior) {
    double totalSum = 0;
    int totalCount = 0;

    for (var item in behavior.evaluationItems) {
      if (item.behaviorType != null) {
        totalSum += item.behaviorType!.order;
        totalCount++;
      }
    }

    if (totalCount == 0) return 0.0;
    return totalSum / totalCount;
  }
}
