import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/view/widget/images/custom_network_image.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:s_extensions/s_extensions.dart';

import '../../../../core/localization/language.dart';

class LibraryTeacherCard extends StatelessWidget {
  const LibraryTeacherCard({
    super.key,
    this.onTap,
    required this.date,
    required this.subject,
    required this.desc,
    required this.img,
    required this.title,
    required this.editPress,
    this.onPressedDelete,
  });

  final VoidCallback? onTap;
  final VoidCallback? editPress;
  final VoidCallback? onPressedDelete;
  final String date;
  final String subject;
  final String title;
  final String desc;
  final String img;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: .circular(12),
      child: Container(
        margin: const .symmetric(vertical: 6),
        padding: const .symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: .circular(12),
          border: .all(
            color: AppColors.mainColor.withValues(alpha: 0.50),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.medium14.copyWith(
                          color: AppTextStyles.medium14.color!.withValues(
                            alpha: 0.87,
                          ),
                        ),
                      ),
                      Text(
                        "${AppLanguage.createdAtStr.tr} $date",
                        style: AppTextStyles.medium12.copyWith(
                          color: AppTextStyles.medium12.color!.withValues(
                            alpha: 0.60,
                          ),
                        ),
                      ),
                      SizedBox(height: getDynamicHeight(2)),
                      Text(
                        "${AppLanguage.descStr.tr} $desc",
                        style: AppTextStyles.medium12.copyWith(
                          color: AppTextStyles.medium12.color!.withValues(
                            alpha: 0.60,
                          ),
                        ),
                        softWrap: true,
                        maxLines: 2,
                        overflow: .ellipsis,
                      ),
                    ],
                  ),
                ).expanded(),
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    OutlinedButton(
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(borderRadius: .circular(32)),
                        ),
                      ),
                      onPressed: editPress,
                      child: Text(
                        AppLanguage.editStr.tr,
                        style: AppTextStyles.medium10.copyWith(
                          color: AppColors.mainColor,
                        ),
                      ),
                    ),
                    if (onPressedDelete != null)
                      OutlinedButton(
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(borderRadius: .circular(32)),
                          ),
                        ),
                        onPressed: onPressedDelete,
                        child: Text(
                          AppLanguage.deleteStr.tr,
                          style: AppTextStyles.medium10.copyWith(
                            color: AppColors.errorRedColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(height: getDynamicHeight(16)),
            CustomNetworkImage(
              height: 138,
              width: .infinity,
              imageUrl: img,
              radius: .circular(14),
            ),
          ],
        ),
      ),
    );
  }
}
