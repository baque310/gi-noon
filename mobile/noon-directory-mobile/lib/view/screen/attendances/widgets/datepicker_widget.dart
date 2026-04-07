import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constant/app_assets.dart';
import '../../../../core/constant/app_text_style.dart';

class DatepickerWidget extends StatelessWidget {
  const DatepickerWidget({
    super.key,
    this.isShowSearchIcon = true,
    this.iconColor,
    this.textStyle,
    this.onTap,
    required this.text,
  });

  final bool isShowSearchIcon;
  final Color? iconColor;
  final TextStyle? textStyle;
  final Function()? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const .symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: .all(
            color: const Color(0xFF1A202C).withValues(alpha: 0.12),
            width: 0.5,
          ),
          borderRadius: .circular(12),
        ),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Row(
              children: [
                if (isShowSearchIcon) SvgPicture.asset(AppAssets.icSearch),
                if (isShowSearchIcon) const SizedBox(width: 10),
                Text(
                  text,
                  style:
                      textStyle ??
                      AppTextStyles.medium14.copyWith(
                        color: AppTextStyles.medium14.color!.withValues(
                          alpha: 0.37,
                        ),
                      ),
                ),
              ],
            ),
            Icon(
              Icons.keyboard_arrow_down_outlined,
              color: iconColor ?? const Color(0xFF1C274C),
            ),
          ],
        ),
      ),
    );
  }
}
