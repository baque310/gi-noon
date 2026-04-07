import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/localization/language.dart';

class InstallmentCard extends StatelessWidget {
  final bool isPaid;
  final String title, date, amount;

  const InstallmentCard({
    super.key,
    required this.isPaid,
    required this.title,
    required this.date,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    const paidColor = AppColors.green400;
    const unpaidColor = AppColors.yellow500Color;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(title, style: AppTextStyles.bold14),
        Row(
          spacing: getDynamicWidth(6),
          children: [
            SvgPicture.asset(
              isPaid ? AppAssets.icDone : AppAssets.icWarning,
              width: 20,
              height: 20,
            ),
            Text(
              isPaid ? AppLanguage.paid.tr : AppLanguage.unpaid.tr,
              style: AppTextStyles.regular14.copyWith(
                color: isPaid
                    ? paidColor.withValues(alpha: 0.87)
                    : unpaidColor.withValues(alpha: 0.87),
              ),
            ),
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
                  color: isPaid ? paidColor : unpaidColor,
                ),
                margin: .symmetric(horizontal: getDynamicWidth(8)),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isPaid
                        ? paidColor.withValues(alpha: .07)
                        : unpaidColor.withValues(alpha: .07),
                    borderRadius: .circular(12),
                    border: .all(
                      width: .7,
                      color: isPaid
                          ? paidColor.withValues(alpha: 0.4)
                          : unpaidColor.withValues(alpha: 0.4),
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
                        AppAssets.icCalendarV2,
                        width: 20,
                        height: 20,
                      ),
                      Expanded(
                        child: Text(
                          date,
                          style: AppTextStyles.regular16.copyWith(
                            color: AppTextStyles.regular16.color!.withValues(
                              alpha: 0.87,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        amount,
                        style: AppTextStyles.bold16.copyWith(
                          color: AppTextStyles.bold16.color!.withValues(
                            alpha: 0.87,
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
