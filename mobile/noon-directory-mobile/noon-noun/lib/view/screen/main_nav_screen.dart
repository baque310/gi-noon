import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/view/screen/guest_home_screen.dart';
import 'package:noon/view/screen/jobs_screen.dart';
import 'package:noon/view/widget/custom_animated_nav_bar.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 1; // Default: الرئيسية (center)

  final List<Widget> _pages = [
    const JobsScreen(),      // 0: الوظائف
    const GuestHomeScreen(), // 1: الرئيسية (default)
    const SizedBox(),        // 2: الحساب (placeholder)
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (_selectedIndex != 1) {
            setState(() => _selectedIndex = 1);
          } else {
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
          bottomNavigationBar: CustomAnimatedNavBar(
            selectedIndex: _selectedIndex,
            activeColor: AppColors.primary,
            centerIndex: 1,
            onItemSelected: (i) {
              if (i == 2) return; // الحساب معطّل مؤقتاً
              setState(() => _selectedIndex = i);
            },
            items: [
              // 0: الوظائف (far RIGHT in RTL)
              CustomNavItem(
                activeIcon: const Icon(Icons.work_rounded, color: Colors.white, size: 24),
                inactiveIcon: Icon(Icons.work_outline_rounded, color: AppColors.neutralMidGrey, size: 24),
                label: 'الوظائف',
              ),
              // 1: الرئيسية (CENTER - default)
              CustomNavItem(
                activeIcon: const Icon(Icons.home_rounded, color: Colors.white, size: 24),
                inactiveIcon: Icon(Icons.home_outlined, color: AppColors.neutralMidGrey, size: 24),
                label: 'الرئيسية',
              ),
              // 2: الحساب (far LEFT in RTL)
              CustomNavItem(
                activeIcon: const Icon(Icons.person_rounded, color: Colors.white, size: 24),
                inactiveIcon: Icon(Icons.person_outline_rounded, color: AppColors.neutralMidGrey.withValues(alpha: 0.4), size: 24),
                label: 'الحساب',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
