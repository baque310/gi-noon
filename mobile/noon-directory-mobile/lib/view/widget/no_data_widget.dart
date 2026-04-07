import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:s_extensions/s_extensions.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      mainAxisAlignment: .center,
      mainAxisSize: .min,
      children: [
        SvgPicture.asset(
          AppAssets.icEmptyV2,
          width: getDynamicWidth(.4.screenWidth),
        ),
        const SizedBox(height: 24),

        Text(
          title,
          style: AppTextStyles.semiBold16,
          textAlign: .center,
          maxLines: 2,
        ),
      ],
    );
  }
}
