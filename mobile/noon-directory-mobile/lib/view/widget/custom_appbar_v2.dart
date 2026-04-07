import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_text_style.dart';

class CustomAppBarV2 extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBarV2({
    super.key,
    this.appBarName,
    this.actions,
    this.actionButtonText,
    this.height,
    this.press,
    this.isLeading = false,
  });

  final String? appBarName;
  final List<Widget>? actions;
  final String? actionButtonText;
  final double? height;
  final VoidCallback? press;
  final bool isLeading;

  @override
  Size get preferredSize => Size.fromHeight(getDynamicHeight(70));

  final controller = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: AppColors.neutralBackground,
      actions: actions,
      leading: isLeading
          ? Center(
              child: InkWell(
                borderRadius: .circular(getDynamicHeight(12)),
                onTap: press ?? () => Get.back(),
                child: Container(
                  height: getDynamicHeight(40),
                  width: getDynamicHeight(40),
                  decoration: BoxDecoration(
                    borderRadius: .circular(getDynamicHeight(12)),
                    border: .all(
                      color: AppColors.blackColor.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      controller.isLtr
                          ? AppAssets.icArrowLeft
                          : AppAssets.icBackCircle,
                      height: getDynamicHeight(20),
                      width: getDynamicWidth(20),
                    ),
                  ),
                ),
              ),
            )
          : null,
      title: Text(appBarName ?? '', style: AppTextStyles.medium14),
    );
  }
}
