/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_strings.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/view/widget/images/custom_network_image.dart';

import '../../core/localization/language.dart';
import 'color_button.dart';

Future<void> advertisementDetailDialog({
  required String title,
  required String description,
  required String? imageUrl,
}) {
  return showDialog(
    context: Get.context!,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      elevation: 1,
      insetPadding: const .all(16),
      shape: RoundedRectangleBorder(
        borderRadius: .circular(20),
        side: const BorderSide(color: Colors.black, width: 0.2),
      ),
      contentPadding: const .only(
        right: 12,
        left: 12,
        top: 16,
        bottom: 40,
      ),
      actionsPadding: const .only(bottom: 16, left: 16, right: 16),
      titlePadding: .zero,
      title: CustomNetworkImage(
        imageUrl: imageUrl,
        height: getDynamicHeight(200),
        fit: BoxFit.fill,
        radius: const .only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      content: Column(
        crossAxisAlignment: .start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: AppTextStyles.semiBold14,
            maxLines: 2,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: AppTextStyles.regular12.copyWith(
              color: AppColors.black60Color,
            ),
            overflow: .ellipsis,
            maxLines: 3,
          ),
        ],
      ),
      actions: <Widget>[
        Center(
          child: ColorButton(
            bg: AppColors.mainColor,
            height: getDynamicHeight(48),
            width: AppSizes.screenWidth * 0.8,
            text: AppLanguage.closeStr,
            press: () => Navigator.pop(Get.context!),
          ),
        ),
      ],
    ),
  );
}
*/
