import 'package:flutter/material.dart';
import '../../core/constant/app_colors.dart';
import '../../core/constant/app_text_style.dart';

class SimpleButton extends StatelessWidget {
  const SimpleButton({
    super.key,
    this.label,
    this.icon,
    this.onPressed,
    this.color,
    this.isOutlined = false,
    this.height = 48,
    this.width,
  });

  final String? label;
  final Widget? icon;
  final Color? color;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: getColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(16),
        side: BorderSide(
          color: isOutlined ? AppColors.mainColor : Colors.transparent,
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        highlightColor: isOutlined
            ? AppColors.mainColor.withValues(alpha: .2)
            : Colors.white.withValues(alpha: 0.2),
        splashColor: isOutlined
            ? AppColors.mainColor.withValues(alpha: .2)
            : Colors.white.withValues(alpha: 0.2),
        child: SizedBox(
          height: height,
          width: width,
          child: Padding(
            padding: const .symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: .center,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: AppTextStyles.bold14.copyWith(
                      color: isOutlined
                          ? AppColors.mainColor
                          : Colors.white.withValues(alpha: .87),
                    ),
                  ),
                if (label != null && icon != null) const SizedBox(width: 8),
                if (icon != null) icon!,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color? get getColor {
    if (color != null) {
      return color;
    } else if (isOutlined) {
      return Colors.transparent;
    } else {
      return AppColors.mainColor;
    }
  }
}
