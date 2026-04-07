import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/controllers/communication_controller.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/models/chat_room_data.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import '../../controllers/teaching_staf_controller.dart';
import '../../core/constant/app_assets.dart';
import '../../core/constant/app_colors.dart';
import '../../models/teaching_staff_model.dart';
import '../widget/error_message.dart';
import '../widget/loading.dart';
import '../widget/no_data_widget.dart';
import '../widget/retry_btn.dart';
import '../widget/teacher_card_widget.dart';

class CommunicationScreen extends StatelessWidget {
  CommunicationScreen({super.key});

  final _pages = [DirectMessages(), GroupsPage(), TeachingStaffPage()];

  final controller = Get.find<CommunicationController>();
  final gController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(isLeading: true),
      body: controller.obx(
        (data) {
          return PageView.builder(
            controller: controller.pageController,
            itemBuilder: (_, i) => _pages[i],
            itemCount: _pages.length,
          );
        },
        onLoading: const Center(child: Loading()),
        onError: (e) => ErrorMessage(press: controller.fetchChats, errorMsg: e),
      ),
      bottomNavigationBar: controller.obx(
        (items) {
          return GetX<GlobalController>(
            builder: (_) {
              return BottomNavigationBar(
                backgroundColor: Colors.white,
                currentIndex: controller.selectedPageIndex.value,
                onTap: controller.changePage,
                items: [
                  _bottomNavBarItem(
                    label: AppLanguage.chat.tr,
                    icon: AppAssets.icChat,
                    isActive: controller.selectedPageIndex.value == 0,
                  ),
                  _bottomNavBarItem(
                    label: AppLanguage.groups.tr,
                    icon: AppAssets.icGroup,
                    isActive: controller.selectedPageIndex.value == 1,
                  ),
                  if (!Get.find<GlobalController>().isTeacher)
                    _bottomNavBarItem(
                      label: AppLanguage.teachers.tr,
                      icon: AppAssets.icUsers,
                      isActive: controller.selectedPageIndex.value == 2,
                    ),
                ],
              );
            },
          );
        },
        onLoading: const SizedBox.shrink(),
        onError: (_) => const SizedBox.shrink(),
      ),
    );
  }

  BottomNavigationBarItem _bottomNavBarItem({
    required String label,
    required String icon,
    required bool isActive,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        icon,
        colorFilter: isActive
            ? const ColorFilter.mode(AppColors.mainColor, BlendMode.srcIn)
            : null,
      ),
      label: label,
    );
  }
}

class DirectMessages extends StatelessWidget {
  DirectMessages({super.key});

  final controller = Get.find<CommunicationController>();

  @override
  Widget build(BuildContext context) {
    return controller.directMessages.isEmpty
        ? NoDataWidget(title: AppLanguage.noConversations.tr)
        : ListView.builder(
            itemBuilder: (_, i) =>
                ConversationCard(data: controller.directMessages[i]),
            itemCount: controller.directMessages.length,
          );
  }
}

class GroupsPage extends StatelessWidget {
  GroupsPage({super.key});

  final controller = Get.find<CommunicationController>();

  @override
  Widget build(BuildContext context) {
    return controller.groups.isEmpty
        ? NoDataWidget(title: AppLanguage.noGroups.tr)
        : ListView.builder(
            itemBuilder: (_, i) => ConversationCard(data: controller.groups[i]),
            itemCount: controller.groups.length,
          );
  }
}

class TeachingStaffPage extends StatelessWidget {
  TeachingStaffPage({super.key});

  final controller = Get.find<TeachingStafController>();
  final communicationController = Get.find<CommunicationController>();

  @override
  Widget build(BuildContext context) {
    return PagedListView.separated(
      pagingController: controller.pagingController,
      builderDelegate: PagedChildBuilderDelegate<TeachingStaffModel>(
        itemBuilder: (context, item, index) {
          final subjects = item.teacherSubject
              ?.map((e) => e.stageSubject?.subject?.name)
              .where((name) => name != null)
              .toList();
          return InkWell(
            onTap: () {
              communicationController.createDirectMsgChat(teacherId: item.id);
            },
            child: TeacherCard(
              comController: communicationController,
              id: item.id,
              gender: item.gender ?? '',
              photoUrl: item.photo ?? '',
              fullName: item.fullName ?? '',
              subjects: subjects,
            ),
          );
        },
        firstPageErrorIndicatorBuilder: (_) => ErrorMessage(
          press: () {
            controller.getTeachers(controller.pagingController.firstPageKey);
          },
          errorMsg: AppLanguage.errorStr.tr,
        ),
        newPageErrorIndicatorBuilder: (_) => RetryBtn(
          press: () {
            controller.getTeachers(
              controller.pagingController.nextPageKey ?? 0,
            );
          },
        ),
        firstPageProgressIndicatorBuilder: (_) => const Loading(),
        newPageProgressIndicatorBuilder: (_) => const Loading(),
        noItemsFoundIndicatorBuilder: (_) =>
            NoDataWidget(title: AppLanguage.noInfoAvailable.tr),
        noMoreItemsIndicatorBuilder: (_) => const SizedBox(),
      ),
      separatorBuilder: (_, _) => const SizedBox(height: 16),
    );
  }
}

class ConversationCard extends StatelessWidget {
  ConversationCard({super.key, required this.data});

  final ChatRoomData data;

  final controller = Get.find<CommunicationController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.gray300Color, width: 1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.toNamed(
              ScreensUrls.conversationScreenUrl,
              arguments: {
                'roomId': data.rocketChatId,
                'roomName': data.name,
                'schoolId': data.schoolId,
              },
            );
          },
          child: ListTile(
            title: Text(data.name, style: AppTextStyles.textSemiBold12),
            subtitle: Text(
              data.isActive ? AppLanguage.active.tr : AppLanguage.inactive.tr,
              style: AppTextStyles.textMedium10.copyWith(
                color: data.isActive
                    ? AppColors.green600
                    : AppColors.black37Color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
