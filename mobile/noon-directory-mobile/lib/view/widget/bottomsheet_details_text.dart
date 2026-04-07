import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:s_extensions/s_extensions.dart';

class BottomsheetDetailsText extends StatelessWidget {
  const BottomsheetDetailsText({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    this.iconColor,
  });

  final String icon;
  final String title;
  final String? value;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(getDynamicWidth(12)),
      decoration: BoxDecoration(
        borderRadius: .circular(12),
        border: .all(
          color: AppColors.neutralDarkGrey.withValues(alpha: 0.4),
          width: .7,
        ),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          SvgPicture.asset(
            icon,
            colorFilter: iconColor != null
                ? ColorFilter.mode(iconColor!, .srcIn)
                : null,
          ),
          SizedBox(width: getDynamicWidth(12)),

          Text(
            title,
            style: AppTextStyles.medium16.copyWith(
              color: AppColors.neutralDarkGrey,
            ),
          ),
          const Spacer(),

          if (value.isNotNull)
            Text(
              value!,
              style: AppTextStyles.regular16.copyWith(
                color: AppColors.neutralDarkGrey,
              ),
            ),
        ],
      ),
    );
  }
}
