import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/teacher_degrees_controller.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/models/exam_data_model.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/dropdown/generic_dropdown_widget.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:s_extensions/s_extensions.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/localization/language.dart';

class StudentDegreesScreen extends StatelessWidget {
  StudentDegreesScreen({super.key});

  final controller = Get.find<TeacherDegreesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarName: AppLanguage.gradesStr.tr,
        isLeading: true,
        press: () => Get.back(),
      ),
      body: Obx(() {
        List<ExamDataModel> selectedData =
            controller
                .studentExamResults
                .value
                .sections[controller.studentExamValue.value]
                ?.toList() ??
            [];

        if (controller.loading.value) {
          return const Center(child: Loading());
        } else if (controller.studentExams.isEmpty) {
          return NoDataWidget(title: AppLanguage.thereIsNoStudentExams.tr);
        } else {
          selectedData = selectedData
              .where(
                (e) => e.examSections.any(
                  (s) => (s.examResult?.isNotEmpty ?? false),
                ),
              )
              .toList();

          double selectedAverage = 0.0;
          if (selectedData.isNotEmpty) {
            double total = 0;
            int count = 0;
            for (final item in selectedData) {
              final secs = item.examSections
                  .where((s) => s.examResult?.isNotEmpty ?? false)
                  .toList();
              if (secs.isNotEmpty) {
                final studentScore = secs.first.examResult!.first.score
                    .toDouble();
                final examScore = item.score;
                if (examScore > 0) {
                  total += ((studentScore / examScore) * 100).clamp(0, 100);
                  count++;
                }
              }
            }
            if (count > 0) selectedAverage = total / count;
          }

          return SingleChildScrollView(
            padding: .symmetric(horizontal: getDynamicHeight(16)),
            child: Column(
              children: [
                SizedBox(height: getDynamicHeight(16)),

                // ? exams result dropdown menu
                CustomGenericDropDown<String>(
                  content: controller.studentExams.toList(),
                  displayText: (item) => item,
                  onChanged: (v) {
                    controller.studentExamValue(v);
                  },
                  hint: AppLanguage.examStr.tr,
                  value: controller.studentExamValue.value,
                ),
                SizedBox(height: getDynamicHeight(16)),

                if (selectedData.isNotEmpty) ...[
                  Container(
                    padding: .all(getDynamicHeight(16)),
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: .circular(16),
                    ),
                    child: Row(
                      children: [
                        Text(
                          AppLanguage.averageStr.tr,
                          style: AppTextStyles.bold18.copyWith(
                            color: AppColors.neutralWhite,
                          ),
                        ).expanded(),

                        Text(
                          '${selectedAverage.fixed00}%',
                          style: AppTextStyles.bold28.copyWith(
                            color: AppColors.neutralWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getDynamicHeight(16)),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: selectedData.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: getDynamicHeight(10)),
                    itemBuilder: (context, index) {
                      final item = selectedData[index];
                      final secsWithResult = item.examSections
                          .where((s) => (s.examResult?.isNotEmpty ?? false))
                          .toList();
                      return _DegreeCard(
                        key: ValueKey(
                          '${controller.studentExamValue.value}_$index',
                        ),
                        item: item,
                        secsWithResult: secsWithResult,
                        getColor: _getExamResultColor,
                      );
                    },
                  ),
                ] else
                  Padding(
                    padding: const .symmetric(vertical: 80.0),
                    child: NoDataWidget(
                      title: AppLanguage.noDegreesAddedYet.tr,
                    ).center(),
                  ),
              ],
            ),
          );
        }
      }),
    );
  }

  Color _getExamResultColor(double studentScore, double examScore) {
    if (studentScore >= examScore * 0.9) {
      return Colors.green;
    } else if (studentScore >= examScore * 0.7) {
      return Colors.blue;
    } else if (studentScore >= examScore * 0.5) {
      return Colors.yellow[600]!;
    } else {
      return Colors.red;
    }
  }
}

class _DegreeCard extends StatefulWidget {
  const _DegreeCard({
    super.key,
    required this.item,
    required this.secsWithResult,
    required this.getColor,
  });

  final ExamDataModel item;
  final List secsWithResult;
  final Color Function(double, double) getColor;

  @override
  State<_DegreeCard> createState() => _DegreeCardState();
}

class _DegreeCardState extends State<_DegreeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();
    final result = widget.secsWithResult.first.examResult;
    final studentScore = result!.first.score.toDouble();
    final examScore = widget.item.score;
    final fraction = (studentScore / examScore).clamp(0.0, 1.0);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fillAnimation = Tween<double>(
      begin: 0.0,
      end: fraction,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.secsWithResult.first.examResult;
    final studentScore = result!.first.score.toDouble();
    final examScore = widget.item.score;
    final color = widget.getColor(studentScore, examScore);

    return AnimatedBuilder(
      animation: _fillAnimation,
      builder: (context, _) {
        return Container(
          clipBehavior: .antiAlias,
          decoration: BoxDecoration(
            color: AppColors.neutralWhite,
            borderRadius: .circular(16),
          ),
          child: Stack(
            children: [
              // ? animated progress fill from left
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: _fillAnimation.value,
                    child: Container(color: color.withValues(alpha: 0.25)),
                  ),
                ),
              ),

              // ? content row
              Padding(
                padding: .symmetric(
                  horizontal: getDynamicWidth(16),
                  vertical: getDynamicHeight(14),
                ),
                child: Row(
                  children: [
                    // subject + teacher
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            widget.item.stageSubject.subject?.name ?? '',
                            style: AppTextStyles.bold16,
                          ),
                          SizedBox(height: getDynamicHeight(4)),
                          Row(
                            mainAxisAlignment: .start,
                            children: [
                              SvgPicture.asset(
                                AppAssets.icProfile,
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(width: getDynamicWidth(4)),
                              Flexible(
                                child: Text(
                                  '${AppLanguage.teacherStr.tr}: ${widget.item.stageSubject.teachers?.firstOrNull?.teacher?.fullName ?? 'لا يوجد اسم'}',
                                  style: AppTextStyles.regular12.copyWith(
                                    color: AppColors.neutralMidGrey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: getDynamicWidth(12)),

                    // score + max
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          '${studentScore.toInt()}',
                          style: AppTextStyles.bold28.copyWith(color: color),
                        ),
                        Text(
                          '${AppLanguage.ofStr.tr} ${examScore.toInt()}',
                          style: AppTextStyles.regular12.copyWith(
                            color: AppColors.neutralMidGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
