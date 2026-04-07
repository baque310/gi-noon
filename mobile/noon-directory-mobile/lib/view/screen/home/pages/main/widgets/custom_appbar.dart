import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/profile_controller.dart';
import 'package:noon/controllers/communication_controller.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/view/widget/profile_image.dart';
import '../../../../../../core/constant/screens_urls.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
    this.name,
    this.academicStage,
    this.imageUrl,
    this.studentSection,
  });

  final String? name;
  final String? academicStage;
  final String? imageUrl;
  final String? studentSection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(
        horizontal: getDynamicWidth(16),
        vertical: getDynamicHeight(8),
      ),
      child: Row(
        crossAxisAlignment: .center,
        mainAxisAlignment: .spaceBetween,
        children: [
          if (name != null)
            ProfileImage(
              firstCharFromName: name?.substring(0, 1),
              imageUrl: imageUrl,
            ),
          Expanded(
            child: Padding(
              padding: .symmetric(horizontal: getDynamicHeight(14)),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  if (name != null)
                    Text(
                      name!,
                      style: AppTextStyles.medium14.copyWith(
                        color: AppColors.neutralDarkGrey,
                      ),
                    ),
                  if (academicStage != null && studentSection != null)
                    Row(
                      children: [
                        if (academicStage != null)
                          Text(
                            academicStage!,
                            style: AppTextStyles.medium12.copyWith(
                              color: AppColors.neutralMidGrey,
                            ),
                          ),
                        if (studentSection != null)
                          Text(
                            ' - ${studentSection!}',
                            style: AppTextStyles.medium12.copyWith(
                              color: AppColors.neutralMidGrey,
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          // ChatIcon moved to bottom nav bar
          NotificationsIcon(),
        ],
      ),
    );
  }
}

class NotificationsIcon extends StatelessWidget {
  NotificationsIcon({super.key});

  final controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(ScreensUrls.notificationUrl),
      child: Stack(
        clipBehavior: .none,
        alignment: .center,
        children: [
          SvgPicture.asset(
            AppAssets.icNotificationV2,
            width: 40,
            height: 40,
            colorFilter: const ColorFilter.mode(
              AppColors.warningColor,
              BlendMode.srcIn,
            ),
          ),
          GetX<ProfileController>(
            builder: (_) {
              return controller.notificationCount.value > 0
                  ? Positioned(
                      left: 20,
                      top: 4,
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          borderRadius: .circular(8),
                          color: AppColors.redColor,
                        ),
                        child: Text(
                          controller.notificationCount.value.toString(),
                          style: AppTextStyles.semiBold10.copyWith(
                            color: Colors.white,
                          ),
                          textAlign: .center,
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class ChatIcon extends StatelessWidget {
  ChatIcon({super.key});

  final controller = Get.find<ProfileController>();
  final commController = Get.put(CommunicationController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(ScreensUrls.communicationScreenUrl),
      child: Stack(
        clipBehavior: .none,
        alignment: .center,
        children: [
          SvgPicture.asset(
            AppAssets.icChatV2,
            width: 40,
            height: 40,
            colorFilter: const ColorFilter.mode(
              AppColors.warningColor,
              BlendMode.srcIn,
            ),
          ),
          Obx(() {
            final unreadCount = controller.unreadMessagesCount.value;

            return unreadCount > 0
                ? PositionedDirectional(
                    end: 4,
                    top: 4,
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.redColor,
                      ),
                      child: Text(
                        unreadCount.toString(),
                        style: AppTextStyles.semiBold10.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
