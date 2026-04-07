import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/controllers/home_controller.dart';
import 'package:noon/controllers/profile_controller.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/view/screen/home/pages/main/widgets/banners_section.dart';
import 'package:noon/view/screen/home/pages/main/widgets/custom_appbar.dart';
import 'package:noon/controllers/announcements_controller.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/view/screen/home/pages/main/widgets/main_items.dart';
import 'package:noon/view/screen/home/pages/main/widgets/today_homework_section.dart';
import 'package:noon/view/screen/home/pages/main/widgets/teacher_today_homework_section.dart';
import 'package:noon/view/screen/home/pages/main/widgets/teacher_today_lessons_section.dart';
import 'package:noon/view/screen/home/pages/main/widgets/today_lessons_section.dart';
// TodayMessagesSection moved to nav bar chat tab
// import 'package:noon/view/screen/home/pages/main/widgets/today_messages_section.dart';
import 'package:noon/view/screen/home/pages/main/widgets/wisdom_ticker_bar.dart';
import '../../../../../core/localization/language.dart';
import '../assignments/assignment_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final controller = Get.find<HomeController>();
  final profileController = Get.find<ProfileController>();
  final gController = Get.find<GlobalController>();
  final announcementsController = Get.put(AnnouncementsController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: getDynamicHeight(16)),
          Obx(() {
            final enrollment =
                profileController.user.value?.student?.studentEnrollment;
            final studentClass = (enrollment != null && enrollment.isNotEmpty)
                ? enrollment.first.classInfo?.name ?? ''
                : '';
            final studentSection = (enrollment != null && enrollment.isNotEmpty)
                ? enrollment.first.section?.name ?? ""
                : "";
            final studentPhoto = profileController.user.value?.student?.photo;
            final teacherPhoto = profileController.user.value?.teacher?.photo;

            return CustomAppbar(
              name: _displayNameByType,
              academicStage: studentClass,
              studentSection: studentSection,
              imageUrl: studentPhoto ?? teacherPhoto,
            );
          }),

          Expanded(
            child: RefreshIndicator(
              triggerMode: .anywhere,
              onRefresh: () async {
                profileController.user.value = null;
                profileController.getUser();

                controller.banners.clear();
                controller.getBanners();
                controller.getTodayWisdom();

                announcementsController.getAnnouncementsCount();
              },
              child: Padding(
                padding: const .symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: getDynamicHeight(16)),

                      // ? Banners / Advertisements Section
                      Obx(
                        () => controller.banners.isEmpty
                            ? const SizedBox()
                            : BannersSection(
                                banners: controller.banners.toList(),
                              ),
                      ),

                      // ? Today's Wisdom Ticker
                      Obx(() {
                        final wisdom = controller.todayWisdom.value;
                        if (wisdom == null || wisdom.isEmpty) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: getDynamicHeight(12)),
                          child: WisdomTickerBar(wisdom: wisdom),
                        );
                      }),

                      SizedBox(height: getDynamicHeight(16)),

                      Obx(() {
                        final count =
                            announcementsController.announcementsCount.value;

                        // Teacher view — horizontal scroll layout, same as student
                        if (gController.isTeacher) {
                          List<MainItem> teacherItems = [
                            // 1. assignments (الواجبات)
                            MainItem(
                              onPressed: () =>
                                  Get.to(() => const AssignmentsScreen()),
                              title: AppLanguage.assignmentStr.tr,
                              bgColor: const Color(
                                0xFF9B79EB,
                              ).withValues(alpha: 0.10),
                              svgIcon: AppAssets.icHomework,
                            ),
                            // 2. Attendance (الحضور)
                            MainItem(
                              onPressed: () => Get.toNamed(
                                ScreensUrls.teacherAttendancesScreenUrl,
                              ),
                              title: AppLanguage.theAudienceStr.tr,
                              bgColor: const Color(
                                0xFFEE6055,
                              ).withValues(alpha: 0.10),
                              svgIcon: AppAssets.icAttendanceV2,
                            ),
                            // 3. grades (الدرجات)
                            MainItem(
                              onPressed: () => Get.toNamed(
                                ScreensUrls.teacherDegreesScreenUrl,
                              ),
                              title: AppLanguage.gradesStr.tr,
                              bgColor: const Color(
                                0xFF26BCAD,
                              ).withValues(alpha: 0.10),
                              svgIcon: AppAssets.icMarksV2,
                            ),
                            // 4. exams (الامتحانات)
                            MainItem(
                              onPressed: () => Get.toNamed(
                                ScreensUrls.teacherExamsScreenUrl,
                              ),
                              title: AppLanguage.examsStr.tr,
                              bgColor: const Color(
                                0xFFfdd255,
                              ).withValues(alpha: 0.10),
                              svgIcon: AppAssets.icExamTableV2,
                            ),
                            // 5. Online Exam (الامتحان الإلكتروني)
                            MainItem(
                              onPressed: () => Get.toNamed(
                                ScreensUrls.teacherOnlineExamScreenUrl,
                              ),
                              title: 'الامتحان الإلكتروني',
                              bgColor: const Color(
                                0xFF7C4DFF,
                              ).withValues(alpha: 0.10),
                              iconData: Icons.quiz_outlined,
                            ),
                            // 6. students (الطلاب)
                            MainItem(
                              onPressed: () => Get.toNamed(
                                ScreensUrls.teacherStudentsScreenUrl,
                              ),
                              title: AppLanguage.studentsStr.tr,
                              bgColor: const Color(
                                0xFF6735dc,
                              ).withValues(alpha: 0.10),
                              svgIcon: AppAssets.icStudents,
                            ),
                            // 6. behavior (السلوك)
                            MainItem(
                              onPressed: () => Get.toNamed(
                                ScreensUrls.teacherBehaviorScreenUrl,
                              ),
                              title: AppLanguage.behaviorStr.tr,
                              bgColor: const Color(
                                0xFF1e95d4,
                              ).withValues(alpha: 0.10),
                              svgIcon: AppAssets.icBehavior,
                            ),
                            // 7. school schedule (الجدول المدرسي)
                            MainItem(
                              onPressed: () =>
                                  Get.toNamed(ScreensUrls.schoolScheduleUrl),
                              title: AppLanguage.schoolScheduleStr.tr,
                              bgColor: const Color(
                                0xFFFF8811,
                              ).withValues(alpha: 0.10),
                              svgIcon: AppAssets.icTableV2,
                            ),
                            // 8. library (المكتبة)
                            MainItem(
                              onPressed: () => Get.toNamed(
                                ScreensUrls.libraryTeacherScreenUrl,
                              ),
                              title: AppLanguage.libraryStr.tr,
                              bgColor: const Color(
                                0xFF8CC348,
                              ).withValues(alpha: 0.10),
                              svgIcon: AppAssets.icLibraryV2,
                            ),
                          ];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'الاقسام الرئيسية',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff2A3336),
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'نقدم لك مجموعة من الأقسام التي تحقق تطلعاتك وكافة احتياجاتك، لنوفر لك بيئة مدرسية مثالية.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF7A7A7A),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: getDynamicWidth(120),
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: teacherItems.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 14),
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      width: getDynamicWidth(120),
                                      child: teacherItems[index],
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }

                        // For Student and Parent
                        List<MainItem> serviceItems = [
                          // exams schedule (1st)
                          MainItem(
                            onPressed: () =>
                                Get.toNamed(ScreensUrls.studentExamScheduleUrl),
                            title: AppLanguage.examScheduleStr.tr,
                            bgColor: const Color(
                              0xFFFFBD00,
                            ).withValues(alpha: 0.10),
                            svgIcon: AppAssets.icExamTableV2,
                          ),
                          // grades (2nd)
                          MainItem(
                            onPressed: () => Get.toNamed(
                              ScreensUrls.studentDegreesScreenUrl,
                            ),
                            title: AppLanguage.gradesStr.tr,
                            bgColor: const Color(
                              0xFF26BCAD,
                            ).withValues(alpha: 0.10),
                            svgIcon: AppAssets.icMarksV2,
                          ),
                          // Biometric Attendance (3rd)
                          MainItem(
                            onPressed: () => Get.toNamed(
                              ScreensUrls.biometricAttendanceScreenUrl,
                            ),
                            title: 'البصمة',
                            bgColor: const Color(
                              0xFF00C896,
                            ).withValues(alpha: 0.10),
                            iconData: Icons.face_retouching_natural,
                          ),
                          // announcements
                          MainItem(
                            onPressed: () =>
                                Get.toNamed(ScreensUrls.announcementsScreenUrl),
                            title: AppLanguage.announcements.tr,
                            bgColor: const Color(
                              0xFF40A4D6,
                            ).withValues(alpha: 0.10),
                            svgIcon: AppAssets.icInstructionsV2,
                            badge: count > 0 ? count.toString() : null,
                          ),
                          // school schedule
                          MainItem(
                            onPressed: () =>
                                Get.toNamed(ScreensUrls.schoolScheduleUrl),
                            title: AppLanguage.schoolScheduleStr.tr,
                            bgColor: const Color(
                              0xFFFF8811,
                            ).withValues(alpha: 0.10),
                            svgIcon: AppAssets.icTableV2,
                          ),
                          // Attendance
                          MainItem(
                            onPressed: () => Get.toNamed(
                              ScreensUrls.studentAttendancesScreenUrl,
                            ),
                            title: AppLanguage.theAudienceStr.tr,
                            bgColor: const Color(
                              0xFFEE6055,
                            ).withValues(alpha: 0.10),
                            svgIcon: AppAssets.icAttendanceV2,
                          ),
                          // complaints
                          MainItem(
                            onPressed: () =>
                                Get.toNamed(ScreensUrls.complaintsScreenUrl),
                            title: AppLanguage.complaints.tr,
                            bgColor: const Color(
                              0xFFE07A5F,
                            ).withValues(alpha: 0.10),
                            svgIcon: AppAssets.icComplaints,
                          ),
                          // behavior
                          MainItem(
                            onPressed: () => Get.toNamed(
                              ScreensUrls.studentBehaviorScreenUrl,
                            ),
                            title: AppLanguage.behaviorStr.tr,
                            bgColor: const Color(
                              0xFF1e95d4,
                            ).withValues(alpha: 0.10),
                            svgIcon: AppAssets.icBehavior,
                          ),
                        ];

                        List<MainItem> activityItems = [
                          // library
                          MainItem(
                            onPressed: () => Get.toNamed(
                              ScreensUrls.libraryStudentScreenUrl,
                            ),
                            title: AppLanguage.libraryStr.tr,
                            bgColor: const Color(
                              0xFF8CC348,
                            ).withValues(alpha: 0.10),
                            svgIcon: AppAssets.icLibraryV2,
                          ),
                          // instructions
                          MainItem(
                            onPressed: () =>
                                Get.toNamed(ScreensUrls.instructionsUrl),
                            title: AppLanguage.instructionsStr.tr,
                            bgColor: const Color(
                              0xFF3AF3EA,
                            ).withValues(alpha: 0.10),
                            svgIcon: AppAssets.icInstructionsV2,
                          ),
                          // gallery
                          MainItem(
                            onPressed: () =>
                                Get.toNamed(ScreensUrls.galleryUrl),
                            title: AppLanguage.galleryStr.tr,
                            bgColor: const Color(
                              0xFFF3903A,
                            ).withValues(alpha: 0.10),
                            svgIcon: AppAssets.icGalleryV2,
                          ),
                          // teaching staff
                          MainItem(
                            onPressed: () =>
                                Get.toNamed(ScreensUrls.teachingStafUrl),
                            title: AppLanguage.teachingStaffStr.tr,
                            bgColor: const Color(
                              0xFF7947ED,
                            ).withValues(alpha: 0.10),
                            svgIcon: AppAssets.icTechGroupV2,
                          ),
                          // aqsati
                          MainItem(
                            onPressed: () => Get.toNamed(ScreensUrls.aqsatiUrl),
                            title: AppLanguage.aqsatiStr.tr,
                            bgColor: const Color(
                              0xFF86CD82,
                            ).withValues(alpha: 0.10),
                            svgIcon: AppAssets.icAqsateV2,
                          ),
                          // transport lines
                          MainItem(
                            onPressed: () => Get.toNamed(ScreensUrls.linesUrl),
                            title: AppLanguage.transportLinesStr.tr,
                            bgColor: const Color(
                              0xFF40A4D6,
                            ).withValues(alpha: 0.10),
                            svgIcon: AppAssets.icLinesV2,
                          ),
                        ];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'الاقسام الرئيسية',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff2A3336),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'نقدم لك مجموعة من الأقسام التي تحقق تطلعاتك وكافة احتياجاتك، لنوفر لك بيئة مدرسية مثالية.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF7A7A7A),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: getDynamicWidth(120),
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: serviceItems.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 14),
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    width: getDynamicWidth(120),
                                    child: serviceItems[index],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'الأنشطة والفعاليات',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff2A3336),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'نقدم لك مجموعة من الأنشطة والفعاليات والأقسام الإضافية التي توفرها المدرسة لك بحُلة مُتميزة.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF7A7A7A),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: getDynamicWidth(120),
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: activityItems.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 14),
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    width: getDynamicWidth(120),
                                    child: activityItems[index],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }),
                      SizedBox(height: getDynamicHeight(24)),
                      if (gController.isTeacher) ...[
                        const TeacherTodayHomeworkSection(),
                        SizedBox(height: getDynamicHeight(36)),
                        const TeacherTodayLessonsSection(),
                      ] else ...[
                        const TodayHomeworkSection(),
                        SizedBox(height: getDynamicHeight(36)),
                        const TodayLessonsSection(),
                      ],
                      SizedBox(height: getDynamicHeight(32)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? get _displayNameByType {
    if (gController.isStudent) {
      return profileController.user.value?.student?.fullName;
    } else if (gController.isParent) {
      return profileController.user.value?.parent?.fullName;
    } else {
      return profileController.user.value?.teacher?.fullName;
    }
  }
}
