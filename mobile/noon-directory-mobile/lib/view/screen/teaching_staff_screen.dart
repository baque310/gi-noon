import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/controllers/communication_controller.dart';
import 'package:noon/models/teaching_staff_model.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/controllers/teaching_staf_controller.dart';
import 'package:noon/view/widget/error_message.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:noon/view/widget/retry_btn.dart';
import 'package:noon/view/widget/teacher_card_widget.dart';
import 'package:noon/view/widget/text_field_reuse_widget.dart';

import '../../core/localization/language.dart';

class TeachingStaffScreen extends StatelessWidget {
  TeachingStaffScreen({super.key});
  final TeachingStafController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final controller = _controller.pagingController;
    final firstPageKey = controller.firstPageKey;
    final nextPageKey = controller.nextPageKey ?? 0;

    return Scaffold(
      appBar: CustomAppBar(
        appBarName: AppLanguage.teachingStaffStr1.tr,
        isLeading: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const .all(16.0),
              child: Obx(
                () => TextFieldReuse(
                  controller: _controller.searchController,
                  hint: AppLanguage.search.tr,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _controller.clearSearch(),
                        )
                      : null,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const .only(left: 16, top: 0, bottom: 24, right: 16),
            sliver: PagedSliverList(
              pagingController: controller,
              builderDelegate: PagedChildBuilderDelegate<TeachingStaffModel>(
                itemBuilder: (context, item, index) {
                  final subjects = item.teacherSubject
                      ?.map((e) => e.stageSubject?.subject?.name)
                      .where((name) => name != null)
                      .toList();
                  return Padding(
                    padding: const .only(bottom: 16),
                    child: TeacherCard(
                      comController: Get.put(CommunicationController()),
                      id: item.id,
                      gender: item.gender ?? '',
                      photoUrl: item.photo ?? '',
                      fullName: item.fullName ?? '',
                      subjects: subjects,
                    ),
                  );
                },
                firstPageErrorIndicatorBuilder: (_) => ErrorMessage(
                  press: () => _controller.getTeachers(firstPageKey),
                  errorMsg: AppLanguage.errorStr.tr,
                ),
                newPageErrorIndicatorBuilder: (_) =>
                    RetryBtn(press: () => _controller.getTeachers(nextPageKey)),
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
