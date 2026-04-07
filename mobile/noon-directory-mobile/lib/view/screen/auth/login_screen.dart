import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/login_controller.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/function.dart';
import 'package:noon/view/screen/auth/widgets/custom_text_field.dart';
import 'package:noon/view/widget/loading_button.dart';
import '../../../core/localization/language.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWhite,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const .all(24.0),
              child: Column(
                children: [
                  Obx(() {
                    if (controller.schoolLogo.value.isNotEmpty) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          controller.schoolLogo.value.startsWith('http') 
                              ? controller.schoolLogo.value 
                              : '${ApiUrls.filesUrl}/${controller.schoolLogo.value}',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(AppAssets.icAppLogo, width: 100, height: 100),
                        ),
                      );
                    }
                    return Image.asset(AppAssets.icAppLogo, width: 100, height: 100);
                  }),
                  const SizedBox(height: 16),

                  Obx(() {
                    if (controller.schoolName.value.isNotEmpty) {
                      return Text(
                        controller.schoolName.value,
                        style: AppTextStyles.bold20.copyWith(color: AppColors.mainColor),
                        textAlign: TextAlign.center,
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  const SizedBox(height: 8),

                  Text(AppLanguage.loginStr.tr, style: AppTextStyles.bold20),
                  Text(
                    AppLanguage.loginDescStr.tr,
                    style: AppTextStyles.medium14,
                  ),
                  const SizedBox(height: 24),

                  Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          autofillHints: const [AutofillHints.username],
                          keyboardType: TextInputType.text,
                          radius: 12,
                          hintText: AppLanguage.usernameStr.tr,
                          prefixIcon: AppAssets.icUser,
                          textFieldController: controller.usernameController,
                          validator: (value) => userNameValidation(value),
                        ),
                        const SizedBox(height: 8),

                        Obx(
                          () => CustomTextField(
                            autofillHints: const [AutofillHints.password],
                            keyboardType: TextInputType.visiblePassword,
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
                            textFieldController: controller.passwordController,
                            validator: (value) => passwordValidation(value),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Obx(
                    () => LoadingButton(
                      isLoading: controller.isLoading.value,
                      bgColor: AppColors.mainColor,
                      onPressed: () => controller.login(),
                      text: AppLanguage.loginStr.tr,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
