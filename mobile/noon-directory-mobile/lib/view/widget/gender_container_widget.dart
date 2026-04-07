import 'package:flutter/material.dart';
import 'package:noon/view/widget/custom_inkwell.dart';

import '../../core/constant/app_colors.dart';
import '../../core/constant/app_text_style.dart';

class GenderContainer extends StatelessWidget {
  final String gender;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderContainer({
    super.key,
    required this.gender,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkwell(
      onTap: onTap,
      child: Container(
        padding: const .symmetric(horizontal: 16),
        width: .infinity,
        alignment: .center,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: .circular(16),
          color: isSelected ? AppColors.mainColor : null,
          border: .all(color: AppColors.blackColor.withValues(alpha: 0.12)),
        ),
        child: Row(
          mainAxisAlignment: .center,
          children: [
            Text(
              gender,
              style: AppTextStyles.regular14.copyWith(
                color: isSelected ? Colors.white : AppColors.gray600Color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
