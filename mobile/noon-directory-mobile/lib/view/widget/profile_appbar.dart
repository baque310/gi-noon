import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/view/widget/profile_action_button.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onLogout;
  final VoidCallback onEdit;

  const ProfileAppBar({
    super.key,
    required this.onLogout,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const .symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          // ? Logout button
          ProfileActionButton(
            onTap: onLogout,
            icon: Icons.logout_rounded,
            title: AppLanguage.logoutStr.tr,
            color: AppColors.redColor,
            isHorizontal: true,
          ),

          // ? Edit button
          ProfileActionButton(
            onTap: onEdit,
            icon: Icons.edit_rounded,
            title: AppLanguage.edit.tr,
            isHorizontal: true,
            flipIcon: true,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => .fromHeight(getDynamicHeight(60));
}
