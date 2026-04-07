import 'package:flutter/material.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';

class ProfileActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function()? onTap;
  final Color? color;
  final bool isHorizontal;
  final bool flipIcon;

  const ProfileActionButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
    this.isHorizontal = false,
    this.flipIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    var iconWidget = Container(
      padding: const .all(8),
      decoration: BoxDecoration(
        color:
            color?.withValues(alpha: 0.1) ??
            AppColors.mainColor.withValues(alpha: 0.1),
        shape: .circle,
      ),
      child: Icon(icon, color: color ?? AppColors.mainColor, size: 18),
    );
    var titleWidget = Text(
      title,
      style: AppTextStyles.semiBold14.copyWith(
        color: color ?? AppColors.mainColor,
      ),
    );

    return InkWell(
      borderRadius: .circular(getDynamicHeight(14)),
      customBorder: StadiumBorder(),
      onTap: onTap,
      child: isHorizontal
          ? Container(
              decoration: BoxDecoration(
                borderRadius: .circular(getDynamicHeight(20)),
                border: .all(
                  color:
                      color?.withValues(alpha: 0.3) ??
                      AppColors.mainColor.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                mainAxisSize: .min,
                children: flipIcon
                    ? [
                        const SizedBox(width: 8),
                        titleWidget,
                        const SizedBox(width: 8),
                        iconWidget,
                      ]
                    : [
                        iconWidget,
                        const SizedBox(width: 8),
                        titleWidget,
                        const SizedBox(width: 8),
                      ],
              ),
            )
          : Column(
              mainAxisSize: .min,
              children: flipIcon
                  ? [
                      const SizedBox(height: 6),
                      titleWidget,
                      const SizedBox(height: 6),
                      iconWidget,
                    ]
                  : [
                      iconWidget,
                      const SizedBox(height: 6),
                      titleWidget,
                      const SizedBox(height: 6),
                    ],
            ),
    );
  }
}
