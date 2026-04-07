import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:noon/view/widget/images/custom_network_img_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_sizes.dart';
import '../../core/constant/app_text_style.dart';
import '../../core/localization/language.dart';
import '../../models/lesson_attachment_model.dart';
import '../screen/show_images_screen.dart';

class CardWithMultiImg extends StatelessWidget {
  final List<LessonAttachmentModel> img;
  final String title;
  final String? mainTitle;
  final String? addDate;
  final VoidCallback? onPressed;
  final VoidCallback? onPressedDelete;
  final String? desc;
  final bool isTeacher;
  final Color? borderColor;

  const CardWithMultiImg({
    super.key,
    required this.img,
    this.onPressedDelete,
    required this.title,
    this.desc,
    this.isTeacher = false,
    this.mainTitle,
    this.addDate,
    this.onPressed,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final subTitleStyle = AppTextStyles.medium14.copyWith(
      color: AppTextStyles.medium14.color!.withValues(alpha: 0.60),
    );
    return Container(
      margin: const .only(left: 16, right: 16, top: 16),
      padding: .all(getDynamicHeight(16)),
      decoration: BoxDecoration(
        border: .all(
          color: borderColor ?? AppColors.blackColor.withValues(alpha: 0.12),
          width: 0.5,
        ),
        borderRadius: .circular(16),
      ),
      child: isTeacher
          ? Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  crossAxisAlignment: .start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(mainTitle!, style: AppTextStyles.medium16),
                          SizedBox(height: getDynamicHeight(4)),
                          Text(addDate!, style: subTitleStyle),
                          SizedBox(height: getDynamicHeight(4)),
                          Text(title, style: subTitleStyle),
                          SizedBox(height: getDynamicHeight(4)),
                          if (desc != null)
                            Linkify(
                              text: desc!,
                              style: subTitleStyle,
                              onOpen: (link) => launchUrl(
                                Uri.parse(link.url),
                                mode: LaunchMode.externalApplication,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .start,
                      children: [
                        if (onPressed != null)
                          OutlinedButton(
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: .circular(32),
                                ),
                              ),
                            ),
                            onPressed: onPressed,
                            child: Text(
                              AppLanguage.editStr.tr,
                              style: AppTextStyles.medium10.copyWith(
                                color: AppColors.mainColor,
                              ),
                            ),
                          ),
                        if (onPressedDelete != null)
                          OutlinedButton(
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: .circular(32),
                                ),
                              ),
                            ),
                            onPressed: onPressedDelete,
                            child: Text(
                              AppLanguage.deleteStr.tr,
                              style: AppTextStyles.medium10.copyWith(
                                color: AppColors.errorRedColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: getDynamicHeight(10)),
                AttachmentsList(attachments: img),
              ],
            )
          : Column(
              crossAxisAlignment: .start,
              children: [
                AttachmentsList(attachments: img),
                SizedBox(height: getDynamicHeight(10)),
                Text(title, style: AppTextStyles.medium16),
                Text(
                  "${AppLanguage.lessonDetailsStrs.tr} :",
                  style: AppTextStyles.medium14.copyWith(
                    color: AppColors.mainColor,
                  ),
                ),
                if (desc != null)
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: desc!));
                      Get.snackbar(
                        AppLanguage.tureOperationStr.tr,
                        'تم نسخ الوصف إلى الحافظة',
                      );
                    },
                    child: Text(desc!, style: subTitleStyle),
                  ),
              ],
            ),
    );
  }
}

class AttachmentsList extends StatelessWidget {
  const AttachmentsList({super.key, required this.attachments});

  final List<LessonAttachmentModel> attachments;

  @override
  Widget build(BuildContext context) {
    if (attachments.length == 1) {
      return GestureDetector(
        onTap: () {
          Get.to(() => ShowImageGalleryScreen(images: attachments));
        },
        child: CustomNetworkImgProvider(
          imageUrl: attachments[0].url,
          height: getDynamicHeight(156),
          width: .infinity,
          radius: 14,
        ),
      );
    }

    return attachments.isEmpty
        ? const SizedBox.shrink()
        : SizedBox(
            height: getDynamicHeight(100),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) {
                return GestureDetector(
                  onTap: () {
                    Get.to(() => ShowImageGalleryScreen(images: attachments));
                  },
                  child: CustomNetworkImgProvider(
                    imageUrl: attachments[i].url,
                    height: getDynamicHeight(100),
                    width: getDynamicHeight(100),
                    radius: 14,
                  ),
                );
              },
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemCount: attachments.length,
            ),
          );
  }
}
