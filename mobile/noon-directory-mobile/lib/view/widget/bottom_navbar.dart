import 'package:flutter/material.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/view/widget/color_button.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({
    super.key,
    this.onTap,
    required this.text,
    this.icon,
    this.loading = false,
    this.outlinedPress,
    this.isShowOutlindeButton = false,
    this.outlinedText,
    this.height,
    this.enable = true,
    this.backgroundColor,
  });

  final VoidCallback? onTap;
  final VoidCallback? outlinedPress;
  final String text;
  final String? icon;
  final bool loading;
  final bool enable;
  final bool isShowOutlindeButton;
  final String? outlinedText;
  final double? height;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      color: backgroundColor ?? Colors.white,
      height: height ?? getDynamicHeight(90),
      alignment: .center,
      child: Column(
        mainAxisAlignment: .center,
        children: [
          ColorButton(
            height: getDynamicWidth(50),
            icon: icon,
            text: text,
            press: onTap,
            enable: enable,
            loading: loading,
          ),
          if (isShowOutlindeButton) SizedBox(height: getDynamicHeight(8)),
          if (isShowOutlindeButton)
            OutlinedButton(
              onPressed: outlinedPress,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: .circular(14)),
                side: const BorderSide(color: AppColors.mainColor),
                fixedSize: Size(AppSizes.screenWidth, getDynamicHeight(48)),
              ),
              child: Text(
                outlinedText ?? '',
                style: AppTextStyles.bold14.copyWith(
                  color: AppColors.mainColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
