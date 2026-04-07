import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controllers/global_controller.dart';
import '../../core/constant/app_assets.dart';
import '../../core/constant/app_colors.dart';
import '../../core/constant/app_sizes.dart';
import '../../core/constant/app_text_style.dart';
import '../../models/homework_subject_model.dart';

class HomeworkSubjectCardWidget extends StatelessWidget {
  HomeworkSubjectCardWidget({
    super.key,
    required this.subject,
    this.onPressed,
    this.onEditPressed,
    this.onPressedDelete,
    this.borderColor,
  });

  final HomeworkSubjectModel subject;
  final VoidCallback? onPressed;
  final Function()? onEditPressed;
  final Function()? onPressedDelete;
  final Color? borderColor;

  final gController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const .symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.neutralWhite,
          borderRadius: .circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: .all(8),
              decoration: BoxDecoration(
                color: AppColors.mainColor.withValues(alpha: 0.1),
                borderRadius: .circular(12),
              ),
              child: getSubjectIcon(subject.subjectName).endsWith('.svg')
                  ? SvgPicture.asset(
                      getSubjectIcon(subject.subjectName),
                      colorFilter: ColorFilter.mode(
                        AppColors.mainColor,
                        .srcIn,
                      ),
                      width: 30,
                    )
                  : Image.asset(
                      getSubjectIcon(subject.subjectName),
                      color: AppColors.mainColor,
                      width: 30,
                    ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    subject.subjectName ?? '',
                    style: AppTextStyles.medium16.copyWith(
                      color: AppColors.neutralDarkGrey,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    '${subject.homeworkCount} واجبات',
                    style: AppTextStyles.regular14.copyWith(
                      color: AppColors.neutralMidGrey,
                    ),
                  ),
                ],
              ),
            ),

            InkWell(
              borderRadius: .circular(getDynamicHeight(12)),
              onTap: onPressed,
              child: Container(
                height: getDynamicHeight(32),
                width: getDynamicHeight(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: .circular(getDynamicHeight(12)),
                  border: .all(color: AppColors.neutralLightGrey),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    gController.isLtr
                        ? AppAssets.icBackCircle
                        : AppAssets.icArrowLeftV2,
                    height: getDynamicHeight(16),
                    width: getDynamicWidth(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getSubjectIcon(String? subjectName) {
    if (subjectName == null) return AppAssets.icHomeworkV2;
    final name = subjectName.toLowerCase();
    if (name.contains('arabic') || name.contains('عربي')) {
      return AppAssets.icArabic;
    } else if (name.contains('biology') || name.contains('أحياء')) {
      return AppAssets.icBiology;
    } else if (name.contains('chemistry') || name.contains('كيمياء')) {
      return AppAssets.icChemistry;
    } else if (name.contains('english') ||
        name.contains('إنجليزي') ||
        name.contains('انجليزي')) {
      return AppAssets.icEnglish;
    } else if (name.contains('french') || name.contains('فرنسي')) {
      return AppAssets.icFrench;
    } else if (name.contains('kurdish') || name.contains('كردي')) {
      return AppAssets.icKurdish;
    } else if (name.contains('math') || name.contains('رياضيات')) {
      return AppAssets.icMath;
    } else if (name.contains('physics') || name.contains('فيزياء')) {
      return AppAssets.icPhysics;
    } else if (name.contains('social') || name.contains('اجتماع')) {
      return AppAssets.icSocialStudies;
    } else if (name.contains('science') || name.contains('علوم')) {
      return AppAssets.icScience;
    } else if (name.contains('islamic') || name.contains('سلامية')) {
      return AppAssets.icIslamic;
    }
    return AppAssets.icHomeworkV2;
  }
}
