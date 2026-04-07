import 'package:flutter/material.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/homework_completed_controller.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/models/lesson_model.dart';
import 'package:intl/intl.dart';
import 'package:noon/view/screen/home/pages/lessons/student_lessons_screen.dart';

class TodayLessonsSection extends StatefulWidget {
  const TodayLessonsSection({super.key});

  @override
  State<TodayLessonsSection> createState() => _TodayLessonsSectionState();
}

class _TodayLessonsSectionState extends State<TodayLessonsSection> {
  final _homeworkCompletedController = Get.put(HomeworkCompletedController());
  bool _isLoading = true;
  List<LessonModel> _todaysLessons = [];
  final Map<String, String> _subjectNames = {};

  @override
  void initState() {
    super.initState();
    _fetchTodayLessons();
  }

  Future<void> _fetchTodayLessons() async {
    try {
      final subjects = await _homeworkCompletedController
          .getLessonsForTodayForStudent();

      final List<LessonModel> flatLessons = [];
      for (var subject in subjects) {
        if (subject.lessons != null) {
          for (var lesson in subject.lessons!) {
            flatLessons.add(lesson);
            _subjectNames[lesson.id] = subject.subjectName ?? 'مادة غير محددة';
          }
        }
      }

      // sort by newest
      flatLessons.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      setState(() {
        _todaysLessons = flatLessons;
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
          'الدروس المنجزة اليوم',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff2A3336),
          ),
        ),
        SizedBox(height: getDynamicHeight(16)),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_todaysLessons.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'لا توجد دروس منجزة اليوم',
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
              itemCount: _todaysLessons.length,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final lesson = _todaysLessons[index];
                final subjectName = _subjectNames[lesson.id] ?? '';
                final formattedTime = DateFormat(
                  'hh:mm a',
                ).format(lesson.createdAt);

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
                                lesson.title,
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
                          Get.bottomSheet(
                            LessonDetailsBottomSheet(lesson),
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
