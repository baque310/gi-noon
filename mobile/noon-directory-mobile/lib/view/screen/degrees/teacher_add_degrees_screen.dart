import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/teacher_degrees_controller.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/custom_inkwell.dart';
import 'package:noon/view/widget/loading_button.dart';
import 'package:noon/view/widget/profile_image.dart';
import 'package:s_extensions/s_extensions.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_sizes.dart';
import '../../../core/localization/language.dart';

class TeacherAddDegreesScreen extends StatefulWidget {
  const TeacherAddDegreesScreen({super.key});

  @override
  State<TeacherAddDegreesScreen> createState() =>
      _TeacherAddDegreesScreenState();
}

class _TeacherAddDegreesScreenState extends State<TeacherAddDegreesScreen> {
  TeacherDegreesController controller = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getStudentNotHaveDegress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarName: AppLanguage.gradesStr.tr,
        isLeading: true,
        press: () => Get.back(),
        actions: [
          Obx(() {
            return controller.selectedStudents.isNotEmpty
                ? CustomInkwell(
                    onTap: () {
                      Get.bottomSheet(
                        const AddDegreeSheet(),
                        isScrollControlled: true,
                      );
                    },
                    child: const Center(
                      child: Padding(
                        padding: .symmetric(horizontal: 10),
                        child: Text(
                          "اضافة",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: .center,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.studentNotHaveDegrees.isEmpty) {
          return const Center(child: Text('لايوجد طلاب ليس لديهم درجات'));
        }
        return ListView.builder(
          itemCount: controller.studentNotHaveDegrees.length,
          itemBuilder: (context, index) {
            final student = controller.studentNotHaveDegrees[index];

            return Padding(
              padding: const .only(left: 16, top: 10, bottom: 0, right: 16),
              child: Obx(() {
                return ListTile(
                  contentPadding: const .symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  onTap: () {
                    controller.studentId.value = student.id;
                    Get.bottomSheet(
                      const AddDegreeSheet(),
                      isScrollControlled: true,
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: .circular(getDynamicHeight(12)),
                    side: BorderSide(
                      color: AppColors.blackColor.withValues(alpha: 0.12),
                      width: 0.5,
                    ),
                  ),
                  leading: ProfileImage(
                    firstCharFromName: student.fullName.substring(0, 1),
                    imageUrl: student.photo,
                  ),
                  trailing: Checkbox(
                    value: controller.selectedStudents.contains(student.id),
                    onChanged: (val) {
                      controller.toggleSelection(student.id);
                    },
                  ),
                  title: Text(student.fullName),
                );
              }),
            );
          },
        );
      }),
    );
  }
}

class AddDegreeSheet extends StatefulWidget {
  const AddDegreeSheet({super.key});

  @override
  State<AddDegreeSheet> createState() => _AddDegreeSheetState();
}

class _AddDegreeSheetState extends State<AddDegreeSheet> {
  final TextEditingController score = TextEditingController();

  final TextEditingController note = TextEditingController();

  final TeacherDegreesController controller = Get.find();

  @override
  void dispose() {
    score.dispose();
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const .only(
          topRight: .circular(32),
          topLeft: .circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: .min,
        children: [
          Container(
            margin: const .only(top: 10),
            width: 0.5.screenWidth,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: .circular(32),
              color: const Color(0xFFDDDDDD),
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const .symmetric(horizontal: 16, vertical: 32),
            children: [
              TextFormField(
                controller: score,
                decoration: const InputDecoration(hintText: "ادخل درجة الطالب"),
                keyboardType: .number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    if (newValue.text.isEmpty) {
                      return newValue;
                    }
                    final intValue = int.tryParse(newValue.text);
                    if (intValue != null && intValue >= 0 && intValue <= 100) {
                      return newValue;
                    }
                    return oldValue;
                  }),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: note,
                decoration: const InputDecoration(
                  hintText: "ادخل ملاحضة ان وجدت",
                ),
                keyboardType: .text,
                maxLines: 3,
              ),
            ],
          ),
          Padding(
            padding: const .symmetric(horizontal: 16, vertical: 16),
            child: Obx(() {
              return LoadingButton(
                isLoading: controller.loading.value,
                onPressed: () {
                  controller.addStudentDegreesMap(
                    .parse(score.text),
                    note.text,
                  );
                  controller.addStudentDegrees(.parse(score.text), note.text);
                },
                bgColor: AppColors.mainColor,
                text: AppLanguage.addStr.tr,
              );
            }),
          ),
        ],
      ),
    );
  }
}
