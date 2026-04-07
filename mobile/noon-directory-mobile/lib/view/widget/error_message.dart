import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/view/widget/color_button.dart';

import '../../core/localization/language.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, required this.press, this.errorMsg});

  final VoidCallback press;
  final String? errorMsg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          SvgPicture.asset(
            AppAssets.icNoInternetV2,
            width: Get.size.width * 0.5,
          ),
          SizedBox(height: getDynamicHeight(16)),
          Text(
            errorMsg ?? AppLanguage.unexpectedErrorStr.tr,
            style: AppTextStyles.semiBold18,
            textAlign: .center,
          ),
          SizedBox(height: getDynamicHeight(16)),
          ColorButton(
            height: getDynamicHeight(50),
            text: AppLanguage.retryStr.tr,
            press: press,
          ),
        ],
      ),
    );
  }
}
