import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/localization/language.dart';

class ScheduleCard extends StatelessWidget {
  final String title;
  final String date;
  final String teacherName;
  final int index;
  final bool isTeacher;
  final bool showScheduleIndex;
  const ScheduleCard({
    super.key,
    required this.title,
    required this.date,
    required this.teacherName,
    required this.index,
    required this.isTeacher,
    this.showScheduleIndex = true,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = AppTextStyles.bold16;
    final dateStyle = AppTextStyles.medium14;

    final lessonColors = [
      AppColors.primary,
      AppColors.green300,
      AppColors.yellow500Color,
      AppColors.secondryOringe,
      AppColors.redColor,
      AppColors.mainColor,
      AppColors.gray600Color,
      AppColors.blackColor,
    ];

    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: MainAxisSize.min,
      spacing: getDynamicHeight(6),
      children: [
        if (showScheduleIndex)
          Text('${AppLanguage.lesson.tr} ${index + 1}', style: titleStyle),
        Row(
          spacing: getDynamicWidth(6),
          children: [
            SvgPicture.asset(
              AppAssets.icClock,
              width: 20,
              height: 20,
              colorFilter: .mode(lessonColors[index], BlendMode.srcIn),
            ),
            Text(
              date,
              style: dateStyle.copyWith(
                color: dateStyle.color!.withValues(alpha: 0.87),
              ),
            ),
          ],
        ),
        IntrinsicHeight(
          child: Row(
            spacing: getDynamicWidth(6),
            children: [
              Container(
                width: 1,
                decoration: BoxDecoration(color: lessonColors[index]),
                margin: .symmetric(horizontal: getDynamicWidth(8)),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.neutralBackground,
                    borderRadius: .circular(12),
                  ),
                  padding: .symmetric(
                    horizontal: getDynamicHeight(16),
                    vertical: getDynamicHeight(20),
                  ),
                  child: Row(
                    spacing: getDynamicWidth(8),
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: titleStyle.copyWith(
                            color: titleStyle.color!.withValues(alpha: 0.87),
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        isTeacher ? AppAssets.icGroup : AppAssets.icProfile,
                        width: 20,
                        height: 20,
                      ),
                      Text(
                        teacherName,
                        style: dateStyle.copyWith(
                          color: dateStyle.color!.withValues(alpha: 0.87),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
