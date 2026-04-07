import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/homework_completed_controller.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/models/lesson_model.dart';
import 'package:noon/view/screen/show_images_screen.dart';
import 'package:noon/view/widget/bottomsheet_details_text.dart';
import 'package:noon/view/widget/images/custom_network_img_provider.dart';
import '../../../../../core/extensions/string_extension.dart';
import 'package:s_extensions/s_extensions.dart';
import 'package:noon/view/screen/pdf_viewer_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../controllers/global_controller.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../widget/bottom_sheet_container.dart';
import '../../../../widget/custom_appbar_v2.dart';

class StudentLessonsScreen extends StatelessWidget {
  StudentLessonsScreen({super.key});

  final controller = Get.find<HomeworkCompletedController>();
  final gController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    final lessons = Get.arguments['lessons'] as List<LessonModel>;

    return Scaffold(
      backgroundColor: AppColors.neutralBackground,
      appBar: CustomAppBarV2(
        appBarName: AppLanguage.lessons.tr,
        isLeading: true,
      ),
      body: Padding(
        padding: const .all(16),
        child: ListView.separated(
          itemCount: lessons.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: getDynamicHeight(16)),
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            return GestureDetector(
              onTap: () => Get.bottomSheet(
                LessonDetailsBottomSheet(lesson),
                isScrollControlled: true,
              ),
              child: Container(
                padding: const .all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: .circular(16),
                  border: .all(color: AppColors.gray300Color),
                ),
                child: LessonListItem(lesson),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LessonListItem extends StatelessWidget {
  const LessonListItem(this.lesson, {super.key});

  final LessonModel lesson;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Text(
          lesson.title,
          style: AppTextStyles.bold20.copyWith(
            color: AppColors.neutralDarkGrey,
          ),
        ),
        SizedBox(height: getDynamicHeight(8)),

        _TextBar(
          icon: AppAssets.icCalendarWithInArrow,
          title: AppLanguage.publicationDateStr.tr,
          value: lesson.createdAt.formatDateToYearMonthDay,
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
                  '${AppLanguage.lessonDetailsStr.tr}:',
                  style: AppTextStyles.regular16.copyWith(
                    color: AppColors.neutralMidGrey,
                  ),
                ),
              ],
            ),
            SizedBox(height: getDynamicHeight(4)),
            Text(
              lesson.content.replaceAll('\n', ' '),
              maxLines: 2,
              overflow: .ellipsis,
              style: AppTextStyles.regular16.copyWith(
                color: AppColors.neutralDarkGrey,
              ),
            ),
          ],
        ),

        if (lesson.lessonAttachment.isNotEmpty) ...[
          SizedBox(height: getDynamicHeight(12)),
          Row(
            children: [
              Text(
                '${lesson.lessonAttachment.length} ${AppLanguage.attachedPhotosStr.tr}',
                style: AppTextStyles.regular14.copyWith(
                  color: AppColors.neutralMidGrey,
                ),
              ),
              const Spacer(),
              Row(
                spacing: getDynamicWidth(4),
                children: [
                  ...lesson.lessonAttachment.take(3).map((e) {
                    final index = lesson.lessonAttachment.indexOf(e);
                    return GestureDetector(
                      onTap: () => Get.to(
                        () => ShowImageGalleryScreen(
                          img: lesson.lessonAttachment
                              .map((a) => a.url)
                              .toList(),
                          images: const [],
                          initialIndex: index,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: .circular(8),
                        child: CustomNetworkImgProvider(
                          imageUrl: e.url,
                          height: getDynamicHeight(48),
                          width: getDynamicWidth(48),
                          radius: 8,
                        ),
                      ),
                    );
                  }),
                  if (lesson.lessonAttachment.length > 3)
                    Container(
                      height: getDynamicHeight(48),
                      width: getDynamicWidth(48),
                      decoration: BoxDecoration(
                        color: AppColors.gray50Color,
                        borderRadius: .circular(8),
                        border: .all(color: AppColors.warningColor),
                      ),
                      alignment: .center,
                      child: Text(
                        '+${lesson.lessonAttachment.length - 3}',
                        style: AppTextStyles.bold16.copyWith(
                          color: AppColors.warningColor,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class LessonDetailsBottomSheet extends StatelessWidget {
  const LessonDetailsBottomSheet(this.lesson, {super.key});

  final LessonModel lesson;

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      child: SafeArea(
        child: Padding(
          padding: const .symmetric(vertical: 24, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                // ? drag handle
                Center(
                  child: Container(
                    width: getDynamicWidth(40),
                    height: getDynamicHeight(4),
                    decoration: BoxDecoration(
                      color: AppColors.gray500Color,
                      borderRadius: .circular(16),
                    ),
                  ),
                ),
                SizedBox(height: getDynamicHeight(24)),

                // ? lesson title
                Text(
                  lesson.title,
                  style: AppTextStyles.bold22.copyWith(
                    color: AppColors.neutralDarkGrey,
                  ),
                ),
                SizedBox(height: getDynamicHeight(24)),

                // ? publication date
                BottomsheetDetailsText(
                  icon: AppAssets.icCalendarWithInArrow,
                  title: AppLanguage.publicationDateStr.tr,
                  value: lesson.createdAt.formatDateToYearMonthDay,
                ),
                SizedBox(height: getDynamicHeight(24)),

                // ? attachments section
                _TitleText(
                  icon: Icons.image_outlined,
                  title:
                      '${AppLanguage.attachmentsStr.tr} (${lesson.lessonAttachment.length})',
                ),
                SizedBox(height: getDynamicHeight(8)),

                if (lesson.lessonAttachment.isNotEmpty)
                  Column(
                    children: [
                      Row(
                        spacing: getDynamicWidth(8),
                        children: [
                          ...lesson.lessonAttachment
                              .take(lesson.lessonAttachment.length > 3 ? 2 : 3)
                              .map((e) {
                                final isFile =
                                    e.url.split('/').last.split('.').last ==
                                    'pdf';
                                return Expanded(
                                  child: SizedBox(
                                    height: getDynamicHeight(156),
                                    width: getDynamicWidth(350),
                                    child: GestureDetector(
                                      onTap: () => isFile
                                          ? Get.to(
                                              () => PdfViewerScreen(
                                                pdfUrl: e.url.pdfUrlToFullUrl!,
                                                isLocalFile: false,
                                              ),
                                            )
                                          : Get.to(
                                              () => ShowImageGalleryScreen(
                                                img: lesson.lessonAttachment
                                                    .map((a) => a.url)
                                                    .toList(),
                                                images: const [],
                                                initialIndex: lesson
                                                    .lessonAttachment
                                                    .indexOf(e),
                                              ),
                                            ),
                                      child: CustomNetworkImgProvider(
                                        imageUrl: e.url,
                                        height: getDynamicHeight(
                                          lesson.lessonAttachment.length > 2
                                              ? 98
                                              : 138,
                                        ),
                                        width: 156,
                                        radius: 8,
                                        isFile: isFile,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          if (lesson.lessonAttachment.length > 3)
                            Expanded(
                              child: Container(
                                height: getDynamicHeight(156),
                                width: getDynamicWidth(350),
                                decoration: BoxDecoration(
                                  color: AppColors.neutralDarkGrey,
                                  borderRadius: .circular(14),
                                ),
                                alignment: .center,
                                child: Text(
                                  '+${lesson.lessonAttachment.length - 2}',
                                  style: AppTextStyles.bold18.copyWith(
                                    color: AppColors.neutralWhite,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                SizedBox(height: getDynamicHeight(24)),

                // ? description card
                _TitleText(
                  icon: Icons.description_outlined,
                  title: AppLanguage.lessonDetailsStr.tr,
                ),
                SizedBox(height: getDynamicHeight(8)),
                Container(
                  width: double.infinity,
                  padding: .all(getDynamicWidth(16)),
                  decoration: BoxDecoration(
                    color: AppColors.neutralWhite,
                    borderRadius: .circular(12),
                    border: .all(
                      color: AppColors.neutralDarkGrey.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Linkify(
                    text: lesson.content.isEmpty
                        ? "لا توجد تفاصيل"
                        : lesson.content,
                    style: AppTextStyles.medium16.copyWith(
                      color: AppColors.neutralDarkGrey,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.start,
                    onOpen: (link) => launchUrl(
                      Uri.parse(link.url),
                      mode: LaunchMode.externalApplication,
                    ),
                  ).width(.infinity),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TextBar extends StatelessWidget {
  const _TextBar({
    required this.icon,
    required this.title,
    required this.value,
  });

  final String icon, title, value;

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
        SizedBox(width: getDynamicWidth(8)),
        Expanded(
          child: Text(
            value,
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

class _TitleText extends StatelessWidget {
  const _TitleText({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.warningColor, size: 22),
        SizedBox(width: getDynamicWidth(8)),
        Text(
          title,
          style: AppTextStyles.medium16.copyWith(
            color: AppColors.neutralDarkGrey,
          ),
        ),
      ],
    );
  }
}
