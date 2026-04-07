import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/view/widget/loading_button.dart';

import '../../core/localization/language.dart';

Future bsTakePicture({
  required VoidCallback galleryPress,
  required VoidCallback cameraPress,
  VoidCallback? filePress,
  bool isShowFile = false,
}) {
  return Get.bottomSheet(
    Container(
      decoration: BoxDecoration(
        borderRadius: .vertical(top: Radius.circular(getDynamicHeight(16))),
        color: Colors.white,
      ),
      child: SafeArea(
        child: Padding(
          padding: .symmetric(horizontal: 16, vertical: getDynamicHeight(20)),
          child: Column(
            crossAxisAlignment: .center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isShowFile)
                LoadingButton(
                  height: getDynamicHeight(48),
                  width: .infinity,
                  onPressed: filePress,
                  text: AppLanguage.fileStr.tr,
                  bgColor: AppColors.mainColor,
                ),
              if (isShowFile) SizedBox(height: getDynamicHeight(8)),
              LoadingButton(
                height: getDynamicHeight(48),
                width: .infinity,
                onPressed: galleryPress,
                text: AppLanguage.selectFromGalleryStr.tr,
                bgColor: AppColors.mainColor,
              ),
              SizedBox(height: getDynamicHeight(8)),
              OutlinedButton(
                onPressed: cameraPress,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: .circular(14)),
                  side: const BorderSide(color: AppColors.mainColor),
                  fixedSize: Size(AppSizes.screenWidth, getDynamicHeight(48)),
                ),
                child: Text(
                  AppLanguage.cameraStr.tr,
                  style: AppTextStyles.bold14.copyWith(
                    color: AppColors.mainColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
