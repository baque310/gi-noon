import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/communication_controller.dart';

import 'package:noon/view/screen/communications/direct_messages_page.dart';
import 'package:noon/view/screen/communications/groups_page.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import '../../widget/error_message.dart';
import '../../widget/loading.dart';

class CommunicationScreen extends StatelessWidget {
  final bool isLeading;
  CommunicationScreen({super.key, this.isLeading = true});

  final _pages = [DirectMessages(), GroupsPage()];
  final controller = Get.find<CommunicationController>();

  Widget _buildTabWithBadge(String label, int count, IconData icon) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(width: getDynamicWidth(8)),
          Icon(icon, size: 20),
          if (count > 0) ...[
            SizedBox(width: getDynamicWidth(4)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.redColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: AppTextStyles.semiBold10.copyWith(color: Colors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isLeading: isLeading,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(getDynamicHeight(70)),
          child: GetBuilder<CommunicationController>(
            builder: (_) {
              return Container(
                height: getDynamicHeight(50),
                margin: EdgeInsets.symmetric(
                  horizontal: getDynamicWidth(24),
                  vertical: getDynamicHeight(10),
                ),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF1F7), // Light Grayish Blue
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  labelColor: AppColors.primary,
                  unselectedLabelColor: const Color(0xFF64748B), // Slate Grey
                  dividerColor: Colors.transparent, // remove default underline
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.zero,
                  onTap: (index) => controller.changePage(index),
                  controller: controller.tabController,
                  tabs: [
                    _buildTabWithBadge(
                      'خاصة',
                      controller.unreadDirectMessagesCount,
                      Icons.person_rounded,
                    ),
                    _buildTabWithBadge(
                      'المجموعات',
                      controller.unreadGroupsCount,
                      Icons.people_rounded,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      body: controller.obx(
        (data) => PageView.builder(
          controller: controller.pageController,
          onPageChanged: controller.onPageChanged,
          itemBuilder: (_, i) => _pages[i],
          itemCount: _pages.length,
        ),
        onLoading: const Center(child: Loading()),
        onError: (e) => ErrorMessage(press: controller.fetchChats, errorMsg: e),
      ),
    );
  }
}
