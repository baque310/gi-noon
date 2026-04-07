import 'package:get/get.dart';
import 'package:noon/controllers/guest_home_controller.dart';
import 'package:noon/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}

class GuestHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GuestHomeController(), permanent: true);
  }
}
