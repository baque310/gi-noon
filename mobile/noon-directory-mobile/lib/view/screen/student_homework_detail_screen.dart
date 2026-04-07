import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/core/extensions/string_extension.dart';
import 'package:noon/core/file_helper.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/models/attachment_model.dart';
import 'package:noon/view/widget/images/custom_network_image.dart';
import 'package:noon/view/widget/simple_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/homework_controller.dart';
import '../../core/constant/app_colors.dart';
import '../../core/constant/app_text_style.dart';
import '../../models/homework_model.dart';
import '../widget/custom_appbar.dart';

class StudentHomeworkDetailScreen extends StatelessWidget {
  StudentHomeworkDetailScreen({super.key});

  final controller = Get.find<HomeworkController>();

  @override
  Widget build(BuildContext context) {
    final homework = Get.arguments['homework'] as HomeworkModel;

    final subTitleStyle = AppTextStyles.textMedium14.copyWith(
      color: AppTextStyles.textMedium14.color!.withValues(alpha: 0.60),
    );

    return Scaffold(
      appBar: CustomAppBar(
        appBarName: AppLanguage.detailsStr.tr,
        isLeading: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        children: [
          Text(
            "${AppLanguage.titleHomeworkStr.tr}: ${homework.title}",
            style: AppTextStyles.textMedium16.copyWith(
              color: AppTextStyles.textMedium16.color!.withValues(alpha: 0.87),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "${AppLanguage.subjectStr.tr}: ${homework.teacherSubject.stageSubject?.subject?.name ?? ''}",
            style: subTitleStyle,
          ),
          const SizedBox(height: 6),
          Text(
            "${AppLanguage.publicationDateStr.tr}: ${homework.createdAt.formatDateToYearMonthDay}",
            style: subTitleStyle,
          ),
          const SizedBox(height: 6),
          Text(
            "${AppLanguage.getHomeworkDateStr.tr}: ${homework.dueDate.formatDateToYearMonthDay}",
            style: subTitleStyle,
          ),
          const SizedBox(height: 12),
          Text(
            "${AppLanguage.homeworkDetailsStr.tr} :",
            style: AppTextStyles.textMedium14.copyWith(
              color: AppColors.mainColor,
            ),
          ),
          const SizedBox(height: 6),
          Linkify(
            onOpen: (link) => launchUrl(
              Uri.parse(link.url),
              mode: LaunchMode.externalApplication,
            ),
            text: homework.content,
            style: subTitleStyle,
          ),
          const SizedBox(height: 12),
          Text(
            "${AppLanguage.attachments.tr} :",
            style: AppTextStyles.textMedium14.copyWith(
              color: AppColors.mainColor,
            ),
          ),
          const SizedBox(height: 6),
          HomeworkAttachments(attachments: homework.attachments.toList()),
        ],
      ),
    );
  }
}

class HomeworkAttachments extends StatelessWidget {
  HomeworkAttachments({super.key, required this.attachments});

  final controller = Get.find<HomeworkController>();
  final List<AttachmentModel> attachments;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, i) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomNetworkImage(
              imageUrl: attachments[i].url,
              height: 96,
              width: 96,
              radius: BorderRadius.circular(10),
            ),
            SimpleButton(
              label: AppLanguage.downloadFileStr.tr,
              isOutlined: true,
              height: 40,
              width: 72,
              onPressed: () => FileHelper.downloadFile(
                url: attachments[i].url.imgUrlToFullUrl ?? '',
                name: attachments[i].id,
              ),
            ),
          ],
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: 6),
      itemCount: attachments.length,
    );
  }
}
