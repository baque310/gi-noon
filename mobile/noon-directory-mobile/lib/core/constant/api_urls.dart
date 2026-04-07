class ApiUrls {
  // static const baseUrl = 'https://api.noon-iraq.com';
  // static const baseUrl = 'https://wl-v1-dev-api.noon-iraq.com';
  static const baseUrl = 'http://10.0.2.2:3002'; // For Android Emulator loopback
  // static const baseUrl = 'http://192.168.0.178:3002'; // Local API (WiFi)

  static const String apiKey = '728b2e74f6b7ceebe2ff91ff6a32fc6d169a51ccf063074190a206bc09634c7d';
  
  static const homeUrl = '$baseUrl/home';
  static const notificationUrl = '$baseUrl/notification/forUser';
  static const notificationMarkAllSeenUrl =
      '$baseUrl/notification/forUser/allIsSeen';
  static const refreshTokenUrl = '$baseUrl/user/refresh';
  static const login = '$baseUrl/user/signin';
  static const logout = '$baseUrl/user/logout';
  static const updatePassUrl = '$baseUrl/user/update-password';
  // App Rating
  static const createAppRating = '$baseUrl/mobile/app-rating';
  static const userProfileUrl = '$baseUrl/user/profile';
  static const filesUrl = '$baseUrl/uploads';
  static const bannersUrl = '$baseUrl/banner/user';
  static const guidanceUrl = '$baseUrl/guidance/user';
  static const todayWisdomUrl = '$baseUrl/guidance/user/today';
  static const galleryUrl = '$baseUrl/gallery/user';
  static const updateStudentProfileUrl = '$baseUrl/user/studentProfile';
  static const updateParentProfileUrl = '$baseUrl/user/parentProfile';
  static const updateTeacherProfileUrl = '$baseUrl/user/teacherProfile';
  static const teachingStaffUrl = '$baseUrl/student/teacher';
  static const teachingStaffForParentUrl = '$baseUrl/parent/teacher';
  static const busUrl = '$baseUrl/student/bus';
  static const busForParentUrl = '$baseUrl/parent/bus';
  static const sectionScheduleUrl = '$baseUrl/section/schedule/teacher/list';
  static const teacherLibraryUrl = '$baseUrl/teacher/library';
  static const studentLibraryUrl = '$baseUrl/student/library';
  static const teacherExamsSectionUrl = '$baseUrl/teacher/exams/examSections';
  static const teacherExamsUrl = '$baseUrl/teacher/exams';
  static const teacherExamTypeUrl = '$baseUrl/teacher/examType';
  static const teacherStageUrl = '$baseUrl/teacher/stage';
  static const teacherClassUrl = '$baseUrl/teacher/class';
  static const teacherSectionUrl = '$baseUrl/teacher/section';
  static const teacherSubjectUrl = '$baseUrl/teacher/subject';
  static const teacherOwnSubjectUrl = '$baseUrl/teacher/teacher-subject';
  static const teacherExamResultUrl = '$baseUrl/teacher/examResults';
  static const studentExamResultUrl = '$baseUrl/student/examResults';
  static const parentExamResultUrl = '$baseUrl/parent/examResults';
  static const studentAttendancesUrl = '$baseUrl/student/attendances';
  static const teacherAttendancesUrl = '$baseUrl/teacher/attendances';
  static const studentAttendancesForParentUrl = '$baseUrl/parent/attendances';
  static const studentHomeworksUrl = '$baseUrl/student/homeworks';
  static const parentHomeworksUrl = '$baseUrl/parent/homeworks';
  static const studentExamUrl = '$baseUrl/student/exams';
  static const studentExamsForParentUrl = '$baseUrl/parent/exams';
  static const teacherStudentEnrollmentUrl =
      '$baseUrl/teacher/student-enrollment';
  static const teacherHomeworksUrl = '$baseUrl/teacher/homeworks';
  static const studentLessonsUrl = '$baseUrl/student/lessons';
  static const teacherLessonsUrl = '$baseUrl/teacher/lessons';
  static const teacherLessonsAttachmentsUrl =
      '$baseUrl/teacher/lessons/attachments';
  static const studentLessonsFroParentUrl = '$baseUrl/parent/lessons';
  static const examScheduleUrl =
      '$baseUrl/section/schedule/student/sectionSchedule';
  static const studentNotHaveDegreesUrl =
      '$baseUrl/teacher/examResults/StudentsNotHaveDegree';
  static const studentScheduleUrl =
      '$baseUrl/section/schedule/student/sectionSchedule';
  static const studentScheduleForParentUrl =
      '$baseUrl/parent/section/schedule/sectionSchedule';

  static const teacherScheduleUrl =
      '$baseUrl/section/schedule/teacher/sectionSchedule';
  static const installmentUrl = '/student/installment/my-installment';
  static const otherPaymentUrl = '/student/other-payment/student';
  static const otherPaymentForParentUrl = '/parent/other-payment/parent';
  static const installmentForParentUrl =
      '/parent/installment/my-students-installments';
  static const complaintsUrl = '/complaint/forUser';
  static const complaintUrl = '/complaint';
  static const studentsList = '/teacher/student-enrollment/student/list';
  static const teacherHomeworkAttachmentsUrl = '/teacher/homeworks/attachments';

  // Chats urls
  static const studentChats = '/student/chat/my-chats';
  static const parentChats = '/parent/chat/my-chats';
  static const teacherChats = '/teacher/chat/my-chats';
  static const parentDirectMsgWithTeacher = '/parent/chat/direct-to-teacher';
  static const studentDirectMsgWithTeacher = '/student/chat/direct-to-teacher';
  static const teacherDirectMsgWithStudent = '/teacher/chat/direct-to-student';
  static const teacherDirectMsgWithAdmin = '/teacher/chat/direct-to-admin';
  static const parentConversationMessages = '/parent/chat/messages/direct';
  static const chatFilesUpload = '/chat/files/upload';
  static const studentTodayMessages = '/student/chat/today-messages';
  static const parentTodayMessages = '/parent/chat/today-messages';

  static const studentDashboardUrl = '/student/dashboard/calendar';
  static const parentDashboardUrl = '/parent/dashboard/calendar';

  // Attachments urls
  static const attachmentTypesUrl = '$baseUrl/att-types';
  static const attachmentUploadUrl = '$baseUrl/attachment';
  static const attachmentGetUrl = '$baseUrl/attachment/forUser';

  // Behaviors urls
  static const teacherBehaviorsStudentUrl =
      '$baseUrl/teacher/behaviors/student';
  static const teacherBehaviorsUrl = '$baseUrl/teacher/behaviors';
  static const teacherBehaviorSectionUrl = '$baseUrl/teacher/behaviorSection';
  static const teacherBehaviorTypeUrl = '$baseUrl/teacher/behaviorType';
  static const studentBehaviorsUrl = '$baseUrl/student/behaviors';
  static const parentBehaviorsUrl = '$baseUrl/parent/behaviors';

  // Online Exam URLs
  static const studentOnlineExamsUrl = '$baseUrl/student/online-exams';
  static const studentOnlineExamStartUrl = '$baseUrl/student/online-exams/start';
  static const studentOnlineExamSubmitUrl = '$baseUrl/student/online-exams/submit';
  static const studentOnlineExamResultUrl = '$baseUrl/student/online-exams/result';

  // Teacher Online Exam URLs
  static const teacherOnlineExamsUrl = '$baseUrl/teacher/online-exams';

  // Biometric Attendance
  static const studentBiometricAttendanceUrl = '$baseUrl/student/biometric-attendance';
  static const parentBiometricAttendanceUrl = '$baseUrl/parent/biometric-attendance';

  // School Code Verification (Public - no auth required)
  static const verifySchoolCodeUrl = '$baseUrl/public/school/verify-code';
}
