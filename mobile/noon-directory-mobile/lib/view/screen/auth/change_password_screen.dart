import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/login_controller.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/device_utils.dart';
import 'package:noon/core/function.dart';
import 'package:noon/view/screen/auth/widgets/custom_text_field.dart';
import 'package:noon/view/widget/loading_button.dart';

import '../../../core/localization/language.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final LoginController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: DeviceUtils.hideKeyboard,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const .all(16.0),
              child: Form(
                key: controller.formKey2,
                child: Column(
                  children: [
                    Text(
                      AppLanguage.passwordStr.tr,
                      style: AppTextStyles.bold20,
                    ),
                    Text(
                      AppLanguage.updatePassStr.tr,
                      style: AppTextStyles.medium14,
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      return CustomTextField(
                        suffixPressed: () {
                          controller.isPasswordVisible.value =
                              !controller.isPasswordVisible.value;
                        },
                        obscureText: controller.isPasswordVisible.value,
                        radius: 12,
                        hintText: AppLanguage.passwordStr.tr,
                        suffixIcon: controller.isPasswordVisible.value
                            ? AppAssets.icVisibilityOff
                            : AppAssets.icVisibility,
                        prefixIcon: AppAssets.icLock,
                        textFieldController: controller.passwordController2,
                        validator: (value) => updatePasswordValidation(value),
                      );
                    }),
                    SizedBox(height: getDynamicHeight(20)),
                    Obx(
                      () => LoadingButton(
                        isLoading: controller.isLoading.value,
                        bgColor: AppColors.mainColor,
                        onPressed: () {
                          controller.updatePassword();
                        },
                        text: AppLanguage.updateStr.tr,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
