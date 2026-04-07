import 'package:get/get_navigation/get_navigation.dart';
import 'package:noon/bindings.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/view/screen/add_complaint_screen.dart';
import 'package:noon/view/screen/announcements_screen.dart';
import 'package:noon/view/screen/behavior/student_behavior_screen.dart';
import 'package:noon/view/screen/behavior/teacher_behavior_screen.dart';
import 'package:noon/view/screen/behavior/teacher_students_behavior_screen.dart';
import 'package:noon/view/screen/downloads_screen.dart';
import 'package:noon/view/screen/exam_schedule/teacher_exams_list_screen.dart';
import 'package:noon/view/screen/exam_schedule/teacher_add_exam_screen.dart';
import 'package:noon/view/screen/home/pages/assignments/homeworks_screen.dart';
import 'package:noon/view/screen/home/pages/lessons/lessons_screen.dart';
import 'package:noon/view/screen/installments_screen.dart';
import 'package:noon/view/screen/attendances/student_attendances_screen.dart';
import 'package:noon/view/screen/attendances/teacher_add_student_status_screen.dart';
import 'package:noon/view/screen/attendances/teacher_attendances_screen.dart';
import 'package:noon/view/screen/auth/change_password_screen.dart';
import 'package:noon/view/screen/auth/login_screen.dart';
import 'package:noon/view/screen/auth/not_registered_screen.dart';
import 'package:noon/view/screen/complaints_screen.dart';
import 'package:noon/view/screen/communications/conversation_screen.dart';
import 'package:noon/view/screen/degrees/student_degrees_screen.dart';
import 'package:noon/view/screen/degrees/teacher_add_degrees_screen.dart';
import 'package:noon/view/screen/degrees/teacher_degrees_screen.dart';
import 'package:noon/view/screen/degrees/teacher_student_degrees_screen.dart';
import 'package:noon/view/screen/exam_schedule/student_exam_schedule_screen.dart';
import 'package:noon/view/screen/gallery_screen.dart';
import 'package:noon/view/screen/guidance/instruction_details_screen.dart';
import 'package:noon/view/screen/home/home_screen.dart';
import 'package:noon/view/screen/guidance/instructions_screen.dart';
import 'package:noon/view/screen/home/pages/assignments/teacher/add_homework_screen.dart';
import 'package:noon/view/screen/home/pages/assignments/teacher/add_lesson_screen.dart';
import 'package:noon/view/screen/communications/communication_screen.dart';
import 'package:noon/view/screen/home/pages/profile/edit_profile_screen.dart';
import 'package:noon/view/screen/home/pages/profile/attachments_screen.dart';
import 'package:noon/view/screen/library/addfile_teacher_screen.dart';
import 'package:noon/view/screen/library/library_student_screen.dart';
import 'package:noon/view/screen/library/library_teacher_screen.dart';
import 'package:noon/view/screen/lines_screen.dart';
import 'package:noon/view/screen/notification_screen.dart';
import 'package:noon/view/screen/onboarding_screen.dart';
import 'package:noon/view/screen/school_schedule_screen.dart';
import 'package:noon/view/screen/section_students_screen.dart';
import 'package:noon/view/screen/teacher_students_screen.dart';
import 'package:noon/view/screen/select_child_screen.dart';
import 'package:noon/view/screen/splash_screen.dart';
import 'package:noon/view/screen/home/pages/assignments/student/student_homeworks_screen.dart';
import 'package:noon/view/screen/home/pages/lessons/student_lessons_screen.dart';
import 'package:noon/view/screen/teaching_staff_screen.dart';
import 'package:noon/view/screen/home/pages/biometric/biometric_attendance_screen.dart';
import 'package:noon/view/screen/online_exam/teacher_online_exam_list_screen.dart';
import 'package:noon/view/screen/online_exam/teacher_create_online_exam_screen.dart';
import 'package:noon/view/screen/online_exam/teacher_online_exam_detail_screen.dart';
import 'package:noon/view/screen/school_code_screen.dart';
import 'package:noon/view/screen/guest_home_screen.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(
    name: ScreensUrls.splashScreenUrl,
    page: () => const SplashScreen(),
    transition: Transition.noTransition,
    binding: SplashBinding(),
  ),
  GetPage(
    name: ScreensUrls.onboardingUrl,
    page: () => const OnboardingScreen(),
    binding: OnboardingBinding(),
  ),
  //
  GetPage(
    name: ScreensUrls.loginUrl,
    page: () => LoginPage(),
    binding: LoginBinding(),
    // middlewares: [MyMiddleWare()],
  ),
  GetPage(
    name: ScreensUrls.homeUrl,
    page: () => HomeScreen(),
    binding: HomeBinding(),
  ),
  GetPage(
    name: ScreensUrls.aqsatiUrl,
    page: () => InstallmentsScreen(),
    binding: InstallmentsBinding(),
  ),

  GetPage(name: ScreensUrls.changePassUrl, page: () => ChangePasswordScreen()),
  GetPage(
    name: ScreensUrls.instructionsUrl,
    page: () => InstructionsScreen(),
    binding: InstructionsBinding(),
  ),
  GetPage(
    name: ScreensUrls.instructionsDetailsUrl,
    page: () => const InstructionDetailsScreen(),
  ),
  GetPage(
    name: ScreensUrls.galleryUrl,
    page: () => GalleryScreen(),
    binding: GalleryBinding(),
  ),
  GetPage(
    name: ScreensUrls.notRegisteredUrl,
    page: () => const NotRegisteredScreen(),
  ),
  GetPage(
    name: ScreensUrls.notificationUrl,
    page: () => NotificationScreen(),
    binding: NotificationsBinding(),
  ),
  GetPage(
    name: ScreensUrls.teachingStafUrl,
    page: () => TeachingStaffScreen(),
    binding: TeachingStafBinding(),
  ),
  GetPage(
    name: ScreensUrls.linesUrl,
    page: () => const LinesScreen(),
    binding: LinesBinding(),
  ),
  GetPage(
    name: ScreensUrls.schoolScheduleUrl,
    page: () => const SchoolScheduleScreen(),
    binding: SchoolScheduleBinding(),
  ),
  GetPage(
    name: ScreensUrls.libraryTeacherScreenUrl,
    page: () => LibraryTeacherScreen(),
    binding: LibraryBinding(),
  ),
  GetPage(
    name: ScreensUrls.libraryStudentScreenUrl,
    page: () => LibraryStudentScreen(),
    binding: LibraryBinding(),
  ),
  GetPage(
    name: ScreensUrls.addfileTeacherScreenUrl,
    page: () => const AddfileTeacherScreen(),
  ),

  GetPage(
    name: ScreensUrls.teacherDegreesScreenUrl,
    page: () => TeacherDegreesScreen(),
    binding: TeacherDegreesBinding(),
  ),

  GetPage(
    name: ScreensUrls.studentDegreesScreenUrl,
    page: () => StudentDegreesScreen(),
    binding: TeacherDegreesBinding(),
  ),
  GetPage(
    name: ScreensUrls.teacherAddDegreesScreenUrl,
    page: () => const TeacherAddDegreesScreen(),
  ),
  GetPage(
    name: ScreensUrls.teacherExamsScreenUrl,
    page: () => TeacherExamsListScreen(),
  ),
  GetPage(
    name: ScreensUrls.teacherCreateExamScreenUrl,
    page: () => const TeacherCreateExamScreen(),
  ),
  GetPage(
    name: ScreensUrls.teacherStudentDegreesScreenUrl,
    page: () => TeacherStudentDegreesScreen(),
  ),
  GetPage(
    name: ScreensUrls.studentAttendancesScreenUrl,
    page: () => const StudentAttendancesScreen(),
    binding: AttendancesBinding(),
  ),
  GetPage(
    name: ScreensUrls.teacherAttendancesScreenUrl,
    page: () => const TeacherAttendancesScreen(),
    binding: AttendancesBinding(),
  ),
  GetPage(
    name: ScreensUrls.studentExamScheduleUrl,
    page: () => StudentExamScheduleScreen(),
    binding: ExamScheduleBinding(),
  ),
  GetPage(
    name: ScreensUrls.addHomeworkTeacherScreenUrl,
    page: () => AddHomeworkScreen(),
  ),
  GetPage(
    name: ScreensUrls.addLessonTeacherScreenUrl,
    page: () => const AddLessonScreen(),
  ),
  GetPage(
    name: ScreensUrls.editProfileInfoScreenUrl,
    page: () => EditProfileScreen(),
  ),
  GetPage(
    name: ScreensUrls.teacherAddStudentStatusUrl,
    page: () => const TeacherAddStudentStatusScreen(),
  ),
  GetPage(
    name: ScreensUrls.complaintsScreenUrl,
    page: () => ComplaintsScreen(),
    binding: ComplaintsBinding(),
  ),
  GetPage(
    name: ScreensUrls.addComplaintsScreenUrl,
    page: () => AddComplaintScreen(),
  ),
  GetPage(
    name: ScreensUrls.sectionStudentsScreenUrl,
    page: () => SectionStudentsScreen(),
  ),
  GetPage(
    name: ScreensUrls.teacherStudentsScreenUrl,
    page: () => TeacherStudentsScreen(),
  ),
  GetPage(
    name: ScreensUrls.studentHomeworksScreenUrl,
    page: () => StudentHomeworksScreen(),
  ),
  GetPage(
    name: ScreensUrls.studentLessonsScreenUrl,
    page: () => StudentLessonsScreen(),
  ),
  GetPage(
    name: ScreensUrls.selectChildScreenUrl,
    page: () => SelectChildScreen(),
    binding: SelectChildBinding(),
  ),
  GetPage(
    name: ScreensUrls.communicationScreenUrl,
    page: () => CommunicationScreen(),
    binding: CommunicationBinding(),
  ),
  GetPage(
    name: ScreensUrls.conversationScreenUrl,
    page: () => ConversationScreen(),
    binding: ConversationBinding(),
  ),
  GetPage(name: ScreensUrls.homeworksScreenUrl, page: () => HomeworksScreen()),
  GetPage(name: ScreensUrls.lessonsScreenUrl, page: () => LessonsScreen()),
  GetPage(name: ScreensUrls.downloadsScreenUrl, page: () => DownloadsScreen()),
  GetPage(
    name: ScreensUrls.announcementsScreenUrl,
    page: () => AnnouncementsScreen(),
  ),
  GetPage(
    name: ScreensUrls.attachmentsScreenUrl,
    page: () => const AttachmentsScreen(),
  ),
  GetPage(
    name: ScreensUrls.teacherBehaviorScreenUrl,
    page: () => const TeacherBehaviorScreen(),
  ),
  GetPage(
    name: ScreensUrls.teacherStudentsBehaviorScreenUrl,
    page: () => const TeacherStudentsBehaviorScreen(),
  ),
  GetPage(
    name: ScreensUrls.studentBehaviorScreenUrl,
    page: () => const StudentBehaviorScreen(),
  ),
  GetPage(
    name: ScreensUrls.biometricAttendanceScreenUrl,
    page: () => BiometricAttendanceScreen(),
  ),
  GetPage(
    name: ScreensUrls.teacherOnlineExamScreenUrl,
    page: () => const TeacherOnlineExamListScreen(),
  ),
  GetPage(
    name: ScreensUrls.teacherCreateOnlineExamScreenUrl,
    page: () => const TeacherCreateOnlineExamScreen(),
  ),
  GetPage(
    name: ScreensUrls.teacherOnlineExamDetailScreenUrl,
    page: () => const TeacherOnlineExamDetailScreen(),
  ),
  GetPage(
    name: ScreensUrls.schoolCodeUrl,
    page: () => const SchoolCodeScreen(),
    binding: SchoolCodeBinding(),
  ),
  GetPage(
    name: ScreensUrls.guestHomeUrl,
    page: () => const GuestHomeScreen(),
    binding: GuestHomeBinding(),
  ),
];
