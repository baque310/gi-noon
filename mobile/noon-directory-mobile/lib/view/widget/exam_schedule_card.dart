import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';

class ExamScheduleCard extends StatelessWidget {
  final String subject;
  final String date;
  final String teacher;
  final VoidCallback onTapArrow;
  final bool done;

  const ExamScheduleCard({
    super.key,
    required this.subject,
    required this.date,
    required this.teacher,
    required this.onTapArrow,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(subject, style: AppTextStyles.bold14),
        Row(
          spacing: getDynamicWidth(6),
          children: [
            SvgPicture.asset(
              AppAssets.icCalendar,
              width: 20,
              height: 20,
              colorFilter: .mode(
                done ? AppColors.bubbleGreenColor : AppColors.neutralMidGrey,
                BlendMode.srcIn,
              ),
            ),
            Text(date, style: AppTextStyles.regular14),
          ],
        ),
        const SizedBox(height: 6),
        IntrinsicHeight(
          child: Row(
            spacing: getDynamicWidth(6),
            children: [
              Container(
                width: 1,
                decoration: BoxDecoration(
                  color: done
                      ? AppColors.bubbleGreenColor
                      : AppColors.neutralMidGrey,
                ),
                margin: .symmetric(horizontal: getDynamicWidth(8)),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: done
                        ? AppColors.bubbleGreenColor.withValues(alpha: .07)
                        : AppColors.neutralMidGrey.withValues(alpha: .07),
                    borderRadius: .circular(12),
                    border: .all(
                      width: .7,
                      color: done
                          ? AppColors.bubbleGreenColor.withValues(alpha: 0.4)
                          : AppColors.neutralMidGrey.withValues(alpha: 0.4),
                    ),
                  ),
                  padding: .symmetric(
                    horizontal: getDynamicHeight(16),
                    vertical: getDynamicHeight(12),
                  ),
                  child: Row(
                    spacing: getDynamicWidth(8),
                    children: [
                      SvgPicture.asset(
                        AppAssets.icProfile,
                        width: 20,
                        height: 20,
                      ),
                      Expanded(
                        child: Text(
                          teacher,
                          style: AppTextStyles.regular16.copyWith(
                            color: AppTextStyles.regular16.color!.withValues(
                              alpha: 0.87,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onTapArrow,
                        child: Container(
                          padding: .all(8),
                          decoration: BoxDecoration(
                            borderRadius: .circular(12),
                            border: .all(
                              width: 0.7,
                              color: AppColors.mainColor,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
