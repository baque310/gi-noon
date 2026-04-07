import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../controllers/homework_completed_controller.dart';
import '../../../../../../../core/constant/app_sizes.dart';
import '../../../../../../../core/constant/app_text_style.dart';
import '../../../../../../../core/localization/language.dart';

class TitleContentLessonWidget extends StatelessWidget {
  const TitleContentLessonWidget({super.key, this.maxLine});
  final int? maxLine;

  @override
  Widget build(BuildContext context) {
    HomeworkCompletedController controller = Get.find();
    return Column(
      crossAxisAlignment: .start,
      children: [
        TextFormField(
          onChanged: (value) => controller.title.value = value,
          controller: controller.titleController,
          decoration: InputDecoration(
            fillColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF1A202C).withValues(alpha: 0.12),
              ),
              borderRadius: .circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF1A202C).withValues(alpha: 0.12),
              ),
              borderRadius: .circular(12),
            ),
            hintText: AppLanguage.titleLessonStr.tr,
            hintStyle: AppTextStyles.medium14.copyWith(
              color: AppTextStyles.medium14.color!.withValues(alpha: 0.60),
            ),
          ),
        ),
        SizedBox(height: getDynamicHeight(20)),
        TextFormField(
          onChanged: (value) => controller.description.value = value,
          controller: controller.descController,
          maxLines: maxLine ?? 4,
          decoration: InputDecoration(
            fillColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF1A202C).withValues(alpha: 0.12),
              ),
              borderRadius: .circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF1A202C).withValues(alpha: 0.12),
              ),
              borderRadius: .circular(12),
            ),
            hintText: AppLanguage.lessonDetailsStr.tr,
            hintStyle: AppTextStyles.medium14.copyWith(
              color: AppTextStyles.medium14.color!.withValues(alpha: 0.60),
            ),
          ),
        ),
        SizedBox(height: getDynamicHeight(20)),
      ],
    );
  }
}
