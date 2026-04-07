import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/view/widget/loading_button.dart';

import '../../../../core/localization/language.dart';

class StudentLibraryCard extends StatelessWidget {
  const StudentLibraryCard({
    super.key,
    required this.title,
    required this.desc,
    required this.pressDownload,
    required this.isLoading,
    required this.textBtn,
    this.isFile = false,
    this.onShare,
  });

  final String? title;
  final String? desc;
  final VoidCallback? pressDownload;
  final void Function()? onShare;
  final bool isLoading, isFile;
  final String textBtn;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const .symmetric(vertical: 6),
      padding: .symmetric(
        vertical: getDynamicHeight(12),
        horizontal: getDynamicHeight(14),
      ),
      decoration: BoxDecoration(
        borderRadius: .circular(getDynamicHeight(16)),
        border: .all(
          color: AppColors.blackColor.withValues(alpha: 0.12),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          isFile
              ? Icon(
                  Icons.picture_as_pdf_rounded,
                  size: getDynamicHeight(40),
                  color: AppColors.redColor,
                )
              : Icon(
                  Icons.image_rounded,
                  size: getDynamicHeight(40),
                  color: AppColors.mainColor,
                ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  title ?? '',
                  style: AppTextStyles.medium16.copyWith(
                    color: AppTextStyles.medium16.color!.withValues(
                      alpha: 0.87,
                    ),
                  ),
                ),
                Text(
                  "${AppLanguage.detailsSimiStr.tr} $desc",
                  style: AppTextStyles.medium12.copyWith(
                    color: AppTextStyles.medium12.color!.withValues(
                      alpha: 0.60,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),

          if (onShare != null)
            IconButton(onPressed: onShare, icon: Icon(Icons.share_rounded)),
          const SizedBox(width: 5),

          LoadingButton(
            radius: getDynamicHeight(12),
            textStyle: AppTextStyles.medium10.copyWith(color: Colors.white),
            isLoading: isLoading,
            bgColor: AppColors.mainColor,
            onPressed: pressDownload,
            text: textBtn,
            width: getDynamicHeight(84),
            height: getDynamicHeight(30),
          ),
        ],
      ),
    );
  }
}
