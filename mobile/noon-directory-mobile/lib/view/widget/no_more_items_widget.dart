import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/constant/app_sizes.dart';

import '../../core/localization/language.dart';

class NoMoreItemsWidget extends StatelessWidget {
  const NoMoreItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(
        vertical: getDynamicHeight(16),
        horizontal: getDynamicWidth(16),
      ),
      child: Center(
        child: Text(
          AppLanguage.noMoreItems.tr,
          style: AppTextStyles.medium14.copyWith(
            color: AppColors.neutralMidGrey,
          ),
          textAlign: .center,
        ),
      ),
    );
  }
}
