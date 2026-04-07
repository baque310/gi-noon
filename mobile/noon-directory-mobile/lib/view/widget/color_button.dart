import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';

class ColorButton extends StatelessWidget {
  const ColorButton({
    super.key,
    required this.text,
    this.bg = AppColors.mainColor,
    this.textColor,
    required this.press,
    this.width,
    this.height,
    this.radius,
    this.icon,
    this.loading = false,
    this.enable = true,
    this.textSize = 14,
    this.textStyle,
  });

  final String text;
  final Color bg;
  final Color? textColor;
  final VoidCallback? press;
  final double? width;
  final double? height;
  final double? radius;
  final String? icon;
  final bool loading;
  final bool enable;
  final double textSize;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: loading || !enable,
      child: SizedBox(
        height: height ?? 56,
        width: width ?? .infinity,
        child: (loading || icon != null)
            ? ElevatedButton.icon(
                onPressed: press,
                icon: _handleBtnIcon,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: AppColors.mainColor.withValues(
                    alpha: 0.5,
                  ),
                  padding: const .symmetric(horizontal: 12),
                  backgroundColor: enable
                      ? bg
                      : AppColors.mainColor.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: .circular(radius ?? getDynamicHeight(14)),
                  ),
                  elevation: 0.5,
                  shadowColor: AppColors.main30Color,
                ),
                label: Text(
                  text,
                  style:
                      textStyle ??
                      AppTextStyles.semiBold16.copyWith(
                        color: textColor ?? Colors.white,
                        fontSize: textSize,
                      ),
                ),
              )
            : ElevatedButton(
                onPressed: press,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: AppColors.mainColor.withValues(
                    alpha: 0.5,
                  ),
                  padding: const .symmetric(horizontal: 12),
                  backgroundColor: enable
                      ? bg
                      : AppColors.mainColor.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: .circular(radius ?? getDynamicHeight(14)),
                  ),
                  elevation: 0.5,
                  shadowColor: AppColors.main30Color,
                ),
                child: Text(
                  text,
                  style:
                      textStyle ??
                      AppTextStyles.semiBold16.copyWith(
                        color: textColor ?? Colors.white,
                        fontSize: textSize,
                      ),
                ),
              ),
      ),
    );
  }

  Widget get _handleBtnIcon {
    if (loading) {
      return SizedBox(
        width: getDynamicWidth(16),
        height: getDynamicHeight(16),
        child: const CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3,
        ),
      );
    }

    if (icon != null) {
      return SvgPicture.asset(
        icon!,
        colorFilter: const .mode(Colors.white, BlendMode.srcIn),
        width: getDynamicWidth(24),
        height: getDynamicHeight(24),
      );
    }

    return const SizedBox();
  }
}
