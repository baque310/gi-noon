import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/constant/app_sizes.dart';

class WisdomTickerBar extends StatelessWidget {
  const WisdomTickerBar({super.key, required this.wisdom});

  final String wisdom;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: getDynamicHeight(36),
      decoration: BoxDecoration(
        color: AppColors.warningColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // ? Icon
          Container(
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.warningColor.withValues(alpha: 0.25),
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(8),
              ),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.auto_awesome,
              color: AppColors.warningColor,
              size: 18,
            ),
          ),

          // ? Scrolling text
          Expanded(
            child: Marquee(
              text: '  $wisdom  ',
              style: AppTextStyles.medium14.copyWith(
                color: AppColors.warningColor,
              ),
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
              blankSpace: 120,
              velocity: 35,
              startPadding: 20,
              accelerationDuration: const Duration(seconds: 1),
              accelerationCurve: Curves.linear,
              decelerationDuration: const Duration(milliseconds: 500),
              decelerationCurve: Curves.easeOut,
            ),
          ),
        ],
      ),
    );
  }
}
