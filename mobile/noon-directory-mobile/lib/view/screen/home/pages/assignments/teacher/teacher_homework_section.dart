import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/view/widget/custom_appbar.dart';

import '../../../../../../controllers/homework_controller.dart';
import '../../../../../../core/constant/app_assets.dart';
import '../../../../../../core/constant/app_colors.dart';
import '../../../../../../core/constant/screens_urls.dart';
import '../../../../../../core/localization/language.dart';
import '../../../../../../models/homework_model.dart';
import '../../../../../widget/bottom_navbar.dart';
import '../../../../../widget/error_message.dart';
import '../../../../../widget/homework_card_widget.dart';
import '../../../../../widget/loading.dart';
import '../../../../../widget/no_data_widget.dart';
import '../../../../../widget/retry_btn.dart';

class TeacherHomeworkSection extends StatelessWidget {
  TeacherHomeworkSection({super.key});

  final _controller = Get.put(HomeworkController());

  @override
  Widget build(BuildContext context) {
    final controller =
        _controller.pagingController as PagingController<int, HomeworkModel>;
    final firstPageKey = controller.firstPageKey;
    final nextPageKey = controller.nextPageKey ?? 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null &&
          Get.arguments is Map &&
          Get.arguments['filtered'] == true) {
        controller.refresh();
      }
    });

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          appBarName: AppLanguage.homework.tr,
          isLeading: true,
          press: () => Get.back(),
        ),
        body: RefreshIndicator(
          onRefresh: () async => controller.refresh(),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const .all(0),
                sliver: PagedSliverList(
                  pagingController: controller,
                  builderDelegate: PagedChildBuilderDelegate<HomeworkModel>(
                    itemBuilder: (context, item, index) {
                      return HomeworkCard(
                        borderColor: AppColors.mainColor,
                        homework: item,
                        onEditPressed: () {
                          _controller.homeworkId(item.id);
                          _controller.sectionId(item.sectionId);
                          _controller.selectedDate(
                            item.dueDate.formatDateToYearMonthDay,
                          );
                          _controller.title(item.title);
                          _controller.description(item.content);
                          _controller.titleController.text = item.title;
                          _controller.descController.text = item.content;
                          _controller.files.clear();
                          _controller.files.addAll(
                            _controller.attachmentsUrls(
                              item.attachments.toList(),
                            ),
                          );
                          Get.toNamed(
                            ScreensUrls.addHomeworkTeacherScreenUrl,
                            arguments: true,
                          );
                        },
                        onPressedDelete: () async {
                          if (!_controller.isWaiting.value) {
                            _controller.deleteHomework(item.id!);
                            _controller.isWaiting.value = true;
                            await Future.delayed(
                              const Duration(seconds: 1),
                              () {
                                _controller.isWaiting.value = false;
                              },
                            );
                          }
                        },
                      );
                    },
                    firstPageErrorIndicatorBuilder: (_) => ErrorMessage(
                      press: () => _controller.getHomeworks(firstPageKey),
                      errorMsg: AppLanguage.errorStr.tr,
                    ),
                    newPageErrorIndicatorBuilder: (_) => RetryBtn(
                      press: () => _controller.getHomeworks(nextPageKey),
                    ),
                    firstPageProgressIndicatorBuilder: (_) => const Loading(),
                    newPageProgressIndicatorBuilder: (_) => const Loading(),
                    noItemsFoundIndicatorBuilder: (_) => SizedBox(
                      height: Get.height * 0.6,
                      child: Center(
                        child: NoDataWidget(
                          title: AppLanguage.noInfoAvailable.tr,
                        ),
                      ),
                    ),
                    noMoreItemsIndicatorBuilder: (_) => const SizedBox(),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: BottomNavbar(
            backgroundColor: Colors.transparent,
            text: AppLanguage.icAddNewHomework.tr,
            icon: AppAssets.icAdd,
            onTap: () => Get.toNamed(ScreensUrls.addHomeworkTeacherScreenUrl),
          ),
        ),
      ),
    );
  }
}
