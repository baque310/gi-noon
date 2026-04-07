import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/instructions_controller.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/view/screen/show_images_screen.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/custom_inkwell.dart';
import 'package:noon/view/widget/images/custom_network_img_provider.dart';
import 'package:noon/view/widget/loading.dart';

import '../../../core/localization/language.dart';

class InstructionDetailsScreen extends StatelessWidget {
  const InstructionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    InstructionsController controller = Get.find();
    String id = Get.arguments['id'];
    controller.getGuidance(id);

    return Scaffold(
      appBar: CustomAppBar(
        appBarName: AppLanguage.detailsStr.tr,
        isLeading: true,
      ),
      body: Padding(
        padding: .symmetric(
          horizontal: getDynamicHeight(16),
          vertical: getDynamicHeight(20),
        ),
        child: Obx(() {
          if (controller.loading.value) return const Center(child: Loading());
          return Column(
            crossAxisAlignment: .start,
            children: [
              if (controller.guidance.value != null)
                CustomInkwell(
                  onTap: () {
                    if (controller.guidance.value?.url != null) {
                      Get.to(
                        () => ShowImageGalleryScreen(
                          img: [controller.guidance.value!.url.toString()],
                          images: const [],
                        ),
                      );
                    }
                  },
                  child: CustomNetworkImgProvider(
                    imageUrl: controller.guidance.value?.url,
                    height: getDynamicHeight(156),
                    width: .infinity,
                    radius: 14,
                  ),
                ),
              SizedBox(height: getDynamicHeight(20)),
              Text(
                controller.guidance.value?.title ?? '',
                style: AppTextStyles.medium16,
              ),
              SizedBox(height: getDynamicHeight(10)),
              Text(
                controller.guidance.value?.description ?? '',
                style: AppTextStyles.medium12.copyWith(
                  color: AppTextStyles.medium12.color!.withValues(alpha: 0.60),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
