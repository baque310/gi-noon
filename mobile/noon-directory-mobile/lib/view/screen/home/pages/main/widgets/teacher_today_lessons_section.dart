import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/models/lesson_model.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constant/api_urls.dart';
import '../../../../../../core/extensions/date_extension.dart';
import '../../../../../../data/api_services.dart';

/// Displays today's lessons SENT by the teacher.
/// Shows: title, subject name, section name, time, and an OK button.
class TeacherTodayLessonsSection extends StatefulWidget {
  const TeacherTodayLessonsSection({super.key});

  @override
  State<TeacherTodayLessonsSection> createState() =>
      _TeacherTodayLessonsSectionState();
}

class _TeacherTodayLessonsSectionState
    extends State<TeacherTodayLessonsSection> {
  final _apiService = ApiService();
  bool _isLoading = true;
  List<LessonModel> _todaysLessons = [];

  @override
  void initState() {
    super.initState();
    _fetchTodayLessons();
  }

  Future<void> _fetchTodayLessons() async {
    try {
      final res = await _apiService.get(
        url: ApiUrls.teacherLessonsUrl,
        queryParameters: {
          "take": 50,
          "date": DateTime.now().formatDateToYearMonthDay,
        },
      );

      final items = List<LessonModel>.from(
        res.data['data'].map((e) => LessonModel.fromJson(jsonEncode(e))),
      );

      // sort by newest
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (mounted) {
        setState(() {
          _todaysLessons = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDetails(LessonModel lesson) {
    final subjectName =
        lesson.teacherSubject.stageSubject?.subject?.name ?? 'مادة غير محددة';
    // Use teacherSubject.section which includes Class from the API
    final tsSection = lesson.teacherSubject.section;
    final className = tsSection?.classInfo?.name ?? '';
    final sectionName = tsSection?.name ?? '';
    final classSectionLabel = className.isNotEmpty && sectionName.isNotEmpty
        ? '$className / $sectionName'
        : (sectionName.isNotEmpty ? sectionName : (lesson.section.name ?? ''));

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.menu_book_outlined,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                lesson.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2A3336),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Subject + section
              Text(
                '$subjectName • $classSectionLabel',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primary.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              // Content
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  lesson.content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff555555),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(height: 10),
              // Created at
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: Color(0xff9E9E9E),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('hh:mm a').format(lesson.createdAt),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xff7A7A7A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              // OK button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'حسناً',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
            height: getDynamicHeight(190),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _todaysLessons.length,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final lesson = _todaysLessons[index];
                final subjectName = lesson.teacherSubject.stageSubject?.subject
                        ?.name ??
                    'مادة غير محددة';
                // Use teacherSubject.section which includes Class from the API
                final tsSection = lesson.teacherSubject.section;
                final className = tsSection?.classInfo?.name ?? '';
                final sectionName = tsSection?.name ?? '';
                final classSectionLabel =
                    className.isNotEmpty && sectionName.isNotEmpty
                        ? '$className / $sectionName'
                        : (sectionName.isNotEmpty ? sectionName : (lesson.section.name ?? ''));
                final formattedTime =
                    DateFormat('hh:mm a').format(lesson.createdAt);

                return Container(
                  width: getDynamicWidth(170),
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
                              Text(
                                subjectName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                classSectionLabel,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xff9E9E9E),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Text(
                                lesson.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff2A3336),
                                ),
                                maxLines: 2,
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
                                      fontSize: 12,
                                      color: Color(0xff7A7A7A),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.access_time,
                                    size: 13,
                                    color: Color(0xff7A7A7A),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showDetails(lesson),
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
                              fontSize: 15,
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
