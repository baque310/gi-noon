import 'package:flutter/material.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/homework_controller.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/models/homework_model.dart';
import 'package:intl/intl.dart';
import 'package:noon/view/widget/homework_details_bottom_sheet.dart';

class TodayHomeworkSection extends StatefulWidget {
  const TodayHomeworkSection({super.key});

  @override
  State<TodayHomeworkSection> createState() => _TodayHomeworkSectionState();
}

class _TodayHomeworkSectionState extends State<TodayHomeworkSection> {
  final _homeworkController = Get.put(HomeworkController());
  bool _isLoading = true;
  List<HomeworkModel> _todaysHomeworks = [];
  final Map<String, String> _subjectNames = {};

  @override
  void initState() {
    super.initState();
    _fetchTodayHomeworks();
  }

  Future<void> _fetchTodayHomeworks() async {
    try {
      final subjects = await _homeworkController
          .getHomeworksForTodayForStudent();

      final List<HomeworkModel> flatHomeworks = [];
      for (var subject in subjects) {
        if (subject.homeworks != null) {
          for (var hw in subject.homeworks!) {
            flatHomeworks.add(hw);
            _subjectNames[hw.id!] = subject.subjectName ?? 'مادة غير محددة';
          }
        }
      }

      // sort by newest
      flatHomeworks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      setState(() {
        _todaysHomeworks = flatHomeworks;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'واجبات اليوم',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff2A3336),
          ),
        ),
        SizedBox(height: getDynamicHeight(16)),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_todaysHomeworks.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'لا توجد واجبات اليوم',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A7A7A),
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: getDynamicHeight(180),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _todaysHomeworks.length,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final hw = _todaysHomeworks[index];
                final subjectName = _subjectNames[hw.id!] ?? '';
                final formattedTime = DateFormat(
                  'hh:mm a',
                ).format(hw.createdAt);

                return Container(
                  width: getDynamicWidth(160),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                child: Text(
                                  subjectName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff2A3336),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                hw.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff2A3336), // Soft Black
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    formattedTime,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xff7A7A7A),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: Color(0xff7A7A7A),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Show details inside a bottom sheet instead of navigating
                          Get.bottomSheet(
                            HomeworkDetailsBottomSheet(hw),
                            isScrollControlled: true,
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          alignment: Alignment.center,
                          child: const Text(
                            'تابع',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
