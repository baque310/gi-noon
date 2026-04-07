import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/core/extensions/string_extension.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/view/screen/pdf_viewer_screen.dart';
import 'package:noon/view/screen/show_images_screen.dart';
import 'package:noon/view/widget/images/custom_network_img_provider.dart';
import '../../../../../../controllers/global_controller.dart';
import '../../../../../../controllers/homework_controller.dart';
import '../../../../../../core/constant/app_colors.dart';
import '../../../../../../core/constant/app_text_style.dart';
import '../../../../../../models/homework_model.dart';
import '../../../../../widget/homework_details_bottom_sheet.dart';
import '../../../../../widget/custom_appbar_v2.dart';

class StudentHomeworksScreen extends StatelessWidget {
  StudentHomeworksScreen({super.key});

  final controller = Get.find<HomeworkController>();
  final gController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    final homeworks = Get.arguments['homeworks'] as List<HomeworkModel>;

    return Scaffold(
      backgroundColor: AppColors.neutralBackground,
      appBar: CustomAppBarV2(
        appBarName: AppLanguage.homework.tr,
        isLeading: true,
      ),
      body: Padding(
        padding: const .all(16),
        child: ListView.separated(
          itemCount: homeworks.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: getDynamicHeight(16)),
          itemBuilder: (context, index) {
            final homework = homeworks[index];
            return GestureDetector(
              onTap: () => Get.bottomSheet(
                HomeworkDetailsBottomSheet(homework),
                isScrollControlled: true,
              ),
              child: Container(
                padding: const .all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: .circular(16),
                  border: .all(color: AppColors.gray300Color),
                ),
                child: HomeworkListItem(homework),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HomeworkListItem extends StatelessWidget {
  const HomeworkListItem(this.homework, {super.key});

  final HomeworkModel homework;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Text(
          homework.title,
          style: AppTextStyles.bold20.copyWith(
            color: AppColors.neutralDarkGrey,
          ),
        ),
        SizedBox(height: getDynamicHeight(8)),

        TextBar(
          icon: AppAssets.icCalendarWithInArrow,
          title: AppLanguage.publicationDateStr.tr,
          value: homework.createdAt.formatDateToYearMonthDay,
        ),
        SizedBox(height: getDynamicHeight(8)),

        TextBar(
          icon: AppAssets.icCalendarWithOutArrow,
          title: AppLanguage.getHomeworkDateStr.tr,
          value: homework.dueDate.formatDateToYearMonthDay,
        ),
        SizedBox(height: getDynamicHeight(8)),

        Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                SvgPicture.asset(AppAssets.icDetails),
                SizedBox(width: getDynamicWidth(8)),

                Text(
                  '${AppLanguage.homeworkDetailsStr.tr}:',
                  style: AppTextStyles.regular16.copyWith(
                    color: AppColors.neutralMidGrey,
                  ),
                ),
              ],
            ),
            SizedBox(height: getDynamicHeight(4)),

            Text(
              homework.content.replaceAll('\n', ' '),
              maxLines: 2,
              overflow: .ellipsis,
              style: AppTextStyles.regular16.copyWith(
                color: AppColors.neutralDarkGrey,
              ),
            ),
          ],
        ),
        SizedBox(height: getDynamicHeight(12)),

        if (homework.attachments.isNotEmpty)
          Row(
            children: [
              Text(
                '${homework.attachments.length} ${AppLanguage.attachedPhotosStr.tr}',
                style: AppTextStyles.regular14.copyWith(
                  color: AppColors.neutralMidGrey,
                ),
              ),
              const Spacer(),

              Row(
                spacing: getDynamicWidth(4),
                children: [
                  ...homework.attachments.take(3).map((attachment) {
                    final isFile =
                        attachment.url.split('/').last.split('.').last == 'pdf';
                    final index = homework.attachments.indexOf(attachment);
                    return GestureDetector(
                      onTap: () => isFile
                          ? Get.to(
                              () => PdfViewerScreen(
                                pdfUrl: attachment.url.pdfUrlToFullUrl!,
                                isLocalFile: false,
                              ),
                            )
                          : Get.to(
                              () => ShowImageGalleryScreen(
                                img: homework.attachments
                                    .map((a) => a.url)
                                    .toList(),
                                images: const [],
                                initialIndex: index,
                              ),
                            ),
                      child: ClipRRect(
                        borderRadius: .circular(8),
                        child: CustomNetworkImgProvider(
                          imageUrl: attachment.url,
                          height: getDynamicHeight(48),
                          width: getDynamicWidth(48),
                          radius: 8,
                          isFile: isFile,
                        ),
                      ),
                    );
                  }),
                  if (homework.attachments.length > 3)
                    Container(
                      height: getDynamicHeight(48),
                      width: getDynamicWidth(48),
                      decoration: BoxDecoration(
                        color: AppColors.gray50Color,
                        borderRadius: .circular(8),
                        border: .all(color: AppColors.mainColor),
                      ),
                      alignment: .center,
                      child: Text(
                        '+${homework.attachments.length - 3}',
                        style: AppTextStyles.bold16.copyWith(
                          color: AppColors.mainColor,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}

class TextBar extends StatelessWidget {
  const TextBar({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.maxLines = 1,
  });

  final String icon, title, value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(icon),
        SizedBox(width: getDynamicWidth(8)),

        Text(
          '$title:',
          style: AppTextStyles.regular16.copyWith(
            color: AppColors.neutralMidGrey,
          ),
        ),
        SizedBox(height: getDynamicWidth(8)),

        Expanded(
          child: Text(
            value,
            maxLines: maxLines,
            overflow: .ellipsis,
            style: AppTextStyles.regular16.copyWith(
              color: AppColors.neutralDarkGrey,
            ),
          ),
        ),
      ],
    );
  }
}
