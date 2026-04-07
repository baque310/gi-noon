import 'package:get/get.dart';
import 'package:noon/core/constant/screens_urls.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _goToHome();
  }

  Future<void> _goToHome() async {
    // Show splash for 2 seconds then go directly to directory home
    await Future.delayed(const Duration(seconds: 2));
    Get.offAllNamed(ScreensUrls.guestHomeUrl);
  }
}
