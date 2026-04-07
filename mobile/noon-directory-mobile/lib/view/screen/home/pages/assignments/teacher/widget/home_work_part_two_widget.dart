import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../controllers/homework_controller.dart';
import '../../../../../../../core/constant/app_sizes.dart';
import '../../../../../../../core/constant/app_text_style.dart';
import '../../../../../../../core/localization/language.dart';
import '../../../../../attendances/widgets/datepicker_widget.dart';

class HomeWorkPartTwoWidget extends StatelessWidget {
  const HomeWorkPartTwoWidget({super.key, this.maxLine});

  final int? maxLine;

  @override
  Widget build(BuildContext context) {
    HomeworkController controller = Get.find();

    return Obx(() {
      return Column(
        children: [
          DatepickerWidget(
            isShowSearchIcon: false,
            iconColor: Colors.teal,
            textStyle: AppTextStyles.medium14.copyWith(
              color: AppTextStyles.medium14.color!.withValues(alpha: 0.60),
            ),
            onTap: () => controller.pickDate(),
            text: controller.selectedDate.value,
          ),
          SizedBox(height: getDynamicHeight(20)),
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
              hintText: AppLanguage.titleHomeworkStr.tr,
              hintStyle: AppTextStyles.medium14.copyWith(
                color: AppTextStyles.medium14.color!.withValues(alpha: 0.60),
              ),
            ),
          ),
          SizedBox(height: getDynamicHeight(20)),
          TextFormField(
            onChanged: (value) => controller.description.value = value,
            controller: controller.descController,
            maxLines: (maxLine) ?? 4,
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
              hintText: AppLanguage.homeworkDetailsStr.tr,
              hintStyle: AppTextStyles.medium14.copyWith(
                color: AppTextStyles.medium14.color!.withValues(alpha: 0.60),
              ),
            ),
          ),
          SizedBox(height: getDynamicHeight(20)),
        ],
      );
    });
  }
}
