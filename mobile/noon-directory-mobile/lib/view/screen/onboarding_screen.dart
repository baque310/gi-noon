import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/controllers/onboarding_controller.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/view/widget/dropdown/generic_dropdown_widget.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ? skip button
            Padding(
              padding: const .all(16.0),
              child: Align(
                alignment: AlignmentDirectional.topEnd,
                child: Obx(() {
                  return controller.currentPage.value < 2
                      ? TextButton(
                          onPressed: controller.skipOnboarding,
                          child: Text(
                            AppLanguage.skip.tr,
                            style: AppTextStyles.medium16.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : const SizedBox.shrink();
                }),
              ),
            ),

            // ? pages
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: [
                  // ? page 1
                  _buildPage(
                    imagePath: AppAssets.imagesSmartHomeContol,
                    title: AppLanguage.onboardingTitle1.tr,
                    showLanguageDropdown: true,
                  ),

                  // ? page 2
                  _buildPage(
                    imagePath: AppAssets.imagesCoding,
                    title: AppLanguage.onboardingTitle2.tr,
                  ),

                  // ? page 3
                  _buildPage(
                    imagePath: AppAssets.imagesGraduation,
                    title: AppLanguage.onboardingTitle3.tr,
                  ),
                ],
              ),
            ),

            // ? pages indicator dots
            Obx(() {
              return Row(
                mainAxisAlignment: .center,
                children: List.generate(
                  3,
                  (index) => Container(
                    margin: const .symmetric(horizontal: 4),
                    width: controller.currentPage.value == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == index
                          ? AppColors.primary
                          : Colors.grey.withValues(alpha: 0.3),
                      borderRadius: .circular(4),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 32),

            // ? next and previous buttons
            Padding(
              padding: const .symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  // ? previous button
                  Obx(() {
                    return controller.currentPage.value > 0
                        ? TextButton(
                            onPressed: () {
                              controller.pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Text(
                              AppLanguage.previous.tr,
                              style: AppTextStyles.bold16.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          )
                        : const SizedBox(width: 80);
                  }),

                  // ? next button
                  ElevatedButton(
                    onPressed: controller.nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const .symmetric(horizontal: 48, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(12),
                      ),
                    ),
                    child: Text(
                      AppLanguage.next.tr,
                      style: AppTextStyles.bold16.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required String imagePath,
    required String title,
    bool showLanguageDropdown = false,
  }) {
    final gController = Get.find<GlobalController>();
    return Padding(
      padding: const .symmetric(horizontal: 34.0),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          // ? banner image
          SvgPicture.asset(imagePath, width: 290, height: 290),
          const SizedBox(height: 48),

          Text(
            title,
            textAlign: .center,
            style: AppTextStyles.bold20.copyWith(
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 34),

          // ? language dropdown
          if (showLanguageDropdown)
            Obx(() {
              return CustomGenericDropDown<String>(
                value: controller.selectedLanguage.value,
                content: [AppLanguage.arabic.tr, AppLanguage.english.tr],
                displayText: (value) => value,
                hint: AppLanguage.chooseLanguage.tr,
                dropdownPosition: .above,
                onChanged: (value) {
                  controller.selectedLanguage.value =
                      value ?? AppLanguage.english.tr;
                  gController.selectedLanguageIndex.value =
                      value == AppLanguage.arabic.tr ? 0 : 1;
                  gController.setLanguage();
                },
              );
            }),
        ],
      ),
    );
  }
}
