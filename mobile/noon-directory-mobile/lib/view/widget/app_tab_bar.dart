import 'package:flutter/material.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';

class AppTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final TabController? controller;
  final void Function(int index)? onTap;
  final bool isScrollable;
  const AppTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTap,
    this.isScrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: AppColors.primary,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.neutralMidGrey,
      isScrollable: isScrollable,
      indicatorPadding: EdgeInsetsGeometry.symmetric(
        horizontal: isScrollable ? getDynamicWidth(12) : getDynamicWidth(45),
      ),
      indicator: UnderlineTabIndicator(
        borderRadius: .vertical(top: Radius.circular(getDynamicHeight(3))),
        borderSide: BorderSide(
          color: AppColors.primary,
          width: getDynamicHeight(3),
        ),
      ),
      tabs: tabs.map((e) => Tab(text: e)).toList(),
      onTap: onTap,
      controller: controller,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(getDynamicHeight(40));
}
