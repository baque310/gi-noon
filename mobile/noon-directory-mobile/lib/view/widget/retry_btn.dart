import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';

import '../../core/localization/language.dart';

class RetryBtn extends StatelessWidget {
  const RetryBtn({super.key, required this.press});

  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: press,
      icon: const Icon(
        Icons.refresh_rounded,
        size: 20,
        color: AppColors.mainColor,
      ),
      label: Text(
        AppLanguage.retryWithErrorStr.tr,
        style: AppTextStyles.semiBold14.copyWith(color: AppColors.black87Color),
      ),
    );
  }
}
