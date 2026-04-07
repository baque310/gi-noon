import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/controllers/gallery_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/models/attachment_model.dart';
import 'package:noon/models/reusable_model.dart';
import 'package:noon/view/screen/show_images_screen.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/error_message.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:noon/view/widget/retry_btn.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/localization/language.dart';
import '../widget/images/custom_network_img_provider.dart';

class GalleryScreen extends StatelessWidget {
  GalleryScreen({super.key});

  final _controller = Get.find<GalleryController>();

  @override
  Widget build(BuildContext context) {
    final controller = _controller.pagingController;
    final firstPageKey = controller.firstPageKey;
    final nextPageKey = controller.nextPageKey ?? 0;

    return Scaffold(
      appBar: CustomAppBar(
        appBarName: AppLanguage.galleryStr.tr,
        isLeading: true,
        press: () => Get.back(),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const .only(left: 16, top: 16, bottom: 24, right: 16),
            sliver: PagedSliverList(
              pagingController: controller,
              builderDelegate: PagedChildBuilderDelegate<ReusableModel>(
                itemBuilder: (context, item, index) {
                  return Padding(
                    padding: const .only(bottom: 12),
                    child: GalleryImages(
                      title: item.title,
                      description: item.description ?? '',
                      attachments: item.attachments!.toList(),
                      createdAt: item.createdAt.formatDateToYearMonthDay,
                    ),
                  );
                },
                firstPageErrorIndicatorBuilder: (_) => ErrorMessage(
                  press: () => _controller.getGallery(firstPageKey),
                  errorMsg: AppLanguage.errorStr.tr,
                ),
                newPageErrorIndicatorBuilder: (_) =>
                    RetryBtn(press: () => _controller.getGallery(nextPageKey)),
                firstPageProgressIndicatorBuilder: (_) => const Loading(),
                newPageProgressIndicatorBuilder: (_) => const Loading(),
                noItemsFoundIndicatorBuilder: (_) =>
                    NoDataWidget(title: AppLanguage.noInfoAvailable.tr),
                noMoreItemsIndicatorBuilder: (_) => const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GalleryImages extends StatelessWidget {
  const GalleryImages({
    super.key,
    required this.attachments,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  final List<AttachmentModel> attachments;
  final String title;
  final String description;
  final String createdAt;

  @override
  Widget build(BuildContext context) {
    return attachments.isNotEmpty
        ? Column(
            spacing: 4,
            crossAxisAlignment: .start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: getDynamicHeight(156),
                    width: getDynamicWidth(350),
                    child: GestureDetector(
                      onTap: () => Get.to(
                        () => ShowImageGalleryScreen(
                          img: _urlsFromAttachments,
                          images: const [],
                        ),
                      ),
                      child: CustomNetworkImgProvider(
                        imageUrl: attachments[0].url,
                        height: 156,
                        width: 156,
                        radius: 8,
                      ),
                    ),
                  ),

                  PositionedDirectional(
                    start: 8,
                    top: 8,
                    child: Container(
                      padding: const .all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: .circular(12),
                      ),
                      child: Text(createdAt, style: AppTextStyles.medium12),
                    ),
                  ),

                  PositionedDirectional(
                    end: 8,
                    bottom: 8,
                    child: Container(
                      padding: const .all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: .circular(12),
                      ),
                      child: Text(
                        '${AppLanguage.pictures.tr}: ${attachments.length}',
                        style: AppTextStyles.medium12,
                      ),
                    ),
                  ),
                ],
              ),
              Linkify(
                text: title,
                style: AppTextStyles.bold16,
                onOpen: (link) =>
                    launchUrl(Uri.parse(link.url), mode: .externalApplication),
              ),
              Linkify(
                text: description,
                style: AppTextStyles.regular14.copyWith(
                  color: AppColors.neutralDarkGrey,
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  List<String> get _urlsFromAttachments {
    return attachments.map((e) => e.url).toList();
  }
}
