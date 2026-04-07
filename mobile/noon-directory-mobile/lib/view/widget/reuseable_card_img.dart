import 'package:flutter/material.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/view/widget/custom_inkwell.dart';
import 'package:noon/view/widget/images/custom_network_img_provider.dart';

class ReuseableCardImg extends StatelessWidget {
  final String img;
  final String title;
  final VoidCallback onTap;
  final String? desc;

  const ReuseableCardImg({
    super.key,
    required this.img,
    required this.title,
    this.desc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkwell(
      onTap: onTap,
      child: Container(
        padding: .all(getDynamicHeight(16)),
        decoration: BoxDecoration(
          border: .all(
            color: AppColors.blackColor.withValues(alpha: 0.12),
            width: 0.5,
          ),
          borderRadius: .circular(16),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            CustomNetworkImgProvider(
              imageUrl: img,
              height: getDynamicHeight(156),
              width: .infinity,
              radius: 14,
            ),
            SizedBox(height: getDynamicHeight(10)),
            Text(title, style: AppTextStyles.medium16),
            if (desc != null)
              Text(
                desc!,
                style: AppTextStyles.medium12.copyWith(
                  color: AppTextStyles.medium12.color!.withValues(alpha: 0.60),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
