import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.obscureText = false,
    required this.prefixIcon,
    required this.hintText,
    required this.validator,
    required this.textFieldController,
    this.suffixIcon,
    this.radius,
    this.suffixPressed,
    this.autofocus = false,
    this.keyboardType,
    this.autofillHints,
  });
  final bool obscureText, autofocus;
  final String prefixIcon;
  final String? suffixIcon;
  final String hintText;
  final double? radius;
  final TextEditingController textFieldController;
  final String? Function(String?)? validator;
  final Function()? suffixPressed;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textFieldController,
      autofocus: autofocus,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      magnifierConfiguration: TextMagnifierConfiguration.disabled,
      enableIMEPersonalizedLearning: false,
      enableSuggestions: !obscureText,
      autocorrect: !obscureText,
      obscureText: obscureText,
      spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFF1A202C).withValues(alpha: 0.12),
          ),
          borderRadius: .circular(radius ?? 12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFF1A202C).withValues(alpha: 0.12),
          ),
          borderRadius: .circular(radius ?? 12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFF1A202C).withValues(alpha: 0.12),
          ),
          borderRadius: .circular(radius ?? 12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFF1A202C).withValues(alpha: 0.12),
          ),
          borderRadius: .circular(radius ?? 12),
        ),
        prefixIcon: Padding(
          padding: const .symmetric(horizontal: 16),
          child: SvgPicture.asset(
            prefixIcon,
            width: 20,
            height: 20,
            colorFilter: .mode(
              AppColors.blackColor.withValues(alpha: 0.60),
              .srcIn,
            ),
          ),
        ),
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: suffixPressed,
                child: Padding(
                  padding: const .symmetric(horizontal: 16),
                  child: SvgPicture.asset(
                    height: 20,
                    width: 20,
                    suffixIcon!,
                    colorFilter: .mode(
                      AppColors.blackColor.withValues(alpha: 0.60),
                      .srcIn,
                    ),
                  ),
                ),
              )
            : null,
        hintText: hintText,
        hintStyle: AppTextStyles.medium14,
        isDense: true,
        contentPadding: const .symmetric(vertical: 16, horizontal: 24),
      ),
      validator: validator,
    );
  }
}
