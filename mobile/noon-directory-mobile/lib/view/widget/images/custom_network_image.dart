import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:noon/core/extensions/string_extension.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    this.imageUrl,
    this.height,
    this.width,
    this.radius,
    this.localIcon,
    this.fit,
    this.viewImage = true,
  });

  final String? imageUrl;
  final double? height;
  final double? width;
  final BorderRadius? radius;
  final String? localIcon;
  final BoxFit? fit;
  // تحديد ما إذا كان يسمح بفتح الصورة بملء الشاشة عند الضغط عليها
  final bool viewImage;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return imageStatus(false);
    } else if (imageUrl!.toLowerCase().endsWith('.pdf')) {
      return _pdfWidget();
    } else {
      String? fullUrl = imageUrl!.startsWith('http')
          ? imageUrl
          : imageUrl!.imgUrlToFullUrl;

      // Remove double slashes everywhere Except after : or in the protocol part
      if (fullUrl != null) {
        fullUrl = fullUrl.replaceAll(RegExp(r'(?<!:)/{2,}'), '/');
      }

      return ClipRRect(
        borderRadius: radius ?? BorderRadius.circular(32),
        child: viewImage
            ? InstaImageViewer(
                imageUrl: fullUrl,
                child: CachedNetworkImage(
                  imageUrl: fullUrl ?? '',
                  height: height,
                  width: width,
                  fit: fit ?? BoxFit.cover,
                  errorWidget: (context, _, stackTrace) => imageStatus(false),
                  placeholder: (context, url) => imageStatus(true),
                ),
              )
            : CachedNetworkImage(
                imageUrl: fullUrl ?? '',
                height: height,
                width: width,
                fit: fit ?? BoxFit.cover,
                errorWidget: (context, _, stackTrace) => imageStatus(false),
                placeholder: (context, url) => imageStatus(true),
              ),
      );
    }
  }

  Widget _pdfWidget() {
    return Container(
      height: height,
      width: width,
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.picture_as_pdf,
            color: Colors.red,
            size: getDynamicHeight(40),
          ),
          const Text(
            "PDF File",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget imageStatus(bool loading) {
    return Container(
      height: height,
      width: width,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: loading
          ? const Loading(size: 15)
          : SvgPicture.asset(
              localIcon ?? AppAssets.icImageNotFound,
              width: getDynamicWidth(24),
              height: getDynamicHeight(24),
            ),
    );
  }
}
