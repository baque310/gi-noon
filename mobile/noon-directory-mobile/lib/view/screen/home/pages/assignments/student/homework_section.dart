import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:s_extensions/s_extensions.dart';
import '../../../../../../controllers/global_controller.dart';
import '../../../../../../controllers/homework_controller.dart';
import '../../../../../../core/constant/app_assets.dart';
import '../../../../../../core/constant/app_colors.dart';
import '../../../../../../core/constant/app_text_style.dart';
import '../../../../../../core/localization/language.dart';
import '../../../../../../models/homework_subject_model.dart';
import '../../../../../widget/error_message.dart';
import '../../../../../widget/loading.dart';
import '../../../../../widget/no_data_widget.dart';
import '../../../../../widget/retry_btn.dart';
import '../../../../../widget/homework_subject_card_widget.dart';

class HomeworksSection extends StatelessWidget {
  HomeworksSection({super.key});

  final _controller = Get.put(HomeworkController());

  @override
  Widget build(BuildContext context) {
    final controller =
        _controller.pagingController
            as PagingController<int, HomeworkSubjectModel>;
    final firstPageKey = controller.firstPageKey;
    final nextPageKey = controller.nextPageKey ?? 0;
    return RefreshIndicator(
      onRefresh: () async => _controller.pagingController.refresh(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const .only(bottom: 12),
              child: FutureBuilder<List<HomeworkSubjectModel>>(
                future: _controller.getHomeworksForTodayForStudent(),
                builder: (context, response) {
                  if (response.connectionState != ConnectionState.done ||
                      !response.hasData) {
                    return Container();
                  }
                  final homeworkSubjects = response.data!;
                  return TodayHomeworksWidget(homeworkSubjects);
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
              builderDelegate: PagedChildBuilderDelegate<HomeworkSubjectModel>(
                itemBuilder: (context, item, index) {
                  return HomeworkSubjectCardWidget(
                    subject: item,
                    onPressed: () {
                      Get.toNamed(
                        ScreensUrls.studentHomeworksScreenUrl,
                        arguments: {'homeworks': item.homeworks!.toList()},
                      );
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

class TodayHomeworksWidget extends StatelessWidget {
  TodayHomeworksWidget(this.homeworkSubjects, {super.key});

  final controller = Get.put(HomeworkController());
  final gController = Get.find<GlobalController>();
  final List<HomeworkSubjectModel> homeworkSubjects;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openTodayHomeworks,
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
                  '${homeworkSubjects.fold(0, (previousValue, element) => element.homeworks?.length ?? 0)} ${AppLanguage.homeworksToday.tr}',
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

            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  void openTodayHomeworks() {
    if (homeworkSubjects.isNotEmpty) {
      Get.toNamed(
        ScreensUrls.studentHomeworksScreenUrl,
        arguments: {
          'homeworks': homeworkSubjects.fold(
            [],
            (previousValue, element) => element.homeworks!.toList(),
          ),
        },
      );
    } else {
      // controller.showNoHomeworksToast();
    }
  }
}
