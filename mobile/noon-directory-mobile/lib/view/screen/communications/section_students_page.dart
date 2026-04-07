import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/controllers/communication_controller.dart';
import 'package:noon/controllers/section_students_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/models/student_model.dart';
import 'package:noon/view/widget/error_message.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:noon/view/widget/retry_btn.dart';
import 'package:noon/view/widget/student_card_widget.dart';
import 'package:noon/view/widget/text_field_reuse_widget.dart';

class SectionStudentsPage extends StatelessWidget {
  final CommunicationController comController;

  SectionStudentsPage({super.key, required this.comController});

  final controller = Get.put(SectionStudentsController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .all(getDynamicWidth(20)),
      child: Column(
        children: [
          // Search Field
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
          SizedBox(height: getDynamicHeight(16)),

          // Section Filter Dropdown
          Obx(() {
            if (controller.isLoadingSections.value) {
              return const SizedBox(
                height: 48,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.sections.isEmpty) {
              return Container(
                padding: .symmetric(
                  horizontal: getDynamicWidth(12),
                  vertical: getDynamicHeight(12),
                ),
                decoration: BoxDecoration(
                  color: AppColors.neutralWhite,
                  borderRadius: .circular(12),
                ),
                child: Text(
                  AppLanguage.noInfoAvailable.tr,
                  style: const TextStyle(color: AppColors.neutralMidGrey),
                ),
              );
            }

            return Container(
              padding: .symmetric(horizontal: getDynamicWidth(12)),
              decoration: BoxDecoration(
                color: AppColors.neutralWhite,
                borderRadius: .circular(12),
              ),
              child: DropdownButton<Section>(
                value: controller.selectedSection.value,
                isExpanded: true,
                underline: const SizedBox(),
                hint: const Text('Select Section'),
                items: controller.sections.map((section) {
                  return DropdownMenuItem<Section>(
                    value: section,
                    child: Text(section.name ?? ''),
                  );
                }).toList(),
                onChanged: (section) => controller.onSectionChanged(section),
              ),
            );
          }),
          SizedBox(height: getDynamicHeight(24)),

          // Students List
          Expanded(
            child: Obx(() {
              if (controller.isLoadingSections.value) {
                return const Center(child: Loading());
              }

              if (controller.sections.isEmpty) {
                return NoDataWidget(title: AppLanguage.noInfoAvailable.tr);
              }

              return PagedListView.separated(
                shrinkWrap: true,
                pagingController: controller.pagingController,
                builderDelegate: PagedChildBuilderDelegate<StudentModel>(
                  itemBuilder: (context, item, index) {
                    return StudentCard(
                      comController: comController,
                      id: item.id,
                      photoUrl: item.photo ?? '',
                      fullName: item.fullName,
                    );
                  },
                  firstPageErrorIndicatorBuilder: (_) => ErrorMessage(
                    press: () {
                      controller.pagingController.refresh();
                    },
                    errorMsg: AppLanguage.errorStr.tr,
                  ),
                  newPageErrorIndicatorBuilder: (_) => RetryBtn(
                    press: () {
                      controller.pagingController.retryLastFailedRequest();
                    },
                  ),
                  firstPageProgressIndicatorBuilder: (_) => const Loading(),
                  newPageProgressIndicatorBuilder: (_) => const Loading(),
                  noItemsFoundIndicatorBuilder: (_) =>
                      NoDataWidget(title: AppLanguage.noInfoAvailable.tr),
                  noMoreItemsIndicatorBuilder: (_) => const SizedBox(),
                ),
                separatorBuilder: (_, _) =>
                    SizedBox(height: getDynamicHeight(12)),
              );
            }),
          ),
        ],
      ),
    );
  }
}
