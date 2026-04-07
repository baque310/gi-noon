import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/view/widget/loading_button.dart';
import '../../core/localization/language.dart';

Future<bool?> showAlertDialog<T>({
  required String title,
  T? content,
  String? cancelActionText,
  String defaultActionText = AppLanguage.okStr,
  Color? defaultActionBg,
}) async {
  return showDialog(
    context: Get.context!,
    barrierDismissible: cancelActionText != null,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      elevation: 1,
      insetPadding: const .all(24),
      shape: RoundedRectangleBorder(borderRadius: .circular(24)),
      contentPadding: const .only(left: 16, right: 16, top: 8, bottom: 32),
      actionsPadding: const .only(left: 16, right: 16, bottom: 16),
      title: Text(title, textAlign: .center, style: AppTextStyles.medium16),
      content: content != null
          ? content is String
                ? Text(
                    content as String,
                    textAlign: .center,
                    style: AppTextStyles.regular14.copyWith(
                      color: AppColors.black60Color,
                    ),
                  )
                : content as Widget
          : null,
      actions: [
        cancelActionText == null
            ? Center(
                child: LoadingButton(
                  bgColor: defaultActionBg ?? AppColors.mainColor,
                  height: getDynamicHeight(48),
                  width: AppSizes.screenWidth > 800
                      ? AppSizes.screenWidth / 2
                      : AppSizes.screenWidth * 0.72,
                  text: defaultActionText,
                  onPressed: () => Navigator.pop(context, true),
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(16),
                        ),
                        side: const BorderSide(color: AppColors.gray500Color),
                        fixedSize: Size(
                          getDynamicWidth(72),
                          getDynamicHeight(48),
                        ),
                      ),
                      child: Text(
                        cancelActionText,
                        style: AppTextStyles.semiBold16.copyWith(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: LoadingButton(
                      radius: 16,
                      height: getDynamicHeight(48),
                      bgColor: defaultActionBg ?? AppColors.mainColor,
                      text: defaultActionText,
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ),
                ],
              ),
      ],
    ),
  );
}

Future successDialog({required String title, VoidCallback? press}) {
  return Get.dialog(
    barrierDismissible: true,
    AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 64,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.bold16.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 32),
          LoadingButton(
            text: AppLanguage.done.tr,
            onPressed: press ?? () => Get.back(),
            bgColor: AppColors.mainColor,
            width: double.infinity,
            height: 50,
            radius: 15,
          ),
        ],
      ),
    ),
  );
}

Future<void> showExceptionAlertDialog({
  required String title,
  required dynamic exception,
}) {
  return showAlertDialog(
    title: title,
    content: exception.toString(),
    defaultActionText: AppLanguage.okStr.tr,
  );
}

void showSuccessSnackbar({String? title, String? message}) {
  Get.snackbar(
    title ?? AppLanguage.success.tr,
    message ?? AppLanguage.processSucceededStr.tr,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.white,
    colorText: AppColors.blackColor,
    borderRadius: 15,
    margin: const EdgeInsets.all(20),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
    titleText: Text(
      title ?? AppLanguage.success.tr,
      style: AppTextStyles.bold14.copyWith(color: AppColors.blackColor),
      textAlign: TextAlign.right,
    ),
    messageText: Text(
      message ?? AppLanguage.processSucceededStr.tr,
      style: AppTextStyles.medium12.copyWith(color: AppColors.black60Color),
      textAlign: TextAlign.right,
    ),
    icon: const Icon(Icons.check_circle_outline, color: Colors.green, size: 28),
    shouldIconPulse: true,
    mainButton: null,
    duration: const Duration(seconds: 3),
  );
}
