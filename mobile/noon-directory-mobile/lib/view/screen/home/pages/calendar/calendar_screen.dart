// [تحديث التصميم]: تحسين واجهة التقويم وتوسيط رسائل "لا توجد بيانات".
// تم تحديث تصميم كروت التنبيهات والدروس لتكون أكثر حداثة وبـ Soft Shadows.
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/calendar_controller.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/models/calendar/attendance.dart';
import 'package:noon/models/calendar/homework.dart';
import 'package:noon/models/calendar/completed_lesson.dart';
import 'package:noon/models/calendar/exam.dart';
import 'package:noon/models/calendar/schedule.dart';
import 'package:noon/view/widget/attendance_card.dart';
import 'package:noon/view/widget/date_picker_bottom_sheet.dart';
import 'package:noon/view/widget/days_tab_bar.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:noon/view/widget/schedule_card.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/controllers/homework_completed_controller.dart';
import 'package:noon/view/screen/home/pages/lessons/student_lessons_screen.dart';
import 'package:s_extensions/s_extensions.dart';
import 'package:noon/controllers/homework_controller.dart';
import 'package:noon/view/widget/homework_details_bottom_sheet.dart';
import 'package:noon/models/homework_model.dart' as full_hw;

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final controller = Get.put(CalendarController());
  final _categoryController = PageController(initialPage: 0);

  @override
  dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: Text(AppLanguage.calendar.tr, style: AppTextStyles.bold16),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 16),
            child: DatePickerView(
              initialDate: controller.selectedDate.value,
              firstDate: DateTime.now() - (365 * 5).day,
              lastDate: DateTime.now() + (365 * 5).day,
              onDisplayedMonthChanged: (date) =>
                  controller.setSelectedDate(date),
              onDateChanged: (date) => controller.setSelectedDate(date),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Obx(
              () => AnimatedTabBar(
                items: [
                  AppLanguage.homework.tr,
                  AppLanguage.lessons.tr,
                  AppLanguage.attendancesStr.tr,
                  AppLanguage.examStr.tr,
                  AppLanguage.schoolScheduleStr1.tr,
                ],
                selectedItem: controller.selectedTabIndex.value,
                onItemSelected: (itemSelected, index) {
                  controller.setSelectedTabIndex(index);
                  if (_categoryController.hasClients) {
                    _categoryController.animateToPage(
                      index,
                      duration: 300.msec,
                      curve: Curves.easeOutCubic,
                    );
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return CircularProgressIndicator().center();
              }

              if (controller.isError.value) {
                return NoDataWidget(title: AppLanguage.noInfoAvailable.tr);
              }

              final pages = [
                HomeworkPage(items: controller.homework.toList()),
                LessonsPage(items: controller.completedLessons.toList()),
                AttendancePage(
                  date: controller.selectedDate.value,
                  items: controller.attendance,
                ),
                ExamsPage(items: controller.exams.toList()),
                SchedulePage(items: controller.schedule.toList()),
              ];

              final pageView = PageView.builder(
                controller: _categoryController,
                itemCount: pages.length,
                onPageChanged: (index) => controller.setSelectedTabIndex(index),
                itemBuilder: (_, index) {
                  final page = pages[index];
                  return Padding(
                    padding: .symmetric(horizontal: 12.0),
                    child: page,
                  );
                },
              );

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_categoryController.hasClients) {
                  final current = _categoryController.page?.round();
                  final target = controller.selectedTabIndex.value;
                  if (current != target) {
                    _categoryController.jumpToPage(target);
                  }
                }
              });

              return pageView;
            }),
          ),
        ],
      ),
    );
  }
}

class HomeworkPage extends StatelessWidget {
  final List<HomeworkModel> items;
  const HomeworkPage({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(child: NoDataWidget(title: AppLanguage.noInfoAvailable.tr));
    }

    return ListView.separated(
      padding: .symmetric(vertical: 12.0),
      itemCount: items.length,
      separatorBuilder: (_, _) => SizedBox(height: getDynamicHeight(8)),
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () async {
            if (item.id != null) {
              try {
                Get.dialog(
                  const Center(child: CircularProgressIndicator()),
                  barrierDismissible: false,
                );
                final controller = Get.put(HomeworkController());
                final full_hw.HomeworkModel? fullHomework = await controller
                    .getHomeworkById(item.id!);
                Get.back();
                if (fullHomework != null) {
                  if (context.mounted) {
                    Get.bottomSheet(
                      HomeworkDetailsBottomSheet(fullHomework),
                      isScrollControlled: true,
                    );
                  }
                } else {
                  Get.snackbar(
                    AppLanguage.errorStr.tr,
                    AppLanguage.noInfoAvailable.tr,
                  );
                }
              } catch (e) {
                if (Get.isDialogOpen ?? false) Get.back();
                Get.snackbar(
                  AppLanguage.errorStr.tr,
                  AppLanguage.unexpectedErrorStr.tr,
                );
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.warningColor.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: AppColors.warningColor.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warningColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppAssets.icHomeworkV2,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    AppColors.warningColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              title: Text(
                '${AppLanguage.assignment.tr} ${item.subject}: ${item.title}',
                style: AppTextStyles.bold16.copyWith(
                  color: const Color(0xFF2D3142),
                ),
              ),
              subtitle: Text(
                '${AppLanguage.lastAssignmentDay.tr}: ${item.dueDate?.formatDayMonthYear}',
                style: AppTextStyles.medium14.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}

class LessonsPage extends StatelessWidget {
  final List<CompletedLessonModel> items;
  const LessonsPage({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(child: NoDataWidget(title: AppLanguage.noInfoAvailable.tr));
    }

    return ListView.separated(
      padding: .symmetric(vertical: 12.0),
      itemCount: items.length,
      separatorBuilder: (_, _) => SizedBox(height: getDynamicHeight(8)),
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () async {
            if (item.id != null) {
              try {
                Get.dialog(
                  const Center(child: CircularProgressIndicator()),
                  barrierDismissible: false,
                );
                final controller = Get.put(HomeworkCompletedController());
                final lesson = await controller.getLessonById(item.id!);
                Get.back();
                if (lesson != null) {
                  Get.bottomSheet(
                    LessonDetailsBottomSheet(lesson),
                    isScrollControlled: true,
                  );
                }
              } catch (e, s) {
                Get.snackbar(
                  AppLanguage.errorStr.tr,
                  AppLanguage.unexpectedErrorStr.tr,
                );
                dprint(s);
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.warningColor.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: AppColors.warningColor.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warningColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppAssets.icLessons,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    AppColors.warningColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              title: Text(
                '${item.subject}',
                style: AppTextStyles.bold16.copyWith(
                  color: const Color(0xFF2D3142),
                ),
              ),
              subtitle: Text(
                '${item.classs}, ${item.section}',
                style: AppTextStyles.medium14.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              trailing: Text(
                '${AppLanguage.teacherStr.tr}: ${item.teacher}',
                style: AppTextStyles.bold14.copyWith(
                  color: AppColors.warningColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AttendancePage extends StatelessWidget {
  final DateTime date;
  final List<AttendanceModel> items;
  const AttendancePage({super.key, required this.date, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(child: NoDataWidget(title: AppLanguage.noInfoAvailable.tr));
    }

    return ListView.separated(
      padding: .symmetric(vertical: 12.0),
      itemCount: items.length,
      separatorBuilder: (_, _) => SizedBox(height: getDynamicHeight(8)),
      itemBuilder: (context, index) {
        final item = items[index];
        final attendance = item.status?.toLowerCase();
        Color color;
        if (attendance! == 'present') {
          color = AppColors.bubbleGreenColor;
        } else if (attendance == 'absent') {
          color = AppColors.errorRedColor;
        } else {
          color = AppColors.primary;
        }

        return AttendanceCard(
          color: color,
          attendanceStatus: attendance.tr,
          subject: item.subject,
          date: item.date?.formatDayMonthYear,
        );
      },
    );
  }
}

class ExamsPage extends StatelessWidget {
  final List<ExamModel> items;
  const ExamsPage({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(child: NoDataWidget(title: AppLanguage.noInfoAvailable.tr));
    }

    return ListView.separated(
      padding: .symmetric(vertical: 12.0),
      itemCount: items.length,
      separatorBuilder: (_, _) => SizedBox(height: getDynamicHeight(8)),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.yellow500Color.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: AppColors.yellow500Color.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.yellow500Color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                AppAssets.icExamTableV2,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  AppColors.yellow500Color,
                  BlendMode.srcIn,
                ),
              ),
            ),
            title: Text(
              '${item.subject}',
              style: AppTextStyles.bold16.copyWith(
                color: const Color(0xFF2D3142),
              ),
            ),
            subtitle: Text(
              '${item.examType}',
              style: AppTextStyles.medium14.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            trailing: Text(
              '${item.date?.formatDayMonthYear}',
              style: AppTextStyles.regular14.copyWith(
                color: AppColors.yellow500Color,
              ),
            ),
          ),
        );
      },
    );
  }
}

class SchedulePage extends StatelessWidget {
  final List<ScheduleModel> items;
  const SchedulePage({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final g = Get.find<GlobalController>();

    if (items.isEmpty) {
      return Padding(
        padding: .symmetric(horizontal: 12.0, vertical: 90.0),
        child: NoDataWidget(title: AppLanguage.noInfoAvailable.tr),
      );
    }

    return ListView.separated(
      padding: .symmetric(vertical: 12.0),
      itemCount: items.length,
      separatorBuilder: (_, _) => SizedBox(height: getDynamicHeight(6)),
      itemBuilder: (context, index) {
        final item = items[index];
        return ScheduleCard(
          title: item.subject!,
          date:
              '${item.timeFrom?.formatHrMin12 ?? ''} - ${item.timeTo?.formatHrMin12 ?? ''}',
          teacherName: item.teacher ?? '',
          index: index,
          isTeacher: g.isTeacher,
          showScheduleIndex: false,
        );
      },
    );
  }
}
