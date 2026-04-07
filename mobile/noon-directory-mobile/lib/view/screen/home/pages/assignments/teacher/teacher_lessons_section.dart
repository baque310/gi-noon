import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/core/extensions/string_extension.dart';
import '../../../../../../controllers/homework_completed_controller.dart';
import '../../../../../../core/constant/app_assets.dart';
import '../../../../../../core/constant/screens_urls.dart';
import '../../../../../../core/localization/language.dart';
import '../../../../../../models/lesson_model.dart';
import '../../../../../../view/widget/custom_appbar.dart';
import '../../../../../widget/bottom_navbar.dart';
import '../../../../../widget/card_with_multi_img.dart';
import '../../../../../widget/error_message.dart';
import '../../../../../widget/loading.dart';
import '../../../../../widget/no_data_widget.dart';
import '../../../../../widget/retry_btn.dart';

class TeacherLessonSection extends StatelessWidget {
  TeacherLessonSection({super.key});

  final _controller = Get.put(HomeworkCompletedController());

  @override
  Widget build(BuildContext context) {
    final controller =
        _controller.pagingController as PagingController<int, LessonModel>;
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
          appBarName: AppLanguage.lessons.tr,
          isLeading: true,
          press: () => Get.back(),
        ),
        body: RefreshIndicator(
          onRefresh: () async => _controller.pagingController.refresh(),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const .all(0),
                sliver: PagedSliverList(
                  pagingController: controller,
                  builderDelegate: PagedChildBuilderDelegate<LessonModel>(
                    itemBuilder: (context, item, index) {
                      return CardWithMultiImg(
                        isTeacher: true,
                        borderColor: AppColors.mainColor,
                        onPressedDelete: () async {
                          if (!_controller.isWaiting.value) {
                            _controller.deleteLesson(item.id);
                            _controller.isWaiting.value = true;
                            await Future.delayed(
                              const Duration(seconds: 1),
                              () {
                                _controller.isWaiting.value = false;
                              },
                            );
                          }
                        },
                        onPressed: () {
                          //Patch or edit card press
                          _controller.lessonId(item.id);
                          _controller.title(item.title);
                          _controller.description(item.content);
                          _controller.titleController.text = item.title;
                          _controller.descController.text = item.content;

                          _controller.images.value = item.lessonAttachment
                              .map((e) => "${e.url.imgUrlToFullUrl}")
                              .toList();
                          _controller.imagesModels = item.lessonAttachment
                              .toList();

                          Get.toNamed(
                            ScreensUrls.addLessonTeacherScreenUrl,
                            arguments: true,
                          );
                        },
                        img: item.lessonAttachment.toList(),
                        mainTitle: item.title,
                        addDate:
                            "${AppLanguage.createdAtStr.tr} ${item.createdAt.formatDateToYearMonthDay}",
                        title:
                            "${AppLanguage.subjectStr.tr}: ${item.teacherSubject.stageSubject?.subject?.name ?? ''}",
                        desc:
                            "${AppLanguage.detailsSimiStr.tr} ${item.content}",
                      );
                    },
                    firstPageErrorIndicatorBuilder: (_) => ErrorMessage(
                      press: () =>
                          _controller.getHomeWorksCompleted(firstPageKey),
                      errorMsg: AppLanguage.errorStr.tr,
                    ),
                    newPageErrorIndicatorBuilder: (_) => RetryBtn(
                      press: () =>
                          _controller.getHomeWorksCompleted(nextPageKey),
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
                    noMoreItemsIndicatorBuilder: (_) => const SizedBox.shrink(),
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
            text: AppLanguage.icAddNewLesson.tr,
            icon: AppAssets.icAdd,
            onTap: () => Get.toNamed(ScreensUrls.addLessonTeacherScreenUrl),
          ),
        ),
      ),
    );
  }
}
