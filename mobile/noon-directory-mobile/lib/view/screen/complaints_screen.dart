import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/core/extensions/date_extension.dart';

import '../../controllers/complaints_controller.dart';
import '../../core/constant/app_colors.dart';
import '../../core/constant/app_text_style.dart';
import '../../core/localization/language.dart';
import '../widget/custom_appbar.dart';
import '../widget/error_message.dart';
import '../widget/loading.dart';
import '../widget/no_data_widget.dart';

class ComplaintsScreen extends StatelessWidget {
  ComplaintsScreen({super.key});

  final controller = Get.find<ComplaintsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarName: AppLanguage.complaints.tr,
        isLeading: true,
      ),
      body: controller.obx(
        (complaints) => ListView.separated(
          padding: const .symmetric(horizontal: 16, vertical: 24),
          itemCount: complaints?.length ?? 0,
          itemBuilder: (context, index) {
            final complaint = complaints![index];
            return ComplaintCard(
              title: complaint.title,
              subtitle: complaint.description,
              dateStr:
                  '${AppLanguage.date.tr} '
                  '${complaint.createdAt.formatDateToYearMonthDay}',
              status: complaint.status,
            );
          },
          separatorBuilder: (_, _) => const SizedBox(height: 8),
        ),
        onError: (e) =>
            ErrorMessage(press: () => controller.getComplaints(), errorMsg: e),
        onLoading: const Center(child: Loading()),
        onEmpty: NoDataWidget(title: AppLanguage.noInfoAvailable.tr),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(ScreensUrls.addComplaintsScreenUrl),
        backgroundColor: AppColors.mainColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ComplaintCard extends StatelessWidget {
  const ComplaintCard({
    super.key,
    required this.title,
    this.subtitle,
    this.status,
    this.dateStr,
  });

  final String title;
  final String? subtitle;
  final String? status;
  final String? dateStr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(16),
        border: .all(color: AppColors.gray200Color, width: 0.5),
      ),
      child: ListTile(
        contentPadding: .zero,
        minVerticalPadding: 0,
        title: Text(title, style: AppTextStyles.semiBold14),
        subtitle: Column(
          crossAxisAlignment: .start,
          children: [
            const SizedBox(height: 6),
            subtitle != null
                ? Text(
                    subtitle!,
                    style: AppTextStyles.regular14,
                    maxLines: 2,
                    overflow: .ellipsis,
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 4),
            dateStr != null
                ? Text(dateStr!, style: AppTextStyles.regular12)
                : const SizedBox.shrink(),
          ],
        ),
        trailing: status != null ? StatusChip(status: status!) : null,
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (title, textColor, bgColor, borderColor) = _getChipStyle;

    return Padding(
      padding: const .only(left: 4),
      child: Chip(
        side: BorderSide(color: borderColor),
        label: Text(title),
        labelStyle: TextStyle(color: textColor),
        backgroundColor: bgColor,
      ),
    );
  }

  (String title, Color textColor, Color bgColor, Color borderColor)
  get _getChipStyle {
    if (status == 'pending') {
      return (
        AppLanguage.pending.tr,
        AppColors.yellow500Color,
        AppColors.yellow50Color,
        AppColors.yellow500Color,
      );
    }

    if (status == 'approved') {
      return (
        AppLanguage.approved.tr,
        AppColors.mainColor,
        AppColors.green50,
        AppColors.mainColor,
      );
    }

    return (
      AppLanguage.rejected.tr,
      AppColors.redColor,
      AppColors.redColor.withAlpha(80),
      AppColors.redColor,
    );
  }
}
