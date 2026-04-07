import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/controllers/communication_controller.dart';
import 'package:noon/controllers/teaching_staf_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/models/teaching_staff_model.dart';
import 'package:noon/view/widget/error_message.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:noon/view/widget/retry_btn.dart';
import 'package:noon/view/widget/teacher_card_widget.dart';
import 'package:noon/view/widget/text_field_reuse_widget.dart';

class TeachingStaffPage extends StatelessWidget {
  final CommunicationController comController;
  TeachingStaffPage({super.key, required this.comController});

  final controller = Get.find<TeachingStafController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .all(getDynamicWidth(20)),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.neutralWhite,
              borderRadius: .circular(12),
            ),
            child: Obx(
              () => TextFieldReuse(
                hint: AppLanguage.search.tr,
                controller: controller.searchController,
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.neutralMidGrey,
                ),
                suffixIcon: controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: AppColors.neutralMidGrey,
                        ),
                        onPressed: () => controller.clearSearch(),
                      )
                    : null,
              ),
            ),
          ),
          SizedBox(height: getDynamicHeight(24)),
          Expanded(
            child: PagedListView.separated(
              shrinkWrap: true,
              pagingController: controller.pagingController,
              builderDelegate: PagedChildBuilderDelegate<TeachingStaffModel>(
                itemBuilder: (context, item, index) {
                  final subjects = item.teacherSubject
                      ?.map((e) => e.stageSubject?.subject?.name)
                      .where((name) => name != null)
                      .toList();
                  return TeacherCard(
                    comController: comController,
                    id: item.id,
                    gender: item.gender ?? '',
                    photoUrl: item.photo ?? '',
                    fullName: item.fullName ?? '',
                    subjects: subjects,
                  );
                },
                firstPageErrorIndicatorBuilder: (_) => ErrorMessage(
                  press: () {
                    controller.getTeachers(
                      controller.pagingController.firstPageKey,
                    );
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
            ),
          ),
        ],
      ),
    );
  }
}
