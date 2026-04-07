import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';

class InstallmentTotalTile extends StatelessWidget {
  final String title, text, icon;
  final Color color;
  const InstallmentTotalTile({
    super.key,
    required this.title,
    required this.text,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(getDynamicWidth(12)),
      decoration: BoxDecoration(color: color, borderRadius: .circular(16)),
      child: Column(
        crossAxisAlignment: .center,
        mainAxisAlignment: .center,
        children: [
          Row(
            children: [
              SvgPicture.asset(icon, width: getDynamicWidth(24)),
              const SizedBox(width: 6),
              SizedBox(
                width: 125,
                child: Text(
                  title.tr,
                  style: AppTextStyles.semiBold14.copyWith(color: Colors.white),
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
              ),
            ],
          ),
          Text(
            text,
            style: AppTextStyles.semiBold16.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
