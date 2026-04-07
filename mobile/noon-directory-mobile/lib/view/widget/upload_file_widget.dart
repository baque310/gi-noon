import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/constant/app_assets.dart';
import '../../core/constant/app_colors.dart';
import '../../core/constant/app_text_style.dart';
import 'custom_inkwell.dart';

class UploadFileWidget extends StatelessWidget {
  const UploadFileWidget({
    super.key,
    required this.title,
    required this.onTaped,
  });

  final String title;
  final VoidCallback onTaped;

  @override
  Widget build(BuildContext context) {
    return CustomInkwell(
      inkwellRadius: 10,
      onTap: onTaped,
      child: Container(
        width: .infinity,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: .circular(10),
          border: .all(color: AppColors.yellow400Color),
        ),
        child: Column(
          spacing: 12,
          mainAxisAlignment: .center,
          children: [
            SvgPicture.asset(
              AppAssets.icUpload,
              width: 64,
              height: 64,
              fit: BoxFit.none,
            ),
            Text(title, style: AppTextStyles.medium14),
          ],
        ),
      ),
    );
  }
}
