import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/controllers/notifications_controller.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/models/notification_model.dart';
import 'package:noon/view/widget/app_tab_bar.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/custom_inkwell.dart';
import 'package:noon/view/widget/error_message.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:noon/view/widget/retry_btn.dart';
import 'package:s_extensions/extensions/datetime_ext.dart';
import 'package:s_extensions/extensions/string_ext.dart';
import '../../core/localization/language.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _controller = Get.find<NotificationsController>();
  final _gController = Get.find<GlobalController>();

  late final List<String> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      AppLanguage.all.tr,
      AppLanguage.messages.tr,
      AppLanguage.homework.tr,
      AppLanguage.lessons.tr,
      AppLanguage.examsStr.tr,
      AppLanguage.aqsatiStr.tr,
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          appBarName: AppLanguage.notificationStr.tr,
          isLeading: true,
          press: () => Get.back(),
          bottom: _gController.isTeacher
              ? null
              : AppTabBar(
                  tabs: _tabs,
                  controller: _controller.tabController,
                  onTap: (index) {
                    _controller.changePage(index);
                  },
                ),
        ),
        body: PageView.builder(
          controller: _controller.pageController,
          onPageChanged: _controller.onPageChanged,
          itemCount: _tabs.length,
          itemBuilder: (context, index) {
            final controller = _controller.pagingControllers[index];
            final firstPageKey = controller.firstPageKey;
            final nextPageKey = controller.nextPageKey ?? 0;
            return _buildNotificationPage(
              controller,
              firstPageKey,
              nextPageKey,
              index,
            );
          },
        ),
    );
  }

  Widget _notificationCard(NotificationModel notification, int index) {
    final isSeen = notification.isSeen != "FALSE";
    final type = notification.data?.type ?? '';

    String icon;
    Color iconColor;
    var title = notification.title;

    switch (type) {
      case 'lesson':
        icon = AppAssets.icLessons;
        iconColor = AppColors.mainColor;
        break;
      case 'exam':
        icon = AppAssets.icExamTableV2;
        iconColor = AppColors.bubbleGreenColor;
        break;
      case 'studentInstallment':
      case 'payment_reminder':
      case 'payment_overdue':
        icon = AppAssets.icAqsateV2;
        iconColor = AppColors.green500;
        break;
      case 'sectionSchedule':
        icon = AppAssets.icTableV2;
        iconColor = AppColors.mainColor;
        break;
      case 'complaints':
        icon = AppAssets.icComplaints;
        iconColor = AppColors.errorRedColor;
        break;
      case 'gallery':
        icon = AppAssets.icGalleryV2;
        iconColor = AppColors.primary;
        break;
      case 'guidance':
        icon = AppAssets.icInstructionsV2;
        iconColor = AppColors.primary;
        break;
      case 'attendance':
        icon = AppAssets.icAttendanceV2;
        iconColor = AppColors.errorRedColor;
        break;
      case 'exam_result':
        icon = AppAssets.icMarksV2;
        iconColor = AppColors.green500;
        break;
      case 'homework':
        icon = AppAssets.icAssignmentV2;
        iconColor = AppColors.primary;
        break;
      case 'behavior':
        icon = AppAssets
            .icInstructionsV2; // Using instruction icon since behavior might not have a dedicated icon yet, or we can use icMarksV2
        iconColor = AppColors.mainColor;
        break;
      default:
        icon = AppAssets.icNotification;
        iconColor = AppColors.secondryOringe;
        title = title?.replaceFirst('جديدة ', '');
        break;
    }

    return CustomInkwell(
      key: ValueKey('notification-${notification.id}-$index'),
      onTap: () async =>
          await _controller.handleNotificationClick(notification),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.grey.withOpacity(0.35), width: 1.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                icon,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title ?? '',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSeen
                                ? FontWeight.w600
                                : FontWeight.bold,
                            color: const Color(0xff2A3336),
                          ),
                        ),
                      ),
                      if (!isSeen)
                        Container(
                          margin: const EdgeInsets.only(right: 8, top: 6),
                          height: 8,
                          width: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.redColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.body ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationPage(
    PagingController<int, NotificationModel> controller,
    int firstPageKey,
    int nextPageKey,
    int pageIndex,
  ) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(
            left: 16,
            top: 16,
            bottom: 24,
            right: 16,
          ),
          sliver: PagedSliverList(
            pagingController: controller,
            builderDelegate: PagedChildBuilderDelegate<NotificationModel>(
              itemBuilder: (context, item, index) {
                final controllerList = controller.itemList;
                bool isFirstOfDay = true;
                if (index > 0 && controllerList != null) {
                  final prevItem = controllerList[index - 1];
                  final prevDate =
                      prevItem.updatedAt.toDate?.formatYearMonthDay;
                  final currDate = item.updatedAt.toDate?.formatYearMonthDay;
                  if (prevDate == currDate) {
                    isFirstOfDay = false;
                  }
                }

                String dateHeader = '';
                if (isFirstOfDay) {
                  final currDateObj = item.updatedAt.toDate;
                  if (currDateObj != null) {
                    final now = DateTime.now();
                    if (currDateObj.year == now.year &&
                        currDateObj.month == now.month &&
                        currDateObj.day == now.day) {
                      dateHeader = 'اليوم';
                    } else if (currDateObj.year == now.year &&
                        currDateObj.month == now.month &&
                        currDateObj.day == now.day - 1) {
                      dateHeader = 'الأمس';
                    } else {
                      dateHeader = currDateObj.formatYearMonthDay;
                    }
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isFirstOfDay && dateHeader.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(
                          top: index == 0 ? 0 : 16.0,
                          bottom: 12.0,
                          right: 4.0,
                        ),
                        child: Text(
                          dateHeader,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(bottom: getDynamicHeight(12)),
                      child: _notificationCard(item, index),
                    ),
                  ],
                );
              },
              firstPageErrorIndicatorBuilder: (_) => ErrorMessage(
                press: () =>
                    _controller.getNotifications(firstPageKey, type: pageIndex),
                errorMsg: AppLanguage.errorStr.tr,
              ),
              newPageErrorIndicatorBuilder: (_) => RetryBtn(
                press: () =>
                    _controller.getNotifications(nextPageKey, type: pageIndex),
              ),
              firstPageProgressIndicatorBuilder: (_) => const Loading(),
              newPageProgressIndicatorBuilder: (_) => const Loading(),
              noItemsFoundIndicatorBuilder: (_) =>
                  NoDataWidget(title: AppLanguage.noInfoAvailable.tr),
              noMoreItemsIndicatorBuilder: (_) => const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }
}
