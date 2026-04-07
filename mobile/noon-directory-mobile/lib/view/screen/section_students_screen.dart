import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/communication_controller.dart';
import 'package:noon/controllers/student_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';

import 'package:noon/core/localization/language.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:noon/view/widget/student_card_widget.dart';
import 'package:noon/view/widget/text_field_reuse_widget.dart';

class SectionStudentsScreen extends StatelessWidget {
  SectionStudentsScreen({super.key});

  final controller = Get.isRegistered<StudentController>()
      ? Get.find<StudentController>()
      : Get.put(StudentController());

  final comController = Get.isRegistered<CommunicationController>()
      ? Get.find<CommunicationController>()
      : Get.put(CommunicationController());

  @override
  Widget build(BuildContext context) {
    final bool isSelectionMode = Get.arguments?['isSelectionMode'] == true;

    return Scaffold(
      appBar: CustomAppBar(
        appBarName: isSelectionMode
            ? "تحديد الطلاب"
            : AppLanguage.studentsStr.tr,
        isLeading: true,
      ),
      body: Padding(
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
                  onChange: (val) => controller.updateSearchQuery(val),
                  suffixIcon: controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: AppColors.neutralMidGrey,
                          ),
                          onPressed: () {
                            controller.updateSearchQuery('');
                            controller.searchController.clear();
                          },
                        )
                      : null,
                ),
              ),
            ),
            SizedBox(height: getDynamicHeight(16)),
            if (isSelectionMode)
              Obx(
                () => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.mainColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "تحديد الكل",
                        style: AppTextStyles.bold14.copyWith(
                          color: AppColors.mainColor,
                        ),
                      ),
                      Checkbox(
                        value: controller.isAllStudentsSelected,
                        onChanged: (val) =>
                            controller.toggleStudentSelection(null),
                        activeColor: AppColors.mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: Obx(() {
                final students = controller.filteredStudents;
                if (students.isEmpty) {
                  return NoDataWidget(title: AppLanguage.studentsNotFound.tr);
                }
                return ListView.separated(
                  itemCount: students.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final student = students[index];

                    if (isSelectionMode) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.neutralWhite,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Obx(
                          () => ListTile(
                            onTap: () =>
                                controller.toggleStudentSelection(student),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: AppColors.mainColor.withValues(
                                alpha: 0.1,
                              ),
                              backgroundImage:
                                  student.photo != null &&
                                      student.photo!.isNotEmpty
                                  ? NetworkImage(student.photo!)
                                  : null,
                              child:
                                  (student.photo == null ||
                                      student.photo!.isEmpty)
                                  ? Text(
                                      student.fullName.isNotEmpty
                                          ? student.fullName[0]
                                          : 'S',
                                      style: AppTextStyles.bold14.copyWith(
                                        color: AppColors.mainColor,
                                      ),
                                    )
                                  : null,
                            ),
                            title: Text(
                              student.fullName,
                              style: AppTextStyles.bold14,
                            ),
                            trailing: Checkbox(
                              value: controller.isStudentSelected(student),
                              onChanged: (v) =>
                                  controller.toggleStudentSelection(student),
                              activeColor: AppColors.mainColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return StudentCard(
                      comController: comController,
                      id: student.id,
                      photoUrl: student.photo ?? '',
                      fullName: student.fullName,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isSelectionMode
          ? Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "حفظ التحديد و الإستمرار",
                  style: AppTextStyles.bold14.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
