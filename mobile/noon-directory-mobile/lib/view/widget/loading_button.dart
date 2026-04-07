import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.onPressed,
    this.height = 48,
    required this.bgColor,
    this.radius = 14,
    required this.text,
    this.textStyle,
    this.isLoading = false,
    this.width,
    this.icon,
  });
  final void Function()? onPressed;
  final double height;
  final double radius;
  final Color? bgColor;
  final String text;
  final String? icon;
  final TextStyle? textStyle;
  final bool isLoading;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: .circular(radius)),
        ),
        minimumSize: WidgetStatePropertyAll(Size(width ?? .infinity, height)),
        maximumSize: WidgetStatePropertyAll(Size(width ?? .infinity, height)),
        backgroundColor: WidgetStatePropertyAll(bgColor ?? AppColors.mainColor),
      ),
      onPressed: onPressed,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.white),
            )
          : Row(
              mainAxisAlignment: .center,
              children: [
                if (icon != null) const SizedBox(width: 8),
                if (icon != null)
                  SvgPicture.asset(icon!, width: 29, height: 29),
                Text(
                  text,
                  style:
                      textStyle ??
                      AppTextStyles.medium14.copyWith(color: Colors.white),
                ),
              ],
            ),
    );
  }
}
