import 'package:flutter/material.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/view/widget/custom_inkwell.dart';
import 'package:noon/view/widget/images/custom_network_image.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
    this.imageUrl,
    this.firstCharFromName,
    this.onTap,
    this.size = 50,
  });

  final String? imageUrl;
  final String? firstCharFromName;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomInkwell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: getDynamicWidth(size),
        width: getDynamicWidth(size),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.secondryOringe,
        ),
        child: _renderImage(),
      ),
    );
  }

  Widget _renderImage() {
    if (imageUrl != null) {
      return AspectRatio(
        aspectRatio: 1,
        child: CustomNetworkImage(
          imageUrl: imageUrl,
          radius: BorderRadius.circular(size),
          height: size,
          width: size,
          fit: BoxFit.cover,
          viewImage: false,
        ),
      );
    }

    return Text(
      firstCharFromName.toString(),
      style: AppTextStyles.bold24.copyWith(color: Colors.white),
    );
  }
}
