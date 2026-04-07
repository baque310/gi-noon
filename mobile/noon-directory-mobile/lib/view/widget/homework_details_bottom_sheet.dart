import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/core/extensions/string_extension.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/view/screen/pdf_viewer_screen.dart';
import 'package:noon/view/screen/show_images_screen.dart';
import 'package:noon/view/widget/images/custom_network_img_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constant/app_colors.dart';
import '../../core/constant/app_text_style.dart';
import '../../models/homework_model.dart';
import '../../controllers/global_controller.dart';
import '../../controllers/homework_controller.dart';
import 'bottom_sheet_container.dart';

class HomeworkDetailsBottomSheet extends StatefulWidget {
  final HomeworkModel homework;
  const HomeworkDetailsBottomSheet(this.homework, {super.key});

  @override
  State<HomeworkDetailsBottomSheet> createState() =>
      _HomeworkDetailsBottomSheetState();
}

class _HomeworkDetailsBottomSheetState
    extends State<HomeworkDetailsBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ? drag handler
                Center(
                  child: Container(
                    width: getDynamicWidth(40),
                    height: getDynamicHeight(4),
                    decoration: BoxDecoration(
                      color: AppColors.gray500Color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                SizedBox(height: getDynamicHeight(24)),

                // ? homework name
                Text(
                  widget.homework.title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bold24.copyWith(
                    color: const Color(0xff2A3336),
                  ),
                ),
                SizedBox(height: getDynamicHeight(6)),

                // ? subject / subtitle
                if (widget.homework.teacherSubject.stageSubject?.subject?.name != null) ...[
                  Text(
                    widget.homework.teacherSubject.stageSubject!.subject!.name ?? '',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.medium14.copyWith(
                      color: const Color(0xff7A7A7A),
                    ),
                  ),
                  SizedBox(height: getDynamicHeight(24)),
                ] else
                  SizedBox(height: getDynamicHeight(16)),

                // ? dates row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: getDynamicHeight(16)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(getDynamicWidth(10)),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF3EDFD),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.event_note, color: AppColors.primary, size: 24),
                            ),
                            SizedBox(height: getDynamicHeight(12)),
                            Text(
                              AppLanguage.publicationDateStr.tr,
                              style: AppTextStyles.medium14.copyWith(color: const Color(0xff7A7A7A)),
                            ),
                            SizedBox(height: getDynamicHeight(8)),
                            Text(
                              widget.homework.createdAt.formatDateToYearMonthDay,
                              style: AppTextStyles.bold16.copyWith(color: const Color(0xff2A3336)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: getDynamicWidth(16)),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: getDynamicHeight(16)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(getDynamicWidth(10)),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFDE8E9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.event_busy, color: Color(0xFFE44F4F), size: 24),
                            ),
                            SizedBox(height: getDynamicHeight(12)),
                            Text(
                              AppLanguage.getHomeworkDateStr.tr,
                              style: AppTextStyles.medium14.copyWith(color: const Color(0xff7A7A7A)),
                            ),
                            SizedBox(height: getDynamicHeight(8)),
                            Text(
                              widget.homework.dueDate.formatDateToYearMonthDay,
                              style: AppTextStyles.bold16.copyWith(color: const Color(0xff2A3336)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getDynamicHeight(32)),

                // ? homework description title
                Text(
                  AppLanguage.homeworkDetailsStr.tr,
                  style: AppTextStyles.bold18.copyWith(color: const Color(0xff2A3336)),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: getDynamicHeight(12)),

                // ? homework description content container
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(getDynamicWidth(20)),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Linkify(
                    text: widget.homework.content.isEmpty
                        ? "لا توجد تفاصيل"
                        : widget.homework.content,
                    style: AppTextStyles.medium16.copyWith(
                      color: const Color(0xff2A3336),
                      height: 1.8,
                    ),
                    textAlign: TextAlign.start,
                    onOpen: (link) => launchUrl(
                      Uri.parse(link.url),
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
                ),
                SizedBox(height: getDynamicHeight(32)),

                // ? homework attachments title
                if (widget.homework.attachments.isNotEmpty) ...[
                  Text(
                    AppLanguage.attachmentsStr.tr,
                    style: AppTextStyles.bold18.copyWith(color: const Color(0xff2A3336)),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: getDynamicHeight(12)),
                  
                  // ? attachments list
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.homework.attachments.length,
                    separatorBuilder: (context, index) => SizedBox(height: getDynamicHeight(12)),
                    itemBuilder: (context, index) {
                      final attachment = widget.homework.attachments[index];
                      final isFile = attachment.url.split('/').last.split('.').last.toLowerCase() == 'pdf';
                      final fileName = Uri.decodeFull(attachment.url.split('/').last);

                      return GestureDetector(
                        onTap: () => isFile
                            ? Get.to(
                                () => PdfViewerScreen(
                                  pdfUrl: attachment.url.pdfUrlToFullUrl!,
                                  isLocalFile: false,
                                ),
                              )
                            : Get.to(
                                () => ShowImageGalleryScreen(
                                  img: widget.homework.attachments.map((a) => a.url).toList(),
                                  images: const [],
                                  initialIndex: index,
                                ),
                              ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: getDynamicWidth(16), vertical: getDynamicHeight(12)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.download_rounded, color: Color(0xff2A3336)),
                              SizedBox(width: getDynamicWidth(16)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fileName,
                                      style: AppTextStyles.bold16.copyWith(color: const Color(0xff2A3336)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: getDynamicHeight(4)),
                                    Text(
                                      isFile ? "ملف PDF" : "مرفق",
                                      style: AppTextStyles.medium12.copyWith(color: const Color(0xff7A7A7A)),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: getDynamicWidth(12)),
                              CustomNetworkImgProvider(
                                imageUrl: attachment.url,
                                height: getDynamicHeight(50),
                                width: getDynamicWidth(50),
                                radius: 12,
                                isFile: isFile,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: getDynamicHeight(32)),
                ],

                // ? Mark as complete button (For student and parent)
                if (Get.find<GlobalController>().isStudent || Get.find<GlobalController>().isParent)
                  Obx(() {
                    final controller = Get.put(HomeworkController());
                    // Always read reactive variables so GetX detects them
                    final isLoading = controller.loading.value;
                    final completedIds = controller.completedHomeworkIds.toList();
                    
                    final isCompleted = (widget.homework.studentHomeworks?.any((sh) => sh.homeworkStatus == 'Completed') ?? false) ||
                                        completedIds.contains(widget.homework.id);

                    if (isCompleted) {
                      return ElevatedButton.icon(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green300,
                          disabledBackgroundColor: AppColors.green300,
                          disabledForegroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: getDynamicHeight(16)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 24),
                        label: Text(
                          "اكتمل الواجب",
                          style: AppTextStyles.bold18.copyWith(color: Colors.white),
                        ),
                      );
                    } else {
                      return OutlinedButton.icon(
                        onPressed: isLoading ? null : () {
                          Get.dialog(
                            Dialog(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: getDynamicWidth(24), vertical: getDynamicHeight(32)),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.12),
                                      blurRadius: 30,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Icon
                                    Container(
                                      width: getDynamicWidth(72),
                                      height: getDynamicHeight(72),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primary.withValues(alpha: 0.1),
                                            AppColors.primary.withValues(alpha: 0.05),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.assignment_turned_in_outlined,
                                        color: AppColors.primary,
                                        size: 36,
                                      ),
                                    ),
                                    SizedBox(height: getDynamicHeight(20)),
                                    // Title
                                    Text(
                                      "تأكيد إكمال الواجب",
                                      style: AppTextStyles.bold20.copyWith(
                                        color: const Color(0xff2A3336),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: getDynamicHeight(10)),
                                    // Subtitle
                                    Text(
                                      "هل فعلاً قمت بإكمال واجبك لهذا اليوم؟",
                                      style: AppTextStyles.medium14.copyWith(
                                        color: const Color(0xff7A7A7A),
                                        height: 1.7,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: getDynamicHeight(28)),
                                    // Confirm button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.back(); // close dialog
                                          controller.markHomeworkAsCompleted(widget.homework.id!);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(vertical: getDynamicHeight(14)),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: Text(
                                          "نعم، أكملت الواجب ✓",
                                          style: AppTextStyles.bold16.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: getDynamicHeight(12)),
                                    // Cancel button
                                    SizedBox(
                                      width: double.infinity,
                                      child: TextButton(
                                        onPressed: () => Get.back(),
                                        style: TextButton.styleFrom(
                                          foregroundColor: const Color(0xff7A7A7A),
                                          padding: EdgeInsets.symmetric(vertical: getDynamicHeight(14)),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                            side: BorderSide(color: Colors.grey.shade200),
                                          ),
                                        ),
                                        child: Text(
                                          "تراجع",
                                          style: AppTextStyles.medium16.copyWith(color: const Color(0xff7A7A7A)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            barrierDismissible: true,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary, width: 1.5),
                          padding: EdgeInsets.symmetric(vertical: getDynamicHeight(16)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        icon: isLoading 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2))
                          : const Icon(Icons.check_circle_outline, color: AppColors.primary),
                        label: Text(
                          "إكمال الواجب",
                          style: AppTextStyles.bold18.copyWith(color: AppColors.primary),
                        ),
                      );
                    }
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  const TitleText({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        SizedBox(width: getDynamicWidth(8)),

        Text(
          title,
          style: AppTextStyles.bold16.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}
