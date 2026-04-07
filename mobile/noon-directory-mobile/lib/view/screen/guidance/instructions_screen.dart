import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/controllers/instructions_controller.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/models/reusable_model.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/error_message.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:noon/view/widget/retry_btn.dart';
import 'package:noon/view/widget/reuseable_card_img.dart';

import '../../../core/localization/language.dart';

class InstructionsScreen extends StatelessWidget {
  InstructionsScreen({super.key});
  final InstructionsController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final controller = _controller.pagingController;
    final firstPageKey = controller.firstPageKey;
    final nextPageKey = controller.nextPageKey ?? 0;
    return Scaffold(
      appBar: CustomAppBar(
        appBarName: AppLanguage.instructionsStr.tr,
        isLeading: true,
        press: () {
          Get.back();
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const .only(left: 16, top: 16, bottom: 24, right: 16),
            sliver: PagedSliverList(
              pagingController: controller,
              builderDelegate: PagedChildBuilderDelegate<ReusableModel>(
                itemBuilder: (context, item, index) {
                  return ReuseableCardImg(
                    onTap: () => Get.toNamed(
                      ScreensUrls.instructionsDetailsUrl,
                      arguments: {'id': item.id},
                    ),
                    img: item.url!,
                    title: item.title,
                    desc: item.description,
                  );
                },
                firstPageErrorIndicatorBuilder: (_) => ErrorMessage(
                  press: () => _controller.getGuidances(firstPageKey),
                  errorMsg: AppLanguage.errorStr.tr,
                ),
                newPageErrorIndicatorBuilder: (_) => RetryBtn(
                  press: () => _controller.getGuidances(nextPageKey),
                ),
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
