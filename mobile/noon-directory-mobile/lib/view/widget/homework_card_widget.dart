import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constant/app_colors.dart';
import '../../core/constant/app_text_style.dart';
import '../../core/localization/language.dart';
import '../../models/homework_model.dart';

class HomeworkCard extends StatelessWidget {
  const HomeworkCard({
    super.key,
    required this.homework,
    this.onPressed,
    this.onEditPressed,
    this.onPressedDelete,
    this.borderColor,
  });

  final HomeworkModel homework;
  final VoidCallback? onPressed;
  final Function()? onEditPressed;
  final Function()? onPressedDelete;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final subTitleStyle = AppTextStyles.medium14.copyWith(
      color: AppTextStyles.medium14.color!.withValues(alpha: 0.60),
    );
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const .all(14),
        margin: const .only(left: 16, right: 16, top: 16),
        decoration: BoxDecoration(
          borderRadius: .circular(16),
          border: .all(
            color: borderColor ?? AppColors.blackColor.withValues(alpha: 0.12),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          crossAxisAlignment: .start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    homework.title,
                    style: AppTextStyles.medium16.copyWith(
                      color: AppTextStyles.medium16.color!.withValues(
                        alpha: 0.87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${AppLanguage.subjectStr.tr}: ${homework.teacherSubject.stageSubject?.subject?.name ?? ''}",
                    style: subTitleStyle,
                  ),
                  Text(
                    "${AppLanguage.publicationDateStr.tr}: ${homework.createdAt.formatDateToYearMonthDay}",
                    style: subTitleStyle,
                  ),
                  Text(
                    "${AppLanguage.getHomeworkDateStr.tr}: ${homework.dueDate.formatDateToYearMonthDay}",
                    style: subTitleStyle,
                  ),
                  Text(
                    "${AppLanguage.homeworkDetailsStr.tr} :",
                    style: AppTextStyles.medium14.copyWith(
                      color: AppColors.mainColor,
                    ),
                  ),
                  Linkify(
                    text: homework.content,
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
              mainAxisAlignment: .spaceBetween,
              children: [
                if (onEditPressed != null)
                  OutlinedButton(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(borderRadius: .circular(32)),
                      ),
                    ),
                    onPressed: onEditPressed,
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
                        RoundedRectangleBorder(borderRadius: .circular(32)),
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
      ),
    );
  }
}
