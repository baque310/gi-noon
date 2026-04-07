import 'package:flutter/material.dart';

import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';

class ChipInformation extends StatelessWidget {
  const ChipInformation({
    super.key,
    required this.title,
    required this.color,
    required this.number,
  });

  final String title;
  final Color color;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const .symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: .all(
            color: AppColors.blackColor.withValues(alpha: 0.12),
            width: 0.5,
          ),
          borderRadius: .circular(12),
        ),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(title, style: AppTextStyles.medium12),
            Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                color: color,
                borderRadius: .circular(9),
              ),
              child: Center(
                child: Text(
                  number.toString(),
                  style: AppTextStyles.medium10.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
