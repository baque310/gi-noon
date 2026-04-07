import 'package:get/get.dart';
import 'package:noon/controllers/installments_controller.dart';
import 'package:noon/controllers/attendances_controller.dart';
import 'package:noon/controllers/communication_controller.dart';
import 'package:noon/controllers/complaints_controller.dart';
import 'package:noon/controllers/conversation_controller.dart';
import 'package:noon/controllers/exam_schedule_controller.dart';
import 'package:noon/controllers/gallery_controller.dart';
import 'package:noon/controllers/guest_home_controller.dart';
import 'package:noon/controllers/home_controller.dart';
import 'package:noon/controllers/school_code_controller.dart';
import 'package:noon/controllers/instructions_controller.dart';
import 'package:noon/controllers/library_controller.dart';
import 'package:noon/controllers/lines_controller.dart';
import 'package:noon/controllers/login_controller.dart';
import 'package:noon/controllers/notifications_controller.dart';
import 'package:noon/controllers/onboarding_controller.dart';
import 'package:noon/controllers/profile_controller.dart';
import 'package:noon/controllers/school_schedule_controller.dart';
import 'package:noon/controllers/splash_controller.dart';
import 'package:noon/controllers/teacher_degrees_controller.dart';
import 'package:noon/controllers/teaching_staf_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(ProfileController());
    // Chat is now a tab inside HomeScreen, so register its controller here
    Get.put(CommunicationController());
    Get.put(TeachingStafController());
  }
}

class SelectChildBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileController());
  }
}

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OnboardingController());
  }
}

class InstructionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InstructionsController());
  }
}

class GalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GalleryController());
  }
}

class TeachingStafBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TeachingStafController());
  }
}

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationsController());
  }
}

class LinesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LinesController());
  }
}

class SchoolScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SchoolScheduleController());
  }
}

class LibraryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LibraryController());
  }
}

class TeacherDegreesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TeacherDegreesController());
  }
}

class AttendancesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AttendancesController());
  }
}

class ExamScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ExamScheduleController());
  }
}

class InstallmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InstallmentsController());
  }
}

class ComplaintsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ComplaintsController());
  }
}

class CommunicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CommunicationController());
    Get.put(TeachingStafController());
  }
}

class ConversationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ConversationController());
  }
}

class SchoolCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SchoolCodeController());
  }
}

class GuestHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GuestHomeController(), permanent: true);
  }
}
