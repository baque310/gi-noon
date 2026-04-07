import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/lines_controller.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/view/screen/show_images_screen.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/custom_info_card.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:noon/view/widget/profile_image.dart';

import '../../core/localization/language.dart';

class LinesScreen extends StatelessWidget {
  const LinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LinesController controller = Get.find();
    double radius = getDynamicHeight(14);

    return Scaffold(
      appBar: CustomAppBar(
        appBarName: AppLanguage.transportLinesStr.tr,
        isLeading: true,
      ),
      body: Padding(
        padding: const .symmetric(horizontal: 16, vertical: 16),
        child: Obx(() {
          if (controller.loading.value) return const Center(child: Loading());
          if (controller.errorMessage.value != '') {
            return Center(
              child: Text(
                controller.errorMessage.value,
                style: AppTextStyles.bold16,
              ),
            );
          }

          return Column(
            crossAxisAlignment: .center,
            mainAxisAlignment: .start,
            children: [
              ProfileImage(
                onTap: controller.bus.value?.photo != null
                    ? () {
                        Get.to(
                          () => ShowImageGalleryScreen(
                            img: [controller.bus.value!.photo!],
                            images: const [],
                          ),
                        );
                      }
                    : null,
                firstCharFromName:
                    controller.bus.value?.fullName?.substring(0, 1) ?? '',
                imageUrl: controller.bus.value?.photo,
              ),
              SizedBox(height: getDynamicHeight(10)),
              Text(
                AppLanguage.personBusNameStr.tr,
                style: AppTextStyles.medium14.copyWith(
                  color: AppTextStyles.medium14.color!.withValues(alpha: 0.60),
                ),
              ),
              SizedBox(height: getDynamicHeight(4)),
              Text(
                controller.bus.value?.fullName ?? '',
                style: AppTextStyles.semiBold16.copyWith(
                  color: AppTextStyles.semiBold16.color!.withValues(
                    alpha: 0.87,
                  ),
                ),
              ),
              SizedBox(height: getDynamicHeight(20)),
              CustomInformationCard(
                constTitle: AppLanguage.phoneNumberStr.tr,
                title: controller.bus.value?.phone1 ?? '',
                radius: radius,
              ),
              CustomInformationCard(
                constTitle: AppLanguage.busTypeStr.tr,
                title: controller.bus.value?.carType ?? '',
                radius: radius,
              ),
              CustomInformationCard(
                constTitle: AppLanguage.busColorStr.tr,
                title: controller.bus.value?.carColor ?? '',
                radius: radius,
              ),
              CustomInformationCard(
                constTitle: AppLanguage.busNumberStr.tr,
                title: controller.bus.value?.carNumber ?? '',
                radius: radius,
              ),
            ],
          );
        }),
      ),
    );
  }
}
