import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noon/core/constant/app_colors.dart';

import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/view/widget/custom_inkwell.dart';

class MainItem extends StatelessWidget {
  const MainItem({
    super.key,
    required this.onPressed,
    required this.bgColor,
    this.svgIcon,
    this.iconData,
    required this.title,
    this.badge,
  });

  final void Function()? onPressed;
  final Color bgColor;
  final String? svgIcon;
  final IconData? iconData;
  final String title;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: .center,
      child: CustomInkwell(
        inkwellRadius: 24,
        onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: AppColors.neutralLightGrey.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: getDynamicHeight(48),
                    width: getDynamicWidth(48),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                    ),
                    child: svgIcon != null
                        ? SvgPicture.asset(
                            svgIcon!,
                            width: getDynamicWidth(24),
                            height: getDynamicHeight(24),
                            colorFilter: ColorFilter.mode(
                              bgColor.withValues(alpha: 1.0),
                              BlendMode.srcIn,
                            ),
                          )
                        : Icon(
                            iconData ?? Icons.face_retouching_natural,
                            size: getDynamicWidth(24),
                            color: bgColor.withValues(alpha: 1.0),
                          ),
                  ),

                  // ? badge
                  if (badge != null && badge != '0')
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        padding: const .all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.redColor,
                          shape: .circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            badge!,
                            style: AppTextStyles.bold12.copyWith(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                            textAlign: .center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: getDynamicHeight(8)),
              Text(
                title,
                style: AppTextStyles.medium16.copyWith(
                  color: AppColors.neutralDarkGrey,
                ),
                textAlign: .center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
