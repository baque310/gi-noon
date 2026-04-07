import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/controllers/home_controller.dart';
import 'package:noon/controllers/profile_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/view/screen/home/pages/assignments/assignments_tabs_screen.dart';
import 'package:noon/view/screen/home/pages/calendar/calendar_screen.dart';
import 'package:noon/view/screen/home/pages/main/main_screen.dart';
import 'package:noon/view/screen/home/widgets/custom_animated_nav_bar.dart';
import 'package:noon/view/screen/home/pages/profile/profile_screen.dart';
import 'package:noon/view/screen/communications/communication_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.find();
  final gController = Get.find<GlobalController>();
  final profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    // Set correct default index based on user type
    // Students/Parents: 5 tabs, Home at index 2
    // Teachers: 3 tabs, Home at index 1
    final defaultIdx = gController.isTeacher ? 1 : 2;
    controller.selectedIndex.value = defaultIdx;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await gController.checkForUpdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ===== Layout (RTL: visually right-to-left) =====
    // In RTL, Row renders index 0 at the RIGHT side.
    //
    // For Student/Parent (5 tabs, RTL visual right→left):
    //   Index 0: الدردشات (Chat) - far RIGHT ← with badge
    //   Index 1: الواجبات (Homework) - right of center
    //   Index 2: الرئيسية (Home) - CENTER (default)
    //   Index 3: التقويم (Calendar) - left of center
    //   Index 4: الحساب (Account) - far LEFT
    //
    // For Teacher (3 tabs, RTL visual right→left):
    //   Index 0: الدردشات (Chat) - RIGHT ← with badge
    //   Index 1: الرئيسية (Home) - CENTER (default)
    //   Index 2: الحساب (Account) - LEFT

    final bool isTeacher = gController.isTeacher;
    final int defaultIndex = isTeacher ? 1 : 2;

    final List<Widget> pages = isTeacher
        ? [
            CommunicationScreen(isLeading: false),          // 0: الدردشات
            MainScreen(),                                   // 1: الرئيسية
            ProfileScreen(),                                // 2: الحساب
          ]
        : [
            CommunicationScreen(isLeading: false),          // 0: الدردشات
            const AssignmentsTabsScreen(),                  // 1: الواجبات
            MainScreen(),                                   // 2: الرئيسية
            const CalendarScreen(),                         // 3: التقويم
            ProfileScreen(),                                // 4: الحساب
          ];

    return Obx(() {
      final unreadCount = profileController.unreadMessagesCount.value;

      List<CustomNavItem> navItems = [
        // 0: الدردشات (Chat) — far RIGHT in RTL, with unread badge
        CustomNavItem(
          activeIcon: SvgPicture.asset(
            AppAssets.icChatOutlineV2,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          inactiveIcon: SvgPicture.asset(
            AppAssets.icChatOutlineV2,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.neutralMidGrey,
              BlendMode.srcIn,
            ),
          ),
          label: AppLanguage.chat.tr,
          badgeCount: unreadCount,
        ),
        // 1: الواجبات (Homework) — right of center (only for student/parent)
        if (!isTeacher)
          CustomNavItem(
            activeIcon: SvgPicture.asset(
              AppAssets.icAssignmentV2,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            inactiveIcon: SvgPicture.asset(
              AppAssets.icAssignmentV2,
              colorFilter: const ColorFilter.mode(
                AppColors.neutralMidGrey,
                BlendMode.srcIn,
              ),
            ),
            label: AppLanguage.homework.tr,
          ),
        // 2: الرئيسية (Home) — CENTER
        CustomNavItem(
          activeIcon: SvgPicture.asset(
            AppAssets.icMainV2,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          inactiveIcon: SvgPicture.asset(
            AppAssets.icMainV2,
            colorFilter: const ColorFilter.mode(
              AppColors.neutralMidGrey,
              BlendMode.srcIn,
            ),
          ),
          label: AppLanguage.home.tr,
        ),
        // 3: التقويم (Calendar) — left of center (only for student/parent)
        if (!isTeacher)
          CustomNavItem(
            activeIcon: SvgPicture.asset(
              AppAssets.icCalendarV3,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            inactiveIcon: SvgPicture.asset(
              AppAssets.icCalendarV3,
              colorFilter: const ColorFilter.mode(
                AppColors.neutralMidGrey,
                BlendMode.srcIn,
              ),
            ),
            label: AppLanguage.calendar.tr,
          ),
        // 4: الحساب (Account) — far LEFT in RTL
        CustomNavItem(
          activeIcon: SvgPicture.asset(
            AppAssets.icProfileV2,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          inactiveIcon: SvgPicture.asset(
            AppAssets.icProfileV2,
            colorFilter: const ColorFilter.mode(
              AppColors.neutralMidGrey,
              BlendMode.srcIn,
            ),
          ),
          label: AppLanguage.account.tr,
        ),
      ];

      // Safety: clamp selectedIndex to valid range
      if (controller.selectedIndex.value >= pages.length) {
        controller.selectedIndex.value = defaultIndex;
      }

      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (controller.selectedIndex.value != defaultIndex) {
            controller.changePage(defaultIndex);
          } else {
            Get.back(closeOverlays: true);
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          body: pages[controller.selectedIndex.value],
          bottomNavigationBar: CustomAnimatedNavBar(
            selectedIndex: controller.selectedIndex.value,
            activeColor: AppColors.primary,
            centerIndex: defaultIndex,
            onItemSelected: (i) {
              controller.changePage(i);
            },
            items: navItems,
          ),
        ),
      );
    });
  }
}
