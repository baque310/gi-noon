import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';

class AttendanceCard extends StatelessWidget {
  final int index;
  final String attendanceStatus;
  final Color color;
  final String? date, subject;
  const AttendanceCard({
    super.key,
    this.index = 0,
    required this.attendanceStatus,
    required this.color,
    this.subject,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: index == 0 ? const .only(top: 14) : .zero,
      padding: const .symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: .circular(14),
        color: AppColors.neutralWhite,
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Container(
            padding: const .symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: .circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(color: color, shape: .circle),
                ),
                const SizedBox(width: 8),

                Text(attendanceStatus, style: AppTextStyles.medium16),
              ],
            ),
          ),
          const SizedBox(width: 12),

          if (date != null)
            Text(date!.toLowerCase().tr, style: AppTextStyles.regular14),
          const SizedBox(width: 8),

          if (subject != null) Text(subject!, style: AppTextStyles.medium16),
        ],
      ),
    );
  }
}
