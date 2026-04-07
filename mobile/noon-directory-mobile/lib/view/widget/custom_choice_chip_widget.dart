import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/app_colors.dart';

import '../../../core/constant/app_text_style.dart';

class CustomChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Function(bool) onSelected;

  const CustomChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const .symmetric(horizontal: 2),
      child: ChoiceChip(
        elevation: 0,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const .symmetric(horizontal: 10),
        label: Text(label.tr),
        selected: selected,
        selectedColor: AppColors.mainColor,
        onSelected: onSelected,
        showCheckmark: false,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: AppColors.blackColor.withValues(alpha: 0.12),
            width: 0.5,
          ),
          borderRadius: .circular(24),
        ),
        backgroundColor: Colors.transparent,
        labelStyle: AppTextStyles.bold12.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 10,
          color: selected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
