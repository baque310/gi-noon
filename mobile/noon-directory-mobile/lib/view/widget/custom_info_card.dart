import 'package:flutter/material.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';

class CustomInformationCard extends StatelessWidget {
  const CustomInformationCard({
    super.key,
    required this.constTitle,
    required this.title,
    required this.radius,
    this.onTap,
  });

  final String constTitle;
  final String title;
  final double radius;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const .symmetric(horizontal: 16),
        margin: const .only(bottom: 8),
        height: getDynamicHeight(50),
        width: .infinity,
        decoration: BoxDecoration(
          borderRadius: .circular(radius),
          border: .all(color: AppColors.blackColor.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            Text(
              constTitle,
              style: AppTextStyles.medium16.copyWith(
                color: AppTextStyles.medium16.color!.withValues(alpha: 0.60),
              ),
            ),

            Expanded(
              child: Text(
                title,
                style: AppTextStyles.medium16.copyWith(
                  color: AppTextStyles.medium16.color!.withValues(alpha: 0.87),
                ),
                overflow: .ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
