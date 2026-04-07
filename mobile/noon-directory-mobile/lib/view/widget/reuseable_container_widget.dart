import 'package:flutter/material.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';

class ReuseableContainerWidget extends StatelessWidget {
  const ReuseableContainerWidget({
    super.key,
    required this.text1,
    required this.text2,
  });

  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: getDynamicHeight(16)),
      height: getDynamicHeight(42),
      width: .infinity,
      decoration: const BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: .only(topLeft: .circular(12), topRight: .circular(12)),
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            text1,
            style: AppTextStyles.medium12.copyWith(color: Colors.white),
          ),
          Text(
            text2,
            style: AppTextStyles.medium12.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
