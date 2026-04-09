import 'package:get/get_navigation/get_navigation.dart';
import 'package:noon/bindings.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/view/screen/splash_screen.dart';
import 'package:noon/view/screen/main_nav_screen.dart';
import 'package:noon/view/screen/notifications_screen.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(
    name: ScreensUrls.splashScreenUrl,
    page: () => const SplashScreen(),
    transition: Transition.noTransition,
    binding: SplashBinding(),
  ),
  GetPage(
    name: ScreensUrls.guestHomeUrl,
    page: () => const MainNavScreen(),
    binding: GuestHomeBinding(),
  ),
  GetPage(
    name: ScreensUrls.notificationsUrl,
    page: () => const NotificationsScreen(),
  ),
];
