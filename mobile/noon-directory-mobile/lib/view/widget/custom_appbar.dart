import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    super.key,
    this.appBarName,
    this.actions,
    this.actionButtonText,
    this.height,
    this.press,
    this.isLeading = false,
    this.bottom,
  });

  final String? appBarName;
  final List<Widget>? actions;
  final String? actionButtonText;
  final double? height;
  final VoidCallback? press;
  final bool isLeading;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize {
    final baseHeight = height ?? getDynamicHeight(56);
    final bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(baseHeight + bottomHeight);
  }

  final controller = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: isLeading
          ? Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(getDynamicHeight(12)),
                onTap: press ?? () => Get.back(),
                child: Container(
                  height: getDynamicHeight(40),
                  width: getDynamicHeight(40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(getDynamicHeight(12)),
                    border: Border.all(
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
      title: Text(appBarName ?? '', style: AppTextStyles.bold16),
      centerTitle: true,
      actions: actions,
      bottom: bottom,
    );
  }
}
