import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noon/controllers/library_controller.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/device_utils.dart';
import 'package:noon/core/function.dart';
import 'package:noon/models/class_model.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/models/stage_model.dart';
import 'package:noon/view/widget/bottom_navbar.dart';
import 'package:noon/view/widget/bs_take_picture.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/custom_inkwell.dart';
import 'package:noon/view/widget/dropdown/generic_dropdown_widget.dart';
import '../../../core/localization/language.dart';

class AddfileTeacherScreen extends StatelessWidget {
  const AddfileTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LibraryController controller = Get.find();
    bool? isEdit = Get.arguments;

    return GestureDetector(
      onTap: () => DeviceUtils.hideKeyboard(),
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            appBarName: (isEdit != null && isEdit)
                ? AppLanguage.editStr.tr
                : AppLanguage.addFileStr.tr,
            isLeading: true,
            press: () {
              Get.back();
              controller.clearPreviseData();
            },
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: .symmetric(
                vertical: getDynamicHeight(20),
                horizontal: getDynamicHeight(16),
              ),
              child: Obx(
                () => Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      AppLanguage.addNextInfoLibraryStr.tr,
                      style: AppTextStyles.medium14.copyWith(
                        color: AppTextStyles.medium14.color!.withValues(
                          alpha: 0.87,
                        ),
                      ),
                    ),
                    SizedBox(height: getDynamicHeight(16)),
                    CustomGenericDropDown<Stage>(
                      content: controller.stages.toList(),
                      displayText: (item) => translateStage(item.name ?? ''),
                      onChanged: (v) {
                        controller.stageValue(v);
                        controller.classValue.value = null;
                        controller.classId.value = null;
                        controller.sectionValue.value = null;
                        controller.classes.clear();
                        controller.sections.clear();

                        if (v?.id != null) {
                          controller.getTeacherClass(v!.id);
                        }
                      },
                      hint: AppLanguage.stageStr.tr,
                      value: controller.stageValue.value,
                    ),
                    SizedBox(height: getDynamicHeight(16)),
                    CustomGenericDropDown<ClassInfo>(
                      onTap: () {
                        if (controller.classes.isEmpty) {
                          controller.showSnackbarOnce(
                            AppLanguage.warning.tr,
                            AppLanguage.mustSelectRandomly.tr,
                          );
                        }
                      },
                      content: controller.classes.toList(),
                      displayText: (item) => item.name ?? '',
                      onChanged: (v) {
                        controller.classValue(v);
                        controller.classId(v?.id);
                        controller.sectionValue.value = null;
                        controller.sections.clear();
                        if (v?.id != null) {
                          controller.getTeacherSection(v!.id);
                        }
                      },
                      hint: AppLanguage.academicStageWithOutSimiStr.tr,
                      value: controller.classValue.value,
                    ),
                    SizedBox(height: getDynamicHeight(16)),
                    SizedBox(height: getDynamicHeight(16)),
                    CustomGenericDropDown<Section>(
                      onTap: () {
                        if (!controller.loading.value &&
                            controller.sections.isEmpty) {
                          controller.showSnackbarOnce(
                            AppLanguage.warning.tr,
                            AppLanguage.thereIsNoSections.tr,
                          );
                        }

                        if (controller.classes.isEmpty ||
                            controller.stages.isEmpty) {
                          controller.showSnackbarOnce(
                            AppLanguage.warning.tr,
                            AppLanguage.mustSelectRandomly.tr,
                          );
                        }
                      },
                      content: controller.sections.toList(),
                      displayText: (item) => item.name ?? '',
                      onChanged: (v) {
                        controller.sectionValue(v);
                        controller.sectionId.value = v?.id;
                      },
                      hint: AppLanguage.divisionWithOutSimiStr.tr,
                      value: controller.sectionValue.value,
                    ),
                    SizedBox(height: getDynamicHeight(16)),

                    if (controller.sections.isNotEmpty) ...[
                      CheckboxListTile(
                        title: Text(
                          AppLanguage.sendToAllSectionsStr.tr,
                          style: AppTextStyles.medium14.copyWith(
                            color: AppTextStyles.medium14.color!.withValues(
                              alpha: 0.87,
                            ),
                          ),
                        ),
                        value: controller.sendToAllSections.value,
                        onChanged: (v) {
                          controller.sendToAllSections(v);
                        },
                      ),
                      SizedBox(height: getDynamicHeight(16)),
                    ],

                    TextFormField(
                      onChanged: (value) => controller.title.value = value,
                      controller: controller.titleController,
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(
                              0xFF1A202C,
                            ).withValues(alpha: 0.12),
                          ),
                          borderRadius: .circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(
                              0xFF1A202C,
                            ).withValues(alpha: 0.12),
                          ),
                          borderRadius: .circular(12),
                        ),
                        hintText: AppLanguage.titleStr.tr,
                        hintStyle: AppTextStyles.medium14.copyWith(
                          color: AppTextStyles.medium14.color!.withValues(
                            alpha: 0.60,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: getDynamicHeight(20)),
                    TextFormField(
                      onChanged: (value) =>
                          controller.description.value = value,
                      controller: controller.descController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(
                              0xFF1A202C,
                            ).withValues(alpha: 0.12),
                          ),
                          borderRadius: .circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(
                              0xFF1A202C,
                            ).withValues(alpha: 0.12),
                          ),
                          borderRadius: .circular(12),
                        ),
                        hintText: AppLanguage.descWithOutSimeColStr.tr,
                        hintStyle: AppTextStyles.medium14.copyWith(
                          color: AppTextStyles.medium14.color!.withValues(
                            alpha: 0.60,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: getDynamicHeight(20)),
                    Padding(
                      padding: const .all(8.0),
                      child: Obx(() {
                        return CustomInkwell(
                          onTap:
                              (controller.file.value != null ||
                                  controller.image.value != null)
                              ? null
                              : () => bsTakePicture(
                                  isShowFile: true,
                                  filePress: () => controller.getFile(),
                                  galleryPress: () =>
                                      controller.getImage(ImageSource.gallery),
                                  cameraPress: () =>
                                      controller.getImage(ImageSource.camera),
                                ),
                          child: DottedBorder(
                            options: RoundedRectDottedBorderOptions(
                              radius: const Radius.circular(12),
                              dashPattern: [6],
                              strokeWidth: 1.2,
                              color: const Color(
                                0xFF1A1A1A,
                              ).withValues(alpha: 0.20),
                            ),
                            child: Container(
                              height: getDynamicHeight(54),
                              width: .infinity,
                              alignment: .center,
                              child: Row(
                                mainAxisAlignment: .center,
                                children: [
                                  SvgPicture.asset(AppAssets.icAddPdfOrImg),
                                  const SizedBox(width: 8),
                                  Text(
                                    (controller.file.value != null ||
                                            controller.image.value != null)
                                        ? AppLanguage.fileUploaded.tr
                                        : AppLanguage.addFilePdfImgStr.tr,
                                    style: AppTextStyles.medium12.copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Obx(() {
            return IgnorePointer(
              ignoring: controller.loading.value,
              child: BottomNavbar(
                loading: controller.loading.value,
                text: (isEdit != null && isEdit)
                    ? AppLanguage.editStr.tr
                    : AppLanguage.addFileStr.tr,
                //ignore icon just add new file in edit file do not need ignore icon
                onTap: (controller.isFormValid.value && isEdit == null)
                    ? () async {
                        await controller.postFile();
                        controller.pagingController.refresh();
                      }
                    : (isEdit != null && isEdit)
                    ? () async {
                        await controller.patchFile();
                        controller.pagingController.refresh();
                      }
                    : null,
              ),
            );
          }),
        ),
      ),
    );
  }
}
