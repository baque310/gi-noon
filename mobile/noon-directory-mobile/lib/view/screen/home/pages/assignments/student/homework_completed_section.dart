import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:s_extensions/s_extensions.dart';
import 'package:noon/models/lesson_subject_model.dart';
import '../../../../../../controllers/global_controller.dart';
import '../../../../../../controllers/homework_completed_controller.dart';
import '../../../../../../controllers/homework_controller.dart';
import '../../../../../../core/constant/app_assets.dart';
import '../../../../../../core/constant/app_colors.dart';
import '../../../../../../core/constant/app_sizes.dart';
import '../../../../../../core/constant/app_text_style.dart';
import '../../../../../../core/constant/screens_urls.dart';
import '../../../../../../core/localization/language.dart';
import '../../../../../widget/error_message.dart';
import '../../../../../widget/lesson_subject_card_widget.dart';
import '../../../../../widget/loading.dart';
import '../../../../../widget/no_data_widget.dart';
import '../../../../../widget/retry_btn.dart';

class HomeWorksCompletedSection extends StatelessWidget {
  HomeWorksCompletedSection({super.key});

  final _controller = Get.put(HomeworkCompletedController());

  @override
  Widget build(BuildContext context) {
    final controller =
        _controller.pagingController
            as PagingController<int, LessonSubjectModel>;
    final firstPageKey = controller.firstPageKey;
    final nextPageKey = controller.nextPageKey ?? 0;

    return RefreshIndicator(
      onRefresh: () async => _controller.pagingController.refresh(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const .only(bottom: 12),
              child: FutureBuilder<List<LessonSubjectModel>>(
                future: _controller.getLessonsForTodayForStudent(),
                builder: (context, response) {
                  if (response.connectionState != .done || !response.hasData) {
                    return Container();
                  }
                  final lessonSubjects = response.data!;
                  return TodayLessonsWidget(lessonSubjects);
                },
              ),
            ),
          ),
          SliverPadding(
            padding: .zero,
            sliver: PagedSliverList.separated(
              pagingController: controller,
              separatorBuilder: (context, index) =>
                  SizedBox(height: getDynamicHeight(12)),
              builderDelegate: PagedChildBuilderDelegate<LessonSubjectModel>(
                itemBuilder: (context, item, index) {
                  return LessonSubjectCardWidget(
                    subject: item,
                    onPressed: () {
                      Get.toNamed(
                        ScreensUrls.studentLessonsScreenUrl,
                        arguments: {'lessons': item.lessons!.toList()},
                      );
                    },
                  );
                },
                firstPageErrorIndicatorBuilder: (_) => ErrorMessage(
                  press: () => _controller.getHomeWorksCompleted(firstPageKey),
                  errorMsg: AppLanguage.errorStr.tr,
                ),
                newPageErrorIndicatorBuilder: (_) => RetryBtn(
                  press: () => _controller.getHomeWorksCompleted(nextPageKey),
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
      ),
    );
  }
}

class TodayLessonsWidget extends StatelessWidget {
  TodayLessonsWidget(this.lessonSubjects, {super.key});

  final controller = Get.put(HomeworkController());
  final gController = Get.find<GlobalController>();
  final List<LessonSubjectModel> lessonSubjects;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openTodayLessons,
      child: Container(
        height: getDynamicHeight(56),
        padding: .symmetric(horizontal: getDynamicWidth(12)),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: .circular(10),
        ),
        child: Row(
          children: [
            SvgPicture.asset(AppAssets.icHomeworkV2, width: 30),
            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: .start,
              mainAxisAlignment: .center,
              children: [
                Text(
                  '${lessonSubjects.fold(0, (previousValue, element) => element.lessons?.length ?? 0)} ${AppLanguage.lessonsToday.tr}',
                  style: AppTextStyles.bold16.copyWith(color: Colors.white),
                ),
                Text(
                  DateTime.now().format(
                    'EEE, dd MMM yyyy',
                    locale: gController.locale,
                  ),
                  style: AppTextStyles.regular16.copyWith(color: Colors.white),
                ),
              ],
            ).expanded(),
            const SizedBox(width: 12),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  void openTodayLessons() {
    if (lessonSubjects.isNotEmpty) {
      Get.toNamed(
        ScreensUrls.studentLessonsScreenUrl,
        arguments: {
          'lessons': lessonSubjects.fold(
            [],
            (previousValue, element) => element.lessons!.toList(),
          ),
        },
      );
    } else {
      // controller.showNoHomeworksToast();
    }
  }
}
