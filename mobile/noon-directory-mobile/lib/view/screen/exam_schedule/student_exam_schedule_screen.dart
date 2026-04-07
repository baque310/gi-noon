import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/exam_schedule_controller.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/core/extensions/string_extension.dart';
import 'package:noon/view/screen/pdf_viewer_screen.dart';
import 'package:noon/view/screen/show_images_screen.dart';
import 'package:noon/view/widget/app_progress.dart';
import 'package:noon/view/widget/color_button.dart';
import 'package:noon/view/widget/exam_schedule_card.dart';
import 'package:noon/view/widget/images/custom_network_img_provider.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:s_extensions/s_extensions.dart';
import '../../../core/constant/app_sizes.dart';
import '../../../core/localization/language.dart';
import '../../../models/exam_data_model.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/dropdown/generic_dropdown_widget.dart';
import '../../widget/no_data_widget.dart';

class StudentExamScheduleScreen extends StatelessWidget {
  StudentExamScheduleScreen({super.key});

  final controller = Get.find<ExamScheduleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarName: AppLanguage.examScheduleStr1.tr,
        isLeading: true,
      ),
      body: Obx(() {
        var selectedData =
            controller
                .studentExamResults
                .value
                .sections[controller.studentExamValue.value]
                ?.toList() ??
            [];

        selectedData.sort((a, b) {
          final da = a.examSections.isNotEmpty
              ? a.examSections.first.examDate
              : null;
          final db = b.examSections.isNotEmpty
              ? b.examSections.first.examDate
              : null;

          if (da == null && db == null) return 0;
          if (da == null) return 1;
          if (db == null) return -1;

          return da.compareTo(db);
        });

        if (controller.loading.value) {
          return const Center(child: Loading());
        }

        if (controller.studentExams.isEmpty) {
          return NoDataWidget(title: AppLanguage.thereIsNoStudentExams.tr);
        }

        int progress = 0;
        int totalProgress = 0;

        for (final exam in selectedData) {
          if (exam.examSections.isNotEmpty) {
            int c = DateTime.now().compareTo(exam.examSections.first.examDate!);
            if (c >= 0) {
              progress++;
            }
            totalProgress++;
          }
        }

        return SingleChildScrollView(
          padding: .symmetric(horizontal: getDynamicHeight(16)),
          child: Column(
            children: [
              SizedBox(height: getDynamicHeight(16)),

              // ? drop down selector
              CustomGenericDropDown<String>(
                content: controller.studentExams.toList(),
                displayText: (item) => item,
                onChanged: (v) => controller.studentExamValue(v),
                hint: AppLanguage.examStr.tr,
                value: controller.studentExamValue.value,
              ),

              if (selectedData.isNotEmpty) ...[
                SizedBox(height: getDynamicHeight(24)),

                // ? exams progress
                SizedBox(
                  child: Row(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .end,
                    children: [
                      Container(
                        margin: .only(bottom: getDynamicHeight(8)),
                        width: getDynamicWidth(320),
                        child: AppProgress(
                          value: progress,
                          maxValue: totalProgress,
                        ),
                      ),

                      SvgPicture.asset(
                        AppAssets.icExamProgressFlag,
                        height: 50,
                      ),
                    ],
                  ),
                ).directionality(direction: .ltr),
                SizedBox(height: getDynamicHeight(16)),

                // ? exam schedule table
                ExamScheduleTabelWidget(data: selectedData),
              ],

              const SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }
}

class ExamScheduleTabelWidget extends StatelessWidget {
  const ExamScheduleTabelWidget({super.key, required this.data});

  final List<ExamDataModel> data;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      separatorBuilder: (context, index) => const SizedBox.shrink(),
      itemBuilder: (context, index) {
        final item = data[index];
        if (item.examSections.isNotEmpty) {
          bool outdated =
              DateTime.now().compareTo(item.examSections.first.examDate!) >= 0;
          bool isDone = item.done ?? outdated;

          return ExamScheduleCard(
            subject: item.stageSubject.name ?? '',
            date: item.examSections.first.examDate!.formatDateToYearMonthDay,
            teacher: item.examSections.first.teachers.isNotEmpty
                ? '${AppLanguage.teacherStr.tr}: ${item.examSections.first.teachers.first.fullName}'
                : '',
            done: isDone,
            onTapArrow: () => Get.bottomSheet(
              backgroundColor: AppColors.neutralBackground,
              shape: RoundedRectangleBorder(
                borderRadius: .vertical(top: .circular(getDynamicHeight(16))),
              ),
              ExamDetailsBottomsheet(item: item),
            ),
          );
        } else {
          return index == 0
              ? Padding(
                  padding: const .symmetric(vertical: 45.0),
                  child: NoDataWidget(
                    title: AppLanguage.noExamsStr.tr,
                  ).center(),
                )
              : SizedBox.shrink();
        }
      },
    );
  }
}

class ExamDetailsBottomsheet extends StatefulWidget {
  final ExamDataModel item;

  const ExamDetailsBottomsheet({super.key, required this.item});

  @override
  State<ExamDetailsBottomsheet> createState() => _ExamDetailsBottomsheetState();
}

class _ExamDetailsBottomsheetState extends State<ExamDetailsBottomsheet> {
  final scrollController = ScrollController();
  IconData scrollIcon = Icons.keyboard_arrow_down_rounded;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          scrollIcon = Icons.keyboard_arrow_up_rounded;
        });
      } else {
        setState(() {
          scrollIcon = Icons.keyboard_arrow_down_rounded;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get attachments from controller
    final examController = Get.find<ExamScheduleController>();
    final attachments = examController.getAttachmentsForExam(widget.item.id);

    return SafeArea(
      child: Padding(
        padding: .all(getDynamicWidth(24)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              Text(
                '${AppLanguage.examDetailsStr.tr} - ${widget.item.stageSubject.name}',
                style: AppTextStyles.bold16,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  SvgPicture.asset(
                    AppAssets.icCalendar,
                    colorFilter: .mode(AppColors.primary, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget
                        .item
                        .examSections
                        .first
                        .examDate!
                        .formatDateToYearMonthDay,
                    style: AppTextStyles.regular14,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ? Attachments Section (if any)
              if (attachments.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(
                      Icons.attach_file_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'المرفقات (${attachments.length})',
                      style: AppTextStyles.bold14.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ...attachments.take(attachments.length > 3 ? 2 : 3).map((
                      att,
                    ) {
                      final isFile =
                          att.url.split('/').last.split('.').last == 'pdf';
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: SizedBox(
                            height: getDynamicHeight(120),
                            child: GestureDetector(
                              onTap: () => isFile
                                  ? Get.to(
                                      () => PdfViewerScreen(
                                        pdfUrl:
                                            att.url.pdfUrlToFullUrl ?? att.url,
                                        isLocalFile: false,
                                      ),
                                    )
                                  : Get.to(
                                      () => ShowImageGalleryScreen(
                                        img: attachments
                                            .map((a) => a.url)
                                            .toList(),
                                        images: const [],
                                        initialIndex: attachments.indexOf(att),
                                      ),
                                    ),
                              child: CustomNetworkImgProvider(
                                imageUrl: att.url,
                                height: getDynamicHeight(120),
                                width: 120,
                                radius: 8,
                                isFile: isFile,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    if (attachments.length > 3)
                      Expanded(
                        child: Container(
                          height: getDynamicHeight(120),
                          decoration: BoxDecoration(
                            color: AppColors.neutralDarkGrey,
                            borderRadius: .circular(8),
                          ),
                          alignment: .center,
                          child: Text(
                            '+${attachments.length - 2}',
                            style: AppTextStyles.bold18.copyWith(
                              color: AppColors.neutralWhite,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
              ],

              // ? Exam content detail
              WidgetExtensions(
                    Text(
                      widget.item.content,
                      style: AppTextStyles.regular14,
                    ).scrollable(controller: scrollController),
                  )
                  .paddingAll(4)
                  .constrained(
                    height: widget.item.content.length > 200
                        ? getDynamicHeight(250)
                        : getDynamicHeight(150),
                    width: .infinity,
                  )
                  .decoration(
                    border: .all(
                      color: AppColors.neutralDarkGrey.withValues(alpha: 0.4),
                      width: .7,
                    ),
                    borderRadius: .circular(12),
                  ),

              if (widget.item.content.length > 200) ...[
                SizedBox(height: getDynamicHeight(8)),

                Icon(
                  scrollIcon,
                  color: AppColors.neutralDarkGrey.withValues(alpha: 0.7),
                  size: 32,
                ).center(),
              ],

              const SizedBox(height: 16),
              ColorButton(text: AppLanguage.okStr.tr, press: () => Get.back()),
            ],
          ),
        ),
      ),
    );
  }
}
