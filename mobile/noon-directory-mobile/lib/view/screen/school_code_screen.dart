import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/school_code_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';

class SchoolCodeScreen extends GetView<SchoolCodeController> {
  const SchoolCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background gradient at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.primary.withValues(alpha: 0.05),
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Bottom Sheet Card
                Expanded(
                  flex: 8,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          // Drag handle
                          Container(
                            width: 48,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // School icon
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.school_rounded,
                              size: 42,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Title
                          Text(
                            'اربط حسابك بمدرستك الخاص',
                            style: AppTextStyles.bold20.copyWith(
                              color: AppColors.blackColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),

                          // Subtitle
                          Text(
                            'أدخل الرمز الذي قدمته لك مدرستك للوصول إلى مقرراتك\nوجداولك الدراسية',
                            style: AppTextStyles.regular14.copyWith(
                              color: Colors.grey.shade600,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 36),

                          // Code Input Field
                          Obx(() => _buildCodeInput()),
                          const SizedBox(height: 8),

                          // Error message
                          Obx(() {
                            if (controller.isError.value) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 4),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline,
                                        color: Colors.red, size: 16),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        controller.errorMessage.value,
                                        style:
                                            AppTextStyles.regular12.copyWith(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }),

                          const SizedBox(height: 24),

                          // Verify Button
                          Obx(() => _buildVerifyButton()),
                          const SizedBox(height: 16),

                          // Skip as Guest Button
                          _buildGuestButton(),
                          const SizedBox(height: 24),

                          // Help text
                          Text(
                            'لا تملك رمزاً؟ تواصل مع إدارة مدرستك',
                            style: AppTextStyles.regular12.copyWith(
                              color: Colors.grey.shade500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeInput() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: controller.isError.value
              ? Colors.red.withValues(alpha: 0.5)
              : AppColors.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: controller.codeController,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        style: AppTextStyles.bold20.copyWith(
          letterSpacing: 6,
          color: AppColors.primary,
        ),
        maxLength: 8,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
          UpperCaseTextFormatter(),
        ],
        decoration: InputDecoration(
          counterText: '',
          hintText: 'ادخل رمز المدرسة المكون من 6 أرقام',
          hintStyle: AppTextStyles.regular14.copyWith(
            color: Colors.grey.shade400,
            letterSpacing: 0,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          prefixIcon: Icon(
            Icons.vpn_key_rounded,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
        ),
        onChanged: (_) {
          // Clear error when user types
          if (controller.isError.value) {
            controller.isError.value = false;
            controller.errorMessage.value = '';
          }
        },
        onSubmitted: (_) => controller.verifySchoolCode(),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed:
            controller.isLoading.value ? null : controller.verifySchoolCode,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'تأكيد الرمز',
                    style: AppTextStyles.bold16.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_back, size: 20),
                ],
              ),
      ),
    );
  }

  Widget _buildGuestButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: controller.enterAsGuest,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          'تخطي للدخول كزائر',
          style: AppTextStyles.semiBold16.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

/// Formatter to convert input to uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
