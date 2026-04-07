import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/view/widget/bottom_sheet_container.dart';
import 'package:noon/view/widget/bottom_sheet_drag.dart';
import 'package:noon/view/widget/color_button.dart';

class LanguageSelectorBS extends StatelessWidget {
  LanguageSelectorBS({super.key});

  final controller = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: .stretch,
          mainAxisSize: .min,
          children: [
            // drag handle
            const BottomSheetDragHandle(),

            GetX<GlobalController>(
              builder: (controller) {
                return RadioGroup<int>(
                  groupValue: controller.selectedLanguageIndex.value,
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedLanguageIndex.value = value;
                    }
                  },
                  child: Column(
                    children: [LanguageItem(value: 0), LanguageItem(value: 1)],
                  ),
                );
              },
            ),

            // space
            const SizedBox(height: 16),

            // button
            ColorButton(
              text: AppLanguage.saveStr.tr,
              press: () {
                controller.setLanguage();
                Get.close(1);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageItem extends StatelessWidget {
  LanguageItem({super.key, required this.value});

  final int value;

  final controller = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Material(
        color: Colors.transparent,
        clipBehavior: .antiAlias,
        child: RadioListTile(
          value: value,
          overlayColor: const WidgetStatePropertyAll(Colors.red),
          selectedTileColor: Colors.green,
          title: Text(
            value == 0 ? AppLanguage.arabic.tr : AppLanguage.english.tr,
          ),
          fillColor: .fromMap({
            WidgetState.selected: AppColors.mainColor,
            WidgetState.hovered: AppColors.mainColor,
            WidgetState.any: AppColors.mainColor.withValues(alpha: .37),
          }),
          contentPadding: const .symmetric(horizontal: 12),
          controlAffinity: .trailing,
          visualDensity: .compact,
          dense: false,
        ),
      ),
    );
  }
}
