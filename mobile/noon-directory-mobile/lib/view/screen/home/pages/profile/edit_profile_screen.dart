import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/global_controller.dart';
import '../../../../../controllers/profile_controller.dart';
import '../../../../../core/constant/app_sizes.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/device_utils.dart';
import '../../../../../core/enum.dart';
import '../../../../../core/localization/language.dart';
import '../../../../widget/bottom_navbar.dart';
import '../../../../widget/custom_appbar.dart';
import '../../../../widget/gender_container_widget.dart';
import '../../../../widget/text_field_reuse_widget.dart';
import '../../../attendances/widgets/datepicker_widget.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final controller = Get.find<ProfileController>();
  final gController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(),
        child: Scaffold(
          appBar: CustomAppBar(
            appBarName: AppLanguage.editProfileInformationStr.tr,
            isLeading: true,
          ),
          body: SizedBox(
            width: .infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: const .symmetric(vertical: 16, horizontal: 16),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      SizedBox(height: getDynamicHeight(20)),

                      Text(
                        AppLanguage.birthDateStr.tr,
                        style: AppTextStyles.medium14.copyWith(
                          color: AppTextStyles.medium14.color!.withValues(
                            alpha: 0.60,
                          ),
                        ),
                      ),
                      SizedBox(height: getDynamicHeight(6)),

                      Obx(() {
                        return DatepickerWidget(
                          isShowSearchIcon: false,
                          iconColor: Colors.teal,
                          textStyle: AppTextStyles.medium14.copyWith(
                            color: AppTextStyles.medium14.color!.withValues(
                              alpha: 0.60,
                            ),
                          ),
                          onTap: () => controller.pickDate(),
                          text: controller.selectedDate.value,
                        );
                      }),
                      SizedBox(height: getDynamicHeight(20)),

                      Text(
                        AppLanguage.phoneNumberStr.tr,
                        style: AppTextStyles.medium14.copyWith(
                          color: AppTextStyles.medium14.color!.withValues(
                            alpha: 0.60,
                          ),
                        ),
                      ),
                      SizedBox(height: getDynamicHeight(6)),

                      TextFieldReuse(
                        inputTupe: TextInputType.number,
                        controller: controller.phoneController,
                        onChange: (value) {
                          return controller.phone.value = value;
                        },
                        hint: '',
                      ),
                      SizedBox(height: getDynamicHeight(20)),

                      Text(
                        AppLanguage.emailStr.tr,
                        style: AppTextStyles.medium14.copyWith(
                          color: AppTextStyles.medium14.color!.withValues(
                            alpha: 0.60,
                          ),
                        ),
                      ),
                      SizedBox(height: getDynamicHeight(6)),

                      TextFieldReuse(
                        controller: controller.emailController,
                        onChange: (value) {
                          return controller.email.value = value;
                        },
                        hint: '',
                      ),

                      if (gController.isTeacher) ...[
                        SizedBox(height: getDynamicHeight(20)),
                        Text(
                          AppLanguage.genderStr.tr,
                          style: AppTextStyles.medium14.copyWith(
                            color: AppTextStyles.medium14.color!.withValues(
                              alpha: 0.60,
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: getDynamicHeight(6)),

                      if (gController.isTeacher)
                        Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => GenderContainer(
                                  gender: AppLanguage.maleStr.tr,
                                  isSelected:
                                      controller.selectedGender.value
                                          .toLowerCase() ==
                                      Gender.male.name.toLowerCase(),
                                  onTap: () {
                                    controller.selectedGender.value = Gender
                                        .male
                                        .name
                                        .toLowerCase();
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            Expanded(
                              child: Obx(
                                () => GenderContainer(
                                  gender: AppLanguage.femaleStr.tr,
                                  isSelected:
                                      controller.selectedGender.value
                                          .toLowerCase() ==
                                      Gender.female.name.toLowerCase(),
                                  onTap: () {
                                    controller.selectedGender.value = Gender
                                        .female
                                        .name
                                        .toLowerCase();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Obx(() {
            return IgnorePointer(
              ignoring: controller.loading.value,
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: BottomNavbar(
                  enable: controller.hasChanges,
                  loading: controller.loading.value,
                  text: AppLanguage.editStr.tr,
                  onTap: () => controller.updateUserById(),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
