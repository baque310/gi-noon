import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/controllers/announcements_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/extensions/string_extension.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/models/notification_model.dart';
import 'package:noon/view/screen/show_images_screen.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/error_message.dart';
import 'package:noon/view/widget/images/custom_network_img_provider.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:noon/view/widget/retry_btn.dart';
import 'package:s_extensions/s_extensions.dart';

import 'package:noon/controllers/global_controller.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AnnouncementsController>(
      tag: GlobalController.to.selectedStudentIdForParent.value,
      init: AnnouncementsController(),
      dispose: (state) => state.controller?.dispose(),
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            appBar: CustomAppBar(
              appBarName: AppLanguage.announcements.tr,
              isLeading: true,
            ),
            body: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 16,
                    bottom: 24,
                    right: 16,
                  ),
                  sliver: PagedSliverList(
                    pagingController: controller.pagingController,
                    builderDelegate:
                        PagedChildBuilderDelegate<NotificationModel>(
                          itemBuilder: (context, item, index) => Padding(
                            padding: EdgeInsets.only(
                              bottom: getDynamicHeight(6),
                            ),
                            child: _card(item, index),
                          ),
                          firstPageErrorIndicatorBuilder: (_) => ErrorMessage(
                            press: () => controller.getAnnouncements(
                              controller.pagingController.firstPageKey,
                            ),
                            errorMsg: AppLanguage.errorStr.tr,
                          ),
                          newPageErrorIndicatorBuilder: (_) => RetryBtn(
                            press: () => controller.getAnnouncements(
                              controller.pagingController.nextPageKey ??
                                  controller.pagingController.firstPageKey,
                            ),
                          ),
                          firstPageProgressIndicatorBuilder: (_) =>
                              const Loading(),
                          newPageProgressIndicatorBuilder: (_) =>
                              const Loading(),
                          noItemsFoundIndicatorBuilder: (_) => NoDataWidget(
                            title: AppLanguage.noInfoAvailable.tr,
                          ),
                          noMoreItemsIndicatorBuilder: (_) => const SizedBox(),
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _card(NotificationModel n, int index) {
    final hasImage = n.imageUrl != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderColor10, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasImage) ...[
            GestureDetector(
              onTap: () {
                Get.to(
                  () => ShowImageGalleryScreen(
                    img: [n.imageUrl!.imgUrlToFullUrl!],
                    images: const [],
                  ),
                );
              },
              child: CustomNetworkImgProvider(
                height: getDynamicHeight(120),
                width: double.infinity,
                radius: 12,
                fit: BoxFit.cover,
                imageUrl: n.imageUrl!.imgUrlToFullUrl!,
              ),
            ),
            SizedBox(height: getDynamicHeight(8)),
          ],
          Text(
            '${n.title}',
            style: AppTextStyles.bold16.copyWith(
              color: AppTextStyles.medium14.color!.withValues(alpha: 0.87),
            ),
          ),
          SizedBox(height: getDynamicHeight(8)),
          Text(
            n.body ?? '',
            softWrap: true,
            style: AppTextStyles.regular14.copyWith(
              color: AppTextStyles.regular14.color!.withValues(alpha: 0.60),
            ),
          ),
          SizedBox(height: getDynamicHeight(8)),
          Text(
            n.updatedAt.toDate!.formatYearMonthDay,
            maxLines: 1,
            style: AppTextStyles.regular14.copyWith(
              color: AppColors.gray700Color,
            ),
          ),
        ],
      ),
    );
  }
}
