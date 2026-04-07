// [تحديث المستمسكات]: تم الانتقال لنظام الخانتين (Front & Back) لكل مستمسك يتطلب وجهين.
// تم تعديل منطق العرض ليكون لكل وجه كرت خاص به بدلاً من عرض صورة واحدة فقط.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/attachments_controller.dart';
import 'package:noon/models/attachment_type_model.dart';
import 'package:noon/models/user_attachment_model.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/extensions/string_extension.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/view/screen/show_images_screen.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:s_extensions/s_extensions.dart';

class AttachmentsScreen extends StatelessWidget {
  const AttachmentsScreen({super.key});

  Map<String, List<AttachmentTypeModel>> _groupTypes(
    List<AttachmentTypeModel> types,
  ) {
    final Map<String, List<AttachmentTypeModel>> groups = {
      "الوثائق الشخصية": [],
      "الوثائق الدراسية": [],
      "الوثائق الصحية": [],
      "أخرى": [],
    };

    for (var t in types) {
      final category = t.category;
      if (category == 'Personal') {
        groups["الوثائق الشخصية"]!.add(t);
      } else if (category == 'Academic') {
        groups["الوثائق الدراسية"]!.add(t);
      } else if (category == 'Health') {
        groups["الوثائق الصحية"]!.add(t);
      } else if (category == 'Other') {
        groups["أخرى"]!.add(t);
      } else {
        // Falling back to heuristic if category is missing or unknown
        final title = t.title;
        if (title.contains('هوية') ||
            title.contains('بطاقة') ||
            title.contains('مسكن') ||
            title.contains('ميلاد') ||
            title.contains('أحوال') ||
            title.contains('وطنية')) {
          groups["الوثائق الشخصية"]!.add(t);
        } else if (title.contains('وثيقة') ||
            title.contains('تخرج') ||
            title.contains('نجاح') ||
            title.contains('درجات') ||
            title.contains('دراسية')) {
          groups["الوثائق الدراسية"]!.add(t);
        } else if (title.contains('طبية') ||
            title.contains('صحية') ||
            title.contains('دم') ||
            title.contains('فحص') ||
            title.contains('صحة')) {
          groups["الوثائق الصحية"]!.add(t);
        } else {
          groups["أخرى"]!.add(t);
        }
      }
    }
    groups.removeWhere((key, value) => value.isEmpty);
    return groups;
  }

  IconData _getGroupIcon(String groupName) {
    switch (groupName) {
      case "الوثائق الشخصية":
        return Icons.badge_rounded;
      case "الوثائق الدراسية":
        return Icons.school_rounded;
      case "الوثائق الصحية":
        return Icons.local_hospital_rounded;
      default:
        return Icons.folder_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AttachmentsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: CustomAppBar(
        appBarName: AppLanguage.attachmentsStr.tr,
        isLeading: true,
      ),
      body: Obx(() {
        if (controller.loading.value && controller.attachmentTypes.isEmpty) {
          return const Loading().center();
        }

        if (controller.attachmentTypes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_open_outlined,
                  size: 60,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  "لا توجد مرفقات مطلوبة حالياً",
                  style: AppTextStyles.bold16.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        final grouped = _groupTypes(controller.attachmentTypes);
        final totalRequired = controller.attachmentTypes.fold<int>(
          0,
          (sum, item) => sum + (item.numberOfSides ?? 1),
        );

        // Count uploaded sides
        int totalUploadedSides = 0;
        for (var att in controller.attachments) {
          if (att.urlFace != null) totalUploadedSides++;
          if (att.urlBack != null) totalUploadedSides++;
        }

        final progress = totalRequired > 0
            ? (totalUploadedSides / totalRequired)
            : 0.0;

        return RefreshIndicator(
          onRefresh: () async {
            await controller.getAttachmentTypes();
            await controller.getAttachments();
          },
          child: CustomScrollView(
            slivers: [
              // --- Header Summary ---
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF147A6B), Color(0xFF0F5B50)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF147A6B).withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "مستوى الإكمال",
                                style: AppTextStyles.medium14.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                              Text(
                                "${(progress * 100).toInt()}% مكتمل",
                                style: AppTextStyles.bold24.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              color: Colors.yellow.shade400,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white.withValues(alpha: 0.15),
                          color: Colors.white,
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "تم رفع $totalUploadedSides من أصل $totalRequired وجه مطلوب",
                        style: AppTextStyles.medium12.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- Sections ---
              ...grouped.entries.map((entry) {
                // Expand types to sides
                final List<_DisplayItem> items = [];
                for (var t in entry.value) {
                  if (t.numberOfSides == 2) {
                    items.add(
                      _DisplayItem(
                        type: t,
                        isBack: false,
                        sideTitle: "(وجه أمامي)",
                      ),
                    );
                    items.add(
                      _DisplayItem(
                        type: t,
                        isBack: true,
                        sideTitle: "(وجه خلفي)",
                      ),
                    );
                  } else {
                    items.add(
                      _DisplayItem(type: t, isBack: false, sideTitle: ""),
                    );
                  }
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _getGroupIcon(entry.key),
                              size: 20,
                              color: const Color(0xFF147A6B),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              entry.key,
                              style: AppTextStyles.bold18.copyWith(
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                                childAspectRatio: 0.78,
                              ),
                          itemCount: items.length,
                          itemBuilder: (context, idx) {
                            final item = items[idx];
                            final type = item.type;
                            final UserAttachmentModel? attachment = controller
                                .attachments
                                .firstWhereOrNull(
                                  (a) =>
                                      a.attType?.id == type.id ||
                                      a.attTypeId == type.id,
                                );

                            // Determine status for this specific side
                            String status = 'none';
                            String? url;
                            if (attachment != null) {
                              url = item.isBack
                                  ? attachment.urlBack
                                  : attachment.urlFace;
                              if (url != null) {
                                status =
                                    attachment.approvalStatus?.toLowerCase() ??
                                    'none';
                              }
                            }

                            return _DocumentCard(
                              type: type,
                              sideTitle: item.sideTitle,
                              url: url,
                              attachment: attachment,
                              status: status,
                              onAction: () {
                                if (status == 'none' || status == 'rejected') {
                                  controller.showImageSourceBottomSheetForSide(
                                    typeId: type.id ?? '',
                                    isFront: !item.isBack,
                                    attachmentId: attachment?.id,
                                  );
                                } else {
                                  if (url != null) {
                                    Get.to(
                                      () => ShowImageGalleryScreen(
                                        img: [url!],
                                        images: const [],
                                        initialIndex: 0,
                                      ),
                                    );
                                  }
                                }
                              },
                              onDelete: (attachment != null && url != null)
                                  ? () => controller.deleteAttachment(
                                      attachment.id,
                                    )
                                  : null,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}

class _DisplayItem {
  final AttachmentTypeModel type;
  final bool isBack;
  final String sideTitle;

  _DisplayItem({
    required this.type,
    required this.isBack,
    required this.sideTitle,
  });
}

class _DocumentCard extends StatelessWidget {
  final AttachmentTypeModel type;
  final String sideTitle;
  final String? url;
  final dynamic attachment;
  final String status;
  final VoidCallback onAction;
  final VoidCallback? onDelete;

  const _DocumentCard({
    required this.type,
    required this.sideTitle,
    this.url,
    this.attachment,
    required this.status,
    required this.onAction,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey.shade400;
    String statusText = "مطلوب";
    IconData statusIcon = Icons.add_rounded;

    if (status == 'pending') {
      statusColor = Colors.amber.shade600;
      statusText = "قيد المراجعة";
      statusIcon = Icons.history_rounded;
    } else if (status == 'approved') {
      statusColor = Colors.green.shade600;
      statusText = "تم القبول";
      statusIcon = Icons.check_circle_rounded;
    } else if (status == 'rejected') {
      statusColor = Colors.red.shade600;
      statusText = "تم الرفض";
      statusIcon = Icons.error_outline_rounded;
    }

    return GestureDetector(
      onTap: onAction,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: status == 'none'
                ? Colors.transparent
                : statusColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Preview Image Area
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: url != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.network(
                                url!.imgUrlToFullUrl ?? '',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                      Icons.image_not_supported_rounded,
                                      color: Colors.grey.shade400,
                                      size: 40,
                                    ),
                              ),
                            )
                          : Icon(
                              Icons.file_upload_outlined,
                              color: Colors.grey.shade300,
                              size: 40,
                            ),
                    ),
                  ),

                  // Status Badge on top of image
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(statusIcon, color: statusColor, size: 16),
                    ),
                  ),

                  // Delete button
                  if (onDelete != null && status != 'approved')
                    Positioned(
                      top: 14,
                      left: 14,
                      child: GestureDetector(
                        onTap: onDelete,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content Area
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 2, 14, 14),
              child: Column(
                children: [
                  Text(
                    "${type.title} $sideTitle",
                    style: AppTextStyles.bold12.copyWith(
                      color: const Color(0xFF1E293B),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusText,
                      style: AppTextStyles.semiBold10.copyWith(
                        color: statusColor,
                      ),
                    ),
                  ),

                  if (status == 'rejected' &&
                      attachment?.approvalReason != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        attachment.approvalReason!,
                        style: AppTextStyles.medium10.copyWith(
                          color: Colors.red,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
