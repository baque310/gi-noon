import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/extensions/string_extension.dart';
import 'package:noon/view/widget/loading.dart';

class CustomNetworkImgProvider extends StatelessWidget {
  const CustomNetworkImgProvider({
    super.key,
    this.imageUrl,
    this.child,
    required this.height,
    required this.width,
    required this.radius,
    this.fit,
    this.isFile = false,
  });

  final String? imageUrl;
  final Widget? child;
  final double height;
  final double width;
  final double radius;
  final BoxFit? fit;
  final bool isFile;

  @override
  Widget build(BuildContext context) {
    final fullUrl = (imageUrl != null && imageUrl!.isNotEmpty)
        ? (imageUrl!.startsWith('http') ? imageUrl : imageUrl!.imgUrlToFullUrl)
        : null;

    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: fullUrl ?? '',
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: .circular(radius),
          image: DecorationImage(image: imageProvider, fit: fit ?? .cover),
        ),
        child: child,
      ),
      placeholder: (context, url) => Center(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.gray100Color,
            borderRadius: .circular(radius),
          ),
          height: height,
          width: .infinity,
          child: const Loading(),
        ),
      ),
      errorWidget: (_, url, err) => Container(
        decoration: BoxDecoration(
          borderRadius: .circular(radius),
          color: AppColors.gray100Color,
        ),
        height: height,
        width: .infinity,
        alignment: .center,
        child: SvgPicture.asset(
          isFile ? AppAssets.icPdf : AppAssets.icImageNotFound,
          width: getDynamicWidth(36),
          height: getDynamicHeight(36),
        ),
      ),
    );
  }
}
